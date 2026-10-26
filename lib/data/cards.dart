/// The 78-card deck. Keywords are written with a relationship lens and are
/// sent to the AI as grounding; the AI writes the reading in the user's
/// language. Malayalam card names need native review before launch.
enum Arcana { major, minor }

enum Suit { wands, cups, swords, pentacles }

class TarotCard {
  final String id;
  final Arcana arcana;
  final Suit? suit;
  final int number; // Major: 0–21. Minor: 1–14 (11 Page … 14 King).
  final String nameEn;
  final String nameMl;
  final List<String> upright;
  final List<String> reversed;

  const TarotCard({
    required this.id,
    required this.arcana,
    this.suit,
    required this.number,
    required this.nameEn,
    required this.nameMl,
    required this.upright,
    required this.reversed,
  });

  String name(String languageCode) => languageCode == 'ml' ? nameMl : nameEn;
}

const _majors = <(String, String, List<String>, List<String>)>[
  ('The Fool', 'വിഡ്ഢി',
      ['new beginning', 'open heart', 'trusting the leap'],
      ['recklessness', 'fear of starting', 'ignoring red flags']),
  ('The Magician', 'ജാലവിദ്യക്കാരൻ',
      ['you have what you need', 'clear intention', 'saying what you mean'],
      ['manipulation', 'mixed signals', 'unused potential']),
  ('The High Priestess', 'മഹാപുരോഹിത',
      ['intuition', 'what is unspoken', 'quiet inner knowing'],
      ['ignoring your gut', 'secrets', 'disconnection from self']),
  ('The Empress', 'ചക്രവർത്തിനി',
      ['nurturing', 'warmth', 'self-worth'],
      ['over-giving', 'smothering', 'neglecting yourself']),
  ('The Emperor', 'ചക്രവർത്തി',
      ['stability', 'healthy boundaries', 'commitment'],
      ['control', 'rigidity', 'power imbalance']),
  ('The Hierophant', 'ആചാര്യൻ',
      ['tradition', 'family values', 'shared beliefs'],
      ['pressure to conform', 'breaking expectations', 'values in conflict']),
  ('The Lovers', 'പ്രണയികൾ',
      ['deep connection', 'alignment', 'a meaningful choice'],
      ['disharmony', 'misaligned values', 'avoiding a choice']),
  ('The Chariot', 'രഥം',
      ['determination', 'moving forward together', 'willpower'],
      ['pulling in different directions', 'loss of direction', 'force']),
  ('Strength', 'ശക്തി',
      ['gentle courage', 'patience', 'compassion'],
      ['self-doubt', 'suppressed feelings', 'losing patience']),
  ('The Hermit', 'സന്യാസി',
      ['soul-searching', 'needing space', 'inner guidance'],
      ['isolation', 'withdrawal', 'loneliness']),
  ('Wheel of Fortune', 'ഭാഗ്യചക്രം',
      ['change', 'turning point', 'cycles'],
      ['resisting change', 'repeating patterns', 'feeling stuck']),
  ('Justice', 'നീതി',
      ['fairness', 'truth', 'accountability'],
      ['imbalance', 'blame', 'avoiding responsibility']),
  ('The Hanged Man', 'തൂക്കപ്പെട്ടവൻ',
      ['pause', 'new perspective', 'letting go of control'],
      ['waiting without end', 'stalling', 'martyrdom']),
  ('Death', 'മരണം',
      ['an ending that makes room', 'transformation', 'closure'],
      ['clinging to the past', 'fear of change', 'unfinished endings']),
  ('Temperance', 'സംയമനം',
      ['balance', 'patience', 'meeting in the middle'],
      ['extremes', 'imbalance', 'impatience']),
  ('The Devil', 'പിശാച്',
      ['attachment', 'unhealthy patterns', 'temptation'],
      ['breaking free', 'reclaiming yourself', 'awareness of a trap']),
  ('The Tower', 'ഗോപുരം',
      ['sudden truth', 'upheaval', 'illusions falling'],
      ['avoiding the inevitable', 'fear of disruption', 'slow collapse']),
  ('The Star', 'നക്ഷത്രം',
      ['hope', 'healing', 'renewed faith'],
      ['discouragement', 'losing hope', 'disconnection']),
  ('The Moon', 'ചന്ദ്രൻ',
      ['uncertainty', 'fears and projections', 'things not as they seem'],
      ['confusion lifting', 'truth emerging', 'facing fears']),
  ('The Sun', 'സൂര്യൻ',
      ['joy', 'openness', 'warmth and clarity'],
      ['dimmed joy', 'forced positivity', 'temporary clouds']),
  ('Judgement', 'വിധി',
      ['awakening', 'honest reckoning', 'a calling'],
      ['self-criticism', 'refusing to learn', 'doubt']),
  ('The World', 'ലോകം',
      ['completion', 'wholeness', 'a chapter closing well'],
      ['unfinished business', 'lack of closure', 'shortcuts']),
];

const _suitNames = {
  Suit.wands: ('Wands', 'ദണ്ഡുകളുടെ'),
  Suit.cups: ('Cups', 'കപ്പുകളുടെ'),
  Suit.swords: ('Swords', 'വാളുകളുടെ'),
  Suit.pentacles: ('Pentacles', 'നാണയങ്ങളുടെ'),
};

const _rankNames = [
  ('Ace', 'ഏസ്'), ('Two', 'രണ്ട്'), ('Three', 'മൂന്ന്'), ('Four', 'നാല്'),
  ('Five', 'അഞ്ച്'), ('Six', 'ആറ്'), ('Seven', 'ഏഴ്'), ('Eight', 'എട്ട്'),
  ('Nine', 'ഒൻപത്'), ('Ten', 'പത്ത്'), ('Page', 'പേജ്'), ('Knight', 'നൈറ്റ്'),
  ('Queen', 'രാജ്ഞി'), ('King', 'രാജാവ്'),
];

/// Keywords per suit, Ace → King: (upright, reversed).
const _minorKeywords = <Suit, List<(List<String>, List<String>)>>{
  Suit.wands: [
    (['spark of attraction', 'new passion'], ['fading spark', 'hesitation']),
    (['planning a future', 'choices ahead'], ['fear of the unknown', 'indecision']),
    (['looking ahead', 'growing together'], ['delays', 'disappointment']),
    (['celebration', 'home and belonging'], ['instability at home', 'transition']),
    (['friction', 'competing needs'], ['avoiding conflict', 'resolution']),
    (['recognition', 'confidence'], ['insecurity', 'need for validation']),
    (['standing your ground'], ['giving in', 'feeling overwhelmed']),
    (['swift news', 'momentum'], ['waiting', 'crossed messages']),
    (['resilience', 'guardedness'], ['exhaustion', 'walls too high']),
    (['carrying too much', 'burden'], ['setting it down', 'delegating']),
    (['curiosity', 'flirtation'], ['immaturity', 'mixed messages']),
    (['bold pursuit', 'adventure'], ['impulsiveness', 'inconsistency']),
    (['warm confidence', 'magnetism'], ['jealousy', 'insecurity']),
    (['leadership', 'vision'], ['domineering', 'impatience']),
  ],
  Suit.cups: [
    (['new love', 'emotional opening'], ['blocked feelings', 'self-love needed']),
    (['partnership', 'mutual attraction'], ['imbalance', 'disconnection']),
    (['friendship', 'support network'], ['third-party interference', 'gossip']),
    (['emotional withdrawal', 'reevaluation'], ['reconnecting', 'new awareness']),
    (['grief', 'focusing on loss'], ['acceptance', 'moving on']),
    (['nostalgia', 'innocence'], ['living in the past', 'moving forward']),
    (['fantasy', 'many options'], ['clarity', 'choosing reality']),
    (['walking away', 'seeking more'], ['fear of leaving', 'drifting']),
    (['contentment', 'wishes fulfilled'], ['unmet expectations', 'dissatisfaction']),
    (['harmony', 'family happiness'], ['broken ideals', 'family tension']),
    (['tender feelings', 'emotional message'], ['emotional immaturity', 'insecurity']),
    (['romance', 'charm'], ['moodiness', 'unrealistic expectations']),
    (['compassion', 'emotional depth'], ['emotional dependence', 'martyrdom']),
    (['emotional balance', 'kindness'], ['emotional manipulation', 'coldness']),
  ],
  Suit.swords: [
    (['clarity', 'breakthrough'], ['confusion', 'harsh words']),
    (['stalemate', 'avoiding a decision'], ['information overload', 'truth revealed']),
    (['heartbreak', 'painful truth'], ['healing', 'releasing pain']),
    (['rest', 'recovery'], ['restlessness', 'burnout']),
    (['conflict', 'winning at a cost'], ['reconciliation', 'making amends']),
    (['transition', 'leaving pain behind'], ['unresolved baggage', 'resistance']),
    (['deception', 'strategy'], ['coming clean', 'conscience']),
    (['feeling trapped', 'self-limiting beliefs'], ['release', 'new perspective']),
    (['anxiety', 'overthinking'], ['hope', 'reaching out']),
    (['painful ending', 'rock bottom'], ['recovery', 'regeneration']),
    (['curiosity', 'honest questions'], ['gossip', 'defensiveness']),
    (['rushing in', 'directness'], ['carelessness', 'cutting words']),
    (['independence', 'clear boundaries'], ['coldness', 'bitterness']),
    (['truth', 'clear thinking'], ['manipulation', 'cruelty']),
  ],
  Suit.pentacles: [
    (['stability', 'a solid start'], ['missed opportunity', 'insecurity']),
    (['balancing priorities'], ['overwhelm', 'neglecting the relationship']),
    (['teamwork', 'building together'], ['lack of effort', 'misalignment']),
    (['security', 'holding on'], ['possessiveness', 'letting go']),
    (['hardship', 'feeling left out'], ['recovery', 'finding support']),
    (['generosity', 'give and take'], ['one-sided giving', 'strings attached']),
    (['patience', 'long-term view'], ['impatience', 'wasted effort']),
    (['dedication', 'effort'], ['perfectionism', 'going through the motions']),
    (['self-sufficiency', 'self-worth'], ['over-dependence', 'insecurity']),
    (['legacy', 'family', 'long-term security'], ['family conflict', 'instability']),
    (['loyalty', 'steady intentions'], ['lack of progress', 'procrastination']),
    (['reliability', 'commitment'], ['stagnation', 'boredom']),
    (['practical care', 'nurturing'], ['self-neglect', 'smothering']),
    (['security', 'devotion'], ['materialism', 'stubbornness']),
  ],
};

List<TarotCard> _buildDeck() {
  final deck = <TarotCard>[];
  for (var i = 0; i < _majors.length; i++) {
    final (en, ml, up, rev) = _majors[i];
    deck.add(TarotCard(
      id: 'major_${i.toString().padLeft(2, '0')}',
      arcana: Arcana.major,
      number: i,
      nameEn: en,
      nameMl: ml,
      upright: up,
      reversed: rev,
    ));
  }
  for (final suit in Suit.values) {
    final (suitEn, suitMl) = _suitNames[suit]!;
    final keywords = _minorKeywords[suit]!;
    for (var r = 0; r < 14; r++) {
      final (rankEn, rankMl) = _rankNames[r];
      final (up, rev) = keywords[r];
      deck.add(TarotCard(
        id: '${suit.name}_${(r + 1).toString().padLeft(2, '0')}',
        arcana: Arcana.minor,
        suit: suit,
        number: r + 1,
        nameEn: '$rankEn of $suitEn',
        nameMl: '$suitMl $rankMl',
        upright: up,
        reversed: rev,
      ));
    }
  }
  return List.unmodifiable(deck);
}

final List<TarotCard> deck = _buildDeck();

final Map<String, TarotCard> cardsById = {for (final c in deck) c.id: c};
