class SessionModel {
  const SessionModel({
    required this.id,
    required this.minutes,
    required this.date,
  });

  final String id;
  final int minutes;
  final DateTime date;
}
