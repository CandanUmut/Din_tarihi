class ProphetProfile {
  const ProphetProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.era,
    required this.region,
    required this.summary,
    this.heroImage,
    this.mapImage,
    required this.themes,
    required this.keyEvents,
    required this.virtues,
    required this.studyPrompts,
    required this.furtherReading,
  });

  factory ProphetProfile.fromJson(Map<String, dynamic> json) {
    return ProphetProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      era: json['era'] as String,
      region: json['region'] as String,
      summary: json['summary'] as String,
      heroImage: json['hero_image'] as String?,
      mapImage: json['map_image'] as String?,
      themes: (json['themes'] as List<dynamic>).cast<String>(),
      keyEvents: (json['key_events'] as List<dynamic>)
          .map((item) => ProphetEvent.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      virtues: (json['virtues'] as List<dynamic>).cast<String>(),
      studyPrompts: (json['study_prompts'] as List<dynamic>).cast<String>(),
      furtherReading: (json['further_reading'] as List<dynamic>).cast<String>(),
    );
  }

  final String id;
  final String name;
  final String title;
  final String era;
  final String region;
  final String summary;
  final String? heroImage;
  final String? mapImage;
  final List<String> themes;
  final List<ProphetEvent> keyEvents;
  final List<String> virtues;
  final List<String> studyPrompts;
  final List<String> furtherReading;
}

class ProphetEvent {
  const ProphetEvent({required this.title, required this.description});

  factory ProphetEvent.fromJson(Map<String, dynamic> json) {
    return ProphetEvent(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  final String title;
  final String description;
}
