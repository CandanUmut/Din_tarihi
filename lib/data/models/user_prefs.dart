class UserPrefs {
  const UserPrefs({
    required this.id,
    required this.lang,
    required this.dailyGoal,
    required this.onboardingDone,
    required this.reminderHour,
    required this.reminderMinute,
  });

  factory UserPrefs.fromJson(Map<String, dynamic> json) {
    return UserPrefs(
      id: json['id'] as String,
      lang: json['lang'] as String,
      dailyGoal: json['dailyGoal'] as int,
      onboardingDone: json['onboardingDone'] as bool,
      reminderHour: json['reminderHour'] as int,
      reminderMinute: json['reminderMinute'] as int,
    );
  }

  final String id;
  final String lang;
  final int dailyGoal;
  final bool onboardingDone;
  final int reminderHour;
  final int reminderMinute;

  UserPrefs copyWith({
    String? lang,
    int? dailyGoal,
    bool? onboardingDone,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return UserPrefs(
      id: id,
      lang: lang ?? this.lang,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lang': lang,
        'dailyGoal': dailyGoal,
        'onboardingDone': onboardingDone,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
      };

  static const defaultPrefs = UserPrefs(
    id: 'me',
    lang: 'en',
    dailyGoal: 10,
    onboardingDone: false,
    reminderHour: 20,
    reminderMinute: 0,
  );
}
