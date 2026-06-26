enum PersonStatus { online, talking, unavailable, quiet }

class PBXPerson {
  const PBXPerson({
    required this.name,
    required this.extension,
    required this.status,
    required this.statusText,
    this.detail,
  });

  final String name;
  final String extension;
  final PersonStatus status;
  final String statusText;
  final String? detail;
}
