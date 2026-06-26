enum SignalCategory {
  activity,
  insight,
  security,
  health,
  recommendation,
  moment
}

enum SignalImportance { feed, attention, important }

enum SignalState { active, updated, resolved, dismissed, archived }

class PulseSignal {
  const PulseSignal({
    required this.id,
    required this.kind,
    required this.category,
    required this.importance,
    required this.state,
    required this.title,
    required this.timeLabel,
    this.body,
    this.actionLabel,
    this.why = const [],
    this.technical = const {},
  });

  final String id;
  final String kind;
  final SignalCategory category;
  final SignalImportance importance;
  final SignalState state;
  final String title;
  final String? body;
  final String timeLabel;
  final String? actionLabel;
  final List<String> why;
  final Map<String, String> technical;

  PulseSignal copyWith({
    SignalCategory? category,
    SignalImportance? importance,
    SignalState? state,
    String? title,
    String? body,
    String? timeLabel,
    String? actionLabel,
    List<String>? why,
    Map<String, String>? technical,
  }) {
    return PulseSignal(
      id: id,
      kind: kind,
      category: category ?? this.category,
      importance: importance ?? this.importance,
      state: state ?? this.state,
      title: title ?? this.title,
      body: body ?? this.body,
      timeLabel: timeLabel ?? this.timeLabel,
      actionLabel: actionLabel ?? this.actionLabel,
      why: why ?? this.why,
      technical: technical ?? this.technical,
    );
  }
}
