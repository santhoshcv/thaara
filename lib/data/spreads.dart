/// Relationship spreads. Every position asks about the user's own side of
/// the story, never what the other person secretly thinks.
class SpreadPosition {
  final String en;
  final String ml;
  const SpreadPosition(this.en, this.ml);

  String label(String languageCode) => languageCode == 'ml' ? ml : en;
}

class Spread {
  final String id;
  final String titleEn;
  final String titleMl;
  final String blurbEn;
  final String blurbMl;
  final List<SpreadPosition> positions;

  const Spread({
    required this.id,
    required this.titleEn,
    required this.titleMl,
    required this.blurbEn,
    required this.blurbMl,
    required this.positions,
  });

  String title(String lc) => lc == 'ml' ? titleMl : titleEn;
  String blurb(String lc) => lc == 'ml' ? blurbMl : blurbEn;
}

const spreads = <Spread>[
  Spread(
    id: 'heart_of_it',
    titleEn: 'The heart of it',
    titleMl: 'ഉള്ളിന്റെ ഉള്ളിൽ',
    blurbEn: 'One card for what matters most right now.',
    blurbMl: 'ഇപ്പോൾ ഏറ്റവും പ്രധാനമായത് എന്തെന്ന് ഒരു കാർഡ്.',
    positions: [SpreadPosition('What matters most now', 'ഇപ്പോൾ ഏറ്റവും പ്രധാനം')],
  ),
  Spread(
    id: 'where_i_stand',
    titleEn: 'Where do I stand?',
    titleMl: 'ഞാൻ എവിടെ നിൽക്കുന്നു?',
    blurbEn: 'You, the connection, and what it asks of you.',
    blurbMl: 'നിങ്ങൾ, ഈ ബന്ധം, അത് നിങ്ങളോട് ആവശ്യപ്പെടുന്നത്.',
    positions: [
      SpreadPosition('How I am showing up', 'ഞാൻ ഈ ബന്ധത്തിൽ എങ്ങനെ'),
      SpreadPosition('The energy between us', 'ഞങ്ങൾക്കിടയിലെ ഊർജ്ജം'),
      SpreadPosition('What this asks of me', 'ഇത് എന്നോട് ആവശ്യപ്പെടുന്നത്'),
    ],
  ),
  Spread(
    id: 'what_i_need',
    titleEn: 'What do I need?',
    titleMl: 'എനിക്ക് എന്താണ് വേണ്ടത്?',
    blurbEn: 'Untangle what you feel from what you need.',
    blurbMl: 'തോന്നലും ആവശ്യവും വേർതിരിച്ചറിയാം.',
    positions: [
      SpreadPosition('What I feel', 'എനിക്ക് തോന്നുന്നത്'),
      SpreadPosition('What I truly need', 'എനിക്ക് ശരിക്കും വേണ്ടത്'),
      SpreadPosition('What would help', 'എന്ത് സഹായിക്കും'),
    ],
  ),
  Spread(
    id: 'stay_or_go',
    titleEn: 'Stay or let go?',
    titleMl: 'തുടരണോ, വിട്ടുകളയണോ?',
    blurbEn: 'See both sides clearly before you decide.',
    blurbMl: 'തീരുമാനിക്കുംമുമ്പ് രണ്ട് വശവും വ്യക്തമായി കാണാം.',
    positions: [
      SpreadPosition('What keeps me here', 'എന്നെ ഇവിടെ പിടിച്ചുനിർത്തുന്നത്'),
      SpreadPosition('What pulls me away', 'എന്നെ അകറ്റുന്നത്'),
      SpreadPosition("What I'm not seeing", 'ഞാൻ കാണാതെ പോകുന്നത്'),
      SpreadPosition('What I need to decide well', 'നല്ല തീരുമാനത്തിന് വേണ്ടത്'),
    ],
  ),
  Spread(
    id: 'healing',
    titleEn: 'Healing after hurt',
    titleMl: 'മുറിവിൽ നിന്ന് മുന്നോട്ട്',
    blurbEn: 'For breakups, distance, or a love that ended.',
    blurbMl: 'വേർപിരിയൽ, അകൽച്ച, അവസാനിച്ച പ്രണയം എന്നിവയ്ക്ക്.',
    positions: [
      SpreadPosition('What hurt me', 'എന്നെ വേദനിപ്പിച്ചത്'),
      SpreadPosition("What I'm learning", 'ഞാൻ പഠിക്കുന്നത്'),
      SpreadPosition('What is opening for me', 'എനിക്കായി തുറക്കുന്നത്'),
    ],
  ),
];

Spread spreadById(String id) =>
    spreads.firstWhere((s) => s.id == id, orElse: () => spreads.first);
