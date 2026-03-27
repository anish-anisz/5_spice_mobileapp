class TimeSlot {
  final String time;
  final int count;
  final bool selected;

  TimeSlot({
    required this.time,
    required this.count,
    this.selected = false,
  });
}
