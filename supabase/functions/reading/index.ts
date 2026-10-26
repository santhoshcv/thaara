// POST /functions/v1/reading
// Turns the drawn cards + the user's question into a reading with Claude,
// enforces the daily limits, and stores the result.

import { createClient } from "npm:@supabase/supabase-js@2";
import { corsHeaders, json } from "../_shared/http.ts";
import { looksLikeCrisis, readingTool, systemPrompt } from "../_shared/prompt.ts";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY")!;
const ANTHROPIC_MODEL = Deno.env.get("ANTHROPIC_MODEL") ?? "claude-sonnet-5-5";
const FREE_DAILY_READINGS = Number(Deno.env.get("FREE_DAILY_READINGS") ?? "3");

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

type CardIn = {
  card_id: string;
  name: string;
  name_ml: string;
  reversed: boolean;
  position: string;
  position_ml: string;
  keywords: string[];
};

type Body = {
  spread_id: string;
  spread_title: string;
  question: string;
  situation: string;
  locale: "en" | "ml";
  cards: CardIn[];
};

/** Start of "today" in India (IST, UTC+5:30), as an ISO timestamp. */
function startOfTodayIST(): string {
  const offsetMs = 5.5 * 60 * 60 * 1000;
  const ist = new Date(Date.now() + offsetMs);
  ist.setUTCHours(0, 0, 0, 0);
  return new Date(ist.getTime() - offsetMs).toISOString();
}

function questionKey(q: string): string {
  return q.toLowerCase().replace(/[^\p{L}\p{N}]+/gu, " ").trim();
}

function validate(b: unknown): Body | null {
  if (!b || typeof b !== "object") return null;
  const body = b as Body;
  if (typeof body.spread_id !== "string" || body.spread_id.length > 40) return null;
  if (!Array.isArray(body.cards) || body.cards.length < 1 || body.cards.length > 10) return null;
  body.question = String(body.question ?? "").slice(0, 500);
  body.situation = String(body.situation ?? "").slice(0, 1000);
  body.locale = body.locale === "ml" ? "ml" : "en";
  body.spread_title = String(body.spread_title ?? "").slice(0, 80);
  for (const c of body.cards) {
    if (typeof c.name !== "string" || typeof c.position !== "string") return null;
    c.keywords = Array.isArray(c.keywords) ? c.keywords.slice(0, 6).map(String) : [];
  }
  return body;
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);

  // Identify the caller from their JWT.
  const authHeader = req.headers.get("Authorization") ?? "";
  const userClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: authHeader } },
  });
  const { data: { user } } = await userClient.auth.getUser();
  if (!user) return json({ error: "unauthorized" }, 401);

  const body = validate(await req.json().catch(() => null));
  if (!body) return json({ error: "bad_request" }, 400);

  const admin = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);
  const since = startOfTodayIST();

  // Limits: a few readings a day, and no repeating the same question —
  // the app should support reflection, not compulsive checking.
  const { data: today, error: countError } = await admin
    .from("readings")
    .select("question_key")
    .eq("user_id", user.id)
    .gte("created_at", since);
  if (countError) return json({ error: "server_error" }, 500);

  // Someone in crisis is never told to come back tomorrow.
  const crisis = looksLikeCrisis(body.question, body.situation);
  const qKey = questionKey(body.question);
  if (!crisis && (today?.length ?? 0) >= FREE_DAILY_READINGS) {
    return json({ error: "daily_limit" }, 429);
  }
  if (!crisis && qKey && today?.some((r) => r.question_key === qKey)) {
    return json({ error: "same_question" }, 429);
  }

  // Ask Claude.
  const cardLines = body.cards
    .map((c, i) =>
      `${i}. Position: "${c.position}" — Card: ${c.name}${c.reversed ? " (reversed)" : ""}` +
      ` — Keywords: ${c.keywords.join(", ")}`
    )
    .join("\n");

  const userMessage = [
    `Spread: ${body.spread_title}`,
    `Question: ${body.question || "(no specific question; give a general reading for their relationship)"}`,
    `Situation: ${body.situation || "(not shared)"}`,
    "",
    "Cards drawn (in order):",
    cardLines,
  ].join("\n");

  let reading: {
    summary: string;
    card_insights: { index: number; insight: string }[];
    reflection_question: string;
    safety_flag: boolean;
  };

  try {
    const res = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      signal: AbortSignal.timeout(60_000),
      headers: {
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: ANTHROPIC_MODEL,
        max_tokens: 2000,
        system: systemPrompt(body.locale),
        tools: [readingTool],
        tool_choice: { type: "tool", name: readingTool.name },
        messages: [{ role: "user", content: userMessage }],
      }),
    });
    if (!res.ok) {
      console.error("anthropic_error", res.status, await res.text());
      return json({ error: "ai_unavailable" }, 502);
    }
    const data = await res.json();
    const toolUse = data.content?.find((b: { type: string }) => b.type === "tool_use");
    if (!toolUse?.input) return json({ error: "ai_bad_output" }, 502);
    reading = toolUse.input;
  } catch (e) {
    console.error("anthropic_exception", e);
    return json({ error: "ai_unavailable" }, 502);
  }

  // Assemble card names and positions ourselves, in the user's language,
  // so they always match exactly what was drawn.
  const ml = body.locale === "ml";
  const reversedLabel = ml ? " (തലകീഴായി)" : " (reversed)";
  const insights = body.cards.map((c, i) => ({
    position: ml ? c.position_ml || c.position : c.position,
    card: (ml ? c.name_ml || c.name : c.name) + (c.reversed ? reversedLabel : ""),
    insight: reading.card_insights?.find((x) => x.index === i)?.insight ?? "",
  }));

  const safetyFlag = Boolean(reading.safety_flag) || crisis;

  const result = {
    summary: reading.summary ?? "",
    cards: insights,
    reflection_question: reading.reflection_question ?? "",
  };

  const { data: row, error: insertError } = await admin
    .from("readings")
    .insert({
      user_id: user.id,
      spread_id: body.spread_id,
      question: body.question,
      question_key: qKey,
      situation: body.situation,
      locale: body.locale,
      cards: body.cards.map(({ card_id, reversed, position }) => ({ card_id, reversed, position })),
      result,
      safety_flag: safetyFlag,
    })
    .select("id")
    .single();
  if (insertError) {
    console.error("insert_error", insertError);
    return json({ error: "server_error" }, 500);
  }

  return json({ id: row.id, ...result, safety_flag: safetyFlag });
});
