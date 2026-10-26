import 'package:flutter/widgets.dart';

/// All user-facing text in one place, typed so a missing translation is a
/// compile error. Malayalam lines are first drafts: have a native writer
/// review them before launch (see README → Content review).
abstract class S {
  const S();

  static S of(BuildContext context) =>
      Localizations.of<S>(context, S) ?? const SEn();

  static const supportedLocales = [Locale('en'), Locale('ml')];
  static const delegate = _SDelegate();

  String get appName => 'Thaara';
  String get tagline;
  String get chooseLanguage;
  String get continueLabel;

  // Onboarding
  String get introTitle;
  String get introBody;
  String get introPrivacy;
  String get ageConfirm;
  String get begin;

  // Navigation
  String get navHome;
  String get navJournal;
  String get navSettings;

  // Home
  String get homeGreeting;
  String get startReading;
  String get recentReadings;
  String get noReadingsYet;

  // Reading flow
  String get chooseSpread;
  String get yourQuestion;
  String get questionHint;
  String get questionTip;
  String get situationLabel;
  String get situationHint;
  String get shuffleAndDraw;
  String get tapToReveal;
  String get readMyCards;
  String get readingLoading;
  String get reflectionQuestion;
  String get writeReflection;
  String get upright;
  String get reversed;
  String cardsCount(int n);

  // Journal
  String get journalTitle;
  String get journalEmpty;
  String get newEntry;
  String get moodPrompt;
  String get entryHint;
  String get save;
  String get saved;

  // Settings & safety
  String get settingsTitle;
  String get language;
  String get supportTitle;
  String get supportBody;
  String get about;
  String get disclaimer;
  String get privacyPolicy;
  String get deleteData;
  String get deleteConfirmTitle;
  String get deleteConfirmBody;
  String get cancel;
  String get delete;

  // Errors
  String get errorGeneric;
  String get errorLimit;
  String get errorSameQuestion;
  String get offline;
  String get retry;
}

class SEn extends S {
  const SEn();

  @override String get tagline => 'See your relationship clearly';
  @override String get chooseLanguage => 'Choose your language';
  @override String get continueLabel => 'Continue';

  @override String get introTitle => 'Clarity, not fortune-telling';
  @override String get introBody =>
      'Thaara uses tarot cards as a mirror. Each reading helps you understand '
      'your own feelings, needs and choices. It does not predict the future '
      "or read anyone else's mind.";
  @override String get introPrivacy =>
      'Private by default. No account, email or phone number needed.';
  @override String get ageConfirm =>
      'I am 18 or older, and I understand Thaara is for reflection, '
      'not prediction or professional advice.';
  @override String get begin => 'Begin';

  @override String get navHome => 'Home';
  @override String get navJournal => 'Journal';
  @override String get navSettings => 'Settings';

  @override String get homeGreeting => "What's on your heart today?";
  @override String get startReading => 'Start a reading';
  @override String get recentReadings => 'Your recent readings';
  @override String get noReadingsYet => 'Your readings will appear here.';

  @override String get chooseSpread => 'Choose a spread';
  @override String get yourQuestion => 'Your question (optional)';
  @override String get questionHint =>
      'e.g. What do I need to understand about where we stand?';
  @override String get questionTip =>
      'Questions about yourself bring more clarity than questions about '
      'what someone else is thinking.';
  @override String get situationLabel => 'Anything Thaara should know? (optional)';
  @override String get situationHint => 'A few words about your situation';
  @override String get shuffleAndDraw => 'Shuffle & draw';
  @override String get tapToReveal => 'Tap each card to turn it over';
  @override String get readMyCards => 'Read my cards';
  @override String get readingLoading => 'Thaara is reading your cards…';
  @override String get reflectionQuestion => 'A question for you';
  @override String get writeReflection => 'Write in your journal';
  @override String get upright => 'Upright';
  @override String get reversed => 'Reversed';
  @override String cardsCount(int n) => n == 1 ? '1 card' : '$n cards';

  @override String get journalTitle => 'Journal';
  @override String get journalEmpty =>
      'Write freely. Over time you will notice how your feelings change.';
  @override String get newEntry => 'New entry';
  @override String get moodPrompt => 'How are you feeling?';
  @override String get entryHint => "What's on your mind…";
  @override String get save => 'Save';
  @override String get saved => 'Saved';

  @override String get settingsTitle => 'Settings';
  @override String get language => 'Language';
  @override String get supportTitle => 'Need someone to talk to?';
  @override String get supportBody =>
      'If you feel unsafe, hopeless, or someone is hurting you, please reach '
      'out. You deserve support from a real person.';
  @override String get about => 'About Thaara';
  @override String get disclaimer =>
      'Thaara is for reflection and entertainment. It does not predict the '
      'future and is not a substitute for professional advice.';
  @override String get privacyPolicy => 'Privacy policy';
  @override String get deleteData => 'Delete all my data';
  @override String get deleteConfirmTitle => 'Delete everything?';
  @override String get deleteConfirmBody =>
      'This permanently deletes your readings, journal and account. '
      'It cannot be undone.';
  @override String get cancel => 'Cancel';
  @override String get delete => 'Delete';

  @override String get errorGeneric => 'Something went wrong. Please try again.';
  @override String get errorLimit =>
      "You've had today's readings. Come back tomorrow. Sometimes clarity "
      'comes from sitting with what you already have.';
  @override String get errorSameQuestion =>
      'You asked this today already. Try writing in your journal about what '
      'came up instead.';
  @override String get offline => 'You seem to be offline.';
  @override String get retry => 'Retry';
}

class SMl extends S {
  const SMl();

  @override String get tagline => 'നിങ്ങളുടെ ബന്ധം തെളിഞ്ഞു കാണാം';
  @override String get chooseLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';
  @override String get continueLabel => 'തുടരുക';

  @override String get introTitle => 'ഭാവി പ്രവചനമല്ല, മനസ്സിന്റെ വ്യക്തത';
  @override String get introBody =>
      'താര ടാരോട്ട് കാർഡുകളെ ഒരു കണ്ണാടിയായി ഉപയോഗിക്കുന്നു. ഓരോ വായനയും '
      'നിങ്ങളുടെ സ്വന്തം വികാരങ്ങളും ആവശ്യങ്ങളും തീരുമാനങ്ങളും മനസ്സിലാക്കാൻ '
      'സഹായിക്കും. ഇത് ഭാവി പ്രവചിക്കുകയോ മറ്റൊരാളുടെ മനസ്സ് വായിക്കുകയോ ചെയ്യുന്നില്ല.';
  @override String get introPrivacy =>
      'പൂർണ്ണമായും സ്വകാര്യം. അക്കൗണ്ടോ ഇമെയിലോ ഫോൺ നമ്പറോ വേണ്ട.';
  @override String get ageConfirm =>
      'എനിക്ക് 18 വയസ്സോ അതിൽ കൂടുതലോ ഉണ്ട്. താര സ്വയം ചിന്തിക്കാനുള്ളതാണ്, '
      'പ്രവചനമോ പ്രൊഫഷണൽ ഉപദേശമോ അല്ലെന്ന് ഞാൻ മനസ്സിലാക്കുന്നു.';
  @override String get begin => 'ആരംഭിക്കാം';

  @override String get navHome => 'ഹോം';
  @override String get navJournal => 'ഡയറി';
  @override String get navSettings => 'ക്രമീകരണം';

  @override String get homeGreeting => 'ഇന്ന് മനസ്സിൽ എന്താണ്?';
  @override String get startReading => 'വായന തുടങ്ങാം';
  @override String get recentReadings => 'സമീപകാല വായനകൾ';
  @override String get noReadingsYet => 'നിങ്ങളുടെ വായനകൾ ഇവിടെ കാണാം.';

  @override String get chooseSpread => 'ഒരു സ്പ്രെഡ് തിരഞ്ഞെടുക്കുക';
  @override String get yourQuestion => 'നിങ്ങളുടെ ചോദ്യം (ആവശ്യമെങ്കിൽ)';
  @override String get questionHint =>
      'ഉദാ: ഞങ്ങൾ ഇപ്പോൾ എവിടെ നിൽക്കുന്നു എന്നതിനെക്കുറിച്ച് ഞാൻ എന്ത് മനസ്സിലാക്കണം?';
  @override String get questionTip =>
      'മറ്റൊരാൾ എന്ത് ചിന്തിക്കുന്നു എന്നതിനേക്കാൾ, നിങ്ങളെക്കുറിച്ചുള്ള ചോദ്യങ്ങൾ '
      'കൂടുതൽ വ്യക്തത തരും.';
  @override String get situationLabel => 'താര അറിയേണ്ട എന്തെങ്കിലും? (ആവശ്യമെങ്കിൽ)';
  @override String get situationHint => 'നിങ്ങളുടെ സാഹചര്യം കുറച്ച് വാക്കുകളിൽ';
  @override String get shuffleAndDraw => 'കാർഡുകൾ കുലുക്കി എടുക്കാം';
  @override String get tapToReveal => 'ഓരോ കാർഡും തൊട്ട് മറിക്കുക';
  @override String get readMyCards => 'എന്റെ കാർഡുകൾ വായിക്കൂ';
  @override String get readingLoading => 'താര നിങ്ങളുടെ കാർഡുകൾ വായിക്കുന്നു…';
  @override String get reflectionQuestion => 'നിങ്ങളോടുള്ള ഒരു ചോദ്യം';
  @override String get writeReflection => 'ഡയറിയിൽ എഴുതാം';
  @override String get upright => 'നേരെ';
  @override String get reversed => 'തലകീഴായി';
  @override String cardsCount(int n) => '$n കാർഡ്';

  @override String get journalTitle => 'ഡയറി';
  @override String get journalEmpty =>
      'മനസ്സ് തുറന്ന് എഴുതൂ. കാലക്രമേണ നിങ്ങളുടെ വികാരങ്ങൾ മാറുന്നത് കാണാം.';
  @override String get newEntry => 'പുതിയ കുറിപ്പ്';
  @override String get moodPrompt => 'ഇപ്പോൾ എങ്ങനെ തോന്നുന്നു?';
  @override String get entryHint => 'മനസ്സിലുള്ളത് എഴുതൂ…';
  @override String get save => 'സേവ് ചെയ്യുക';
  @override String get saved => 'സേവ് ചെയ്തു';

  @override String get settingsTitle => 'ക്രമീകരണം';
  @override String get language => 'ഭാഷ';
  @override String get supportTitle => 'ആരോടെങ്കിലും സംസാരിക്കണോ?';
  @override String get supportBody =>
      'നിങ്ങൾക്ക് സുരക്ഷിതമല്ലെന്നോ പ്രതീക്ഷയില്ലെന്നോ തോന്നുന്നുവെങ്കിൽ, അല്ലെങ്കിൽ '
      'ആരെങ്കിലും നിങ്ങളെ വേദനിപ്പിക്കുന്നുവെങ്കിൽ, ദയവായി സഹായം തേടുക. '
      'ഒരു യഥാർത്ഥ വ്യക്തിയുടെ പിന്തുണ നിങ്ങൾ അർഹിക്കുന്നു.';
  @override String get about => 'താരയെക്കുറിച്ച്';
  @override String get disclaimer =>
      'താര സ്വയം ചിന്തിക്കാനും വിനോദത്തിനും വേണ്ടിയുള്ളതാണ്. ഇത് ഭാവി '
      'പ്രവചിക്കുന്നില്ല, പ്രൊഫഷണൽ ഉപദേശത്തിന് പകരവുമല്ല.';
  @override String get privacyPolicy => 'സ്വകാര്യതാ നയം';
  @override String get deleteData => 'എന്റെ എല്ലാ വിവരങ്ങളും ഇല്ലാതാക്കുക';
  @override String get deleteConfirmTitle => 'എല്ലാം ഇല്ലാതാക്കണോ?';
  @override String get deleteConfirmBody =>
      'നിങ്ങളുടെ വായനകളും ഡയറിയും അക്കൗണ്ടും എന്നെന്നേക്കുമായി ഇല്ലാതാകും. '
      'ഇത് തിരിച്ചെടുക്കാനാവില്ല.';
  @override String get cancel => 'വേണ്ട';
  @override String get delete => 'ഇല്ലാതാക്കുക';

  @override String get errorGeneric => 'എന്തോ പിശക് സംഭവിച്ചു. വീണ്ടും ശ്രമിക്കൂ.';
  @override String get errorLimit =>
      'ഇന്നത്തെ വായനകൾ കഴിഞ്ഞു. നാളെ വരൂ. ചിലപ്പോൾ, കിട്ടിയതിനെക്കുറിച്ച് '
      'ശാന്തമായി ചിന്തിക്കുമ്പോഴാണ് വ്യക്തത വരുന്നത്.';
  @override String get errorSameQuestion =>
      'ഈ ചോദ്യം ഇന്ന് നേരത്തെ ചോദിച്ചു. പകരം, മനസ്സിൽ തോന്നിയത് ഡയറിയിൽ എഴുതി നോക്കൂ.';
  @override String get offline => 'ഇന്റർനെറ്റ് കണക്ഷൻ ഇല്ലെന്ന് തോന്നുന്നു.';
  @override String get retry => 'വീണ്ടും ശ്രമിക്കുക';
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  bool isSupported(Locale locale) =>
      S.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<S> load(Locale locale) async =>
      locale.languageCode == 'ml' ? const SMl() : const SEn();

  @override
  bool shouldReload(_SDelegate old) => false;
}
