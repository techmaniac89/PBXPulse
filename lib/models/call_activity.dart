enum CallActivityKind { active, answered, missed, voicemail }

class CallActivity {
  const CallActivity({
    required this.title,
    required this.timeLabel,
    this.body,
    this.isActive = false,
    this.kind = CallActivityKind.answered,
  });

  final String title;
  final String? body;
  final String timeLabel;
  final bool isActive;
  final CallActivityKind kind;
}
