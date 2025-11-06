import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const supportedLocales = [Locale('en'), Locale('tr')];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Dinhistory',
      'action_start_learning': 'Start learning',
      'action_continue': 'Continue',
      'onboarding_title': 'Learn faith & history',
      'choose_language': 'Choose your language',
      'daily_goal_title': 'Set a daily goal',
      'minutes_per_day': '{minutes} min/day',
      'privacy_note': 'We never sell data. Everything stays on your device.',
      'finish': 'Finish',
      'home_greeting': 'Assalamu alaikum',
      'streak_today_done': "Today's study done",
      'completion_rate': 'Completion rate',
      'explore': 'Explore',
      'lessons': 'Lessons',
      'history': 'History',
      'research': 'Research',
      'profile': 'Profile',
      'bookmarks': 'Bookmarks',
      'quiz': 'Quiz',
      'flashcards': 'Flashcards',
      'read_now': 'Read now',
      'mark_done': 'Mark as done',
      'daily_goal_prompt': 'How many minutes would you like to learn daily?',
      'reminder_banner': 'Enable reminders to keep your streak thriving.',
      'search_hint': 'Search lessons, prophets, or themes',
      'empty_state': 'Nothing here yet',
      'error_state': 'Something went wrong',
      'language_turkish': 'Turkish',
      'language_english': 'English',
      'continue_learning': 'Continue where you left',
      'streak_days': '{days} day streak',
      'overall_progress': 'Overall progress',
      'reminders': 'Reminders',
      'settings': 'Settings',
      'achievements': 'Achievements',
      'toggle_academic_sidebar': 'Academic sidebar',
      'lesson_quiz_title': 'Check your understanding',
      'answer_correct': 'Correct!',
      'answer_incorrect': 'Try again',
      'set_reminder': 'Set reminder',
      'reminder_time_label': 'Reminder time',
      'language': 'Language',
      'daily_goal': 'Daily goal',
      'save': 'Save',
      'timeline_title': 'Prophetic timeline',
      'map_notes': 'Map notes',
      'today': 'Today',
      'search_results': 'Search results',
    },
    'tr': {
      'app_title': 'Dinhistory',
      'action_start_learning': 'Öğrenmeye başla',
      'action_continue': 'Devam et',
      'onboarding_title': 'Din ve tarihi öğren',
      'choose_language': 'Dilini seç',
      'daily_goal_title': 'Günlük hedef belirle',
      'minutes_per_day': 'Günde {minutes} dk',
      'privacy_note': 'Verini satmıyoruz. Her şey cihazında kalır.',
      'finish': 'Bitir',
      'home_greeting': 'Selamun aleyküm',
      'streak_today_done': 'Bugünkü çalışma tamam',
      'completion_rate': 'Tamamlama oranı',
      'explore': 'Keşfet',
      'lessons': 'Dersler',
      'history': 'Tarih',
      'research': 'Araştırma',
      'profile': 'Profil',
      'bookmarks': 'Kaydedilenler',
      'quiz': 'Quiz',
      'flashcards': 'Kartlar',
      'read_now': 'Şimdi oku',
      'mark_done': 'Tamamlandı',
      'daily_goal_prompt': 'Günde kaç dakika öğrenmek istersin?',
      'reminder_banner': 'Serini korumak için hatırlatmaları aç.',
      'search_hint': 'Ders, peygamber veya tema ara',
      'empty_state': 'Henüz içerik yok',
      'error_state': 'Bir şeyler ters gitti',
      'language_turkish': 'Türkçe',
      'language_english': 'İngilizce',
      'continue_learning': 'Kaldığın yerden devam et',
      'streak_days': '{days} günlük seri',
      'overall_progress': 'Genel ilerleme',
      'reminders': 'Hatırlatmalar',
      'settings': 'Ayarlar',
      'achievements': 'Başarılar',
      'toggle_academic_sidebar': 'Akademik kenar',
      'lesson_quiz_title': 'Bilgini yokla',
      'answer_correct': 'Doğru!',
      'answer_incorrect': 'Tekrar dene',
      'set_reminder': 'Hatırlatma ayarla',
      'reminder_time_label': 'Hatırlatma saati',
      'language': 'Dil',
      'daily_goal': 'Günlük hedef',
      'save': 'Kaydet',
      'timeline_title': 'Peygamberler kronolojisi',
      'map_notes': 'Harita notları',
      'today': 'Bugün',
      'search_results': 'Arama sonuçları',
    },
  };

  String _translate(String key) {
    final languageCode = locale.languageCode;
    final values = _localizedValues[languageCode] ?? _localizedValues['en']!;
    return values[key] ?? key;
  }

  String get appTitle => _translate('app_title');
  String get actionStartLearning => _translate('action_start_learning');
  String get actionContinue => _translate('action_continue');
  String get onboardingTitle => _translate('onboarding_title');
  String get chooseLanguage => _translate('choose_language');
  String get dailyGoalTitle => _translate('daily_goal_title');
  String minutesPerDay(int minutes) =>
      _translate('minutes_per_day').replaceFirst('{minutes}', minutes.toString());
  String get privacyNote => _translate('privacy_note');
  String get finish => _translate('finish');
  String get homeGreeting => _translate('home_greeting');
  String get streakTodayDone => _translate('streak_today_done');
  String get completionRate => _translate('completion_rate');
  String get explore => _translate('explore');
  String get lessons => _translate('lessons');
  String get history => _translate('history');
  String get research => _translate('research');
  String get profile => _translate('profile');
  String get bookmarks => _translate('bookmarks');
  String get quiz => _translate('quiz');
  String get flashcards => _translate('flashcards');
  String get readNow => _translate('read_now');
  String get markDone => _translate('mark_done');
  String get dailyGoalPrompt => _translate('daily_goal_prompt');
  String get reminderBanner => _translate('reminder_banner');
  String get searchHint => _translate('search_hint');
  String get emptyState => _translate('empty_state');
  String get errorState => _translate('error_state');
  String get languageTurkish => _translate('language_turkish');
  String get languageEnglish => _translate('language_english');
  String get continueLearning => _translate('continue_learning');
  String streakDays(int days) =>
      _translate('streak_days').replaceFirst('{days}', days.toString());
  String get overallProgress => _translate('overall_progress');
  String get reminders => _translate('reminders');
  String get settings => _translate('settings');
  String get achievements => _translate('achievements');
  String get toggleAcademicSidebar => _translate('toggle_academic_sidebar');
  String get lessonQuizTitle => _translate('lesson_quiz_title');
  String get answerCorrect => _translate('answer_correct');
  String get answerIncorrect => _translate('answer_incorrect');
  String get setReminder => _translate('set_reminder');
  String get reminderTimeLabel => _translate('reminder_time_label');
  String get language => _translate('language');
  String get dailyGoal => _translate('daily_goal');
  String get save => _translate('save');
  String get timelineTitle => _translate('timeline_title');
  String get mapNotes => _translate('map_notes');
  String get today => _translate('today');
  String get searchResults => _translate('search_results');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
