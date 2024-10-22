class Event {
  final String id;
  final String title;
  final DateTime date;
  final String location;
  final int attendees;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.attendees,
  });
}
