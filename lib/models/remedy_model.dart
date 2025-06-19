class Remedy {
  String name;
  String time;
  bool isTaken;

  Remedy({
    required this.name,
    required this.time,
    this.isTaken = false,
  });
}