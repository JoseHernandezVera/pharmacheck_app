class Remedy {
  final String name;
  final String time;
  bool isTaken;

  Remedy({
    required this.name,
    required this.time,
    this.isTaken = false,
  });
}