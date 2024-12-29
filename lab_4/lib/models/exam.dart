class ExamLocation {
  final double latitude;
  final double longitude;
  final String address;

  ExamLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class Exam {
  final String subject;
  final DateTime dateTime;
  final ExamLocation location;
  final double reminderRadius; // in meters
  bool hasTriggeredReminder;

  Exam({
    required this.subject,
    required this.dateTime,
    required this.location,
    this.reminderRadius = 500,
    this.hasTriggeredReminder = false,
  });
}