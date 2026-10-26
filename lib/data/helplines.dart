/// Support contacts shown when a reading touches on danger or crisis, and in
/// Settings. VERIFY every number before each release; they change.
class Helpline {
  final String nameEn;
  final String nameMl;
  final String number;
  final String forEn;
  final String forMl;
  const Helpline(this.nameEn, this.nameMl, this.number, this.forEn, this.forMl);
}

const helplines = <Helpline>[
  Helpline('Tele-MANAS', 'ടെലി-മനസ്', '14416',
      'Free mental health support, 24/7, in Malayalam and English',
      'സൗജന്യ മാനസികാരോഗ്യ സഹായം, 24 മണിക്കൂറും, മലയാളത്തിലും'),
  Helpline('DISHA (Kerala)', 'ദിശ (കേരളം)', '1056',
      'Kerala health and counselling helpline',
      'കേരള ആരോഗ്യ, കൗൺസലിംഗ് ഹെൽപ്‌ലൈൻ'),
  Helpline('Women Helpline', 'വനിതാ ഹെൽപ്‌ലൈൻ', '181',
      'If someone is hurting or threatening you',
      'ആരെങ്കിലും നിങ്ങളെ ഉപദ്രവിക്കുകയോ ഭീഷണിപ്പെടുത്തുകയോ ചെയ്യുന്നുവെങ്കിൽ'),
  Helpline('Emergency', 'അടിയന്തരം', '112',
      'Immediate danger', 'ഉടനടി അപകടം'),
];
