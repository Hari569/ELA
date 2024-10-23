class Contest {
  final String title;
  final String description; // Added description field
  final DateTime startDate;
  final DateTime endDate;
  final DateTime resultDate;
  final String imageUrl;
  bool isEnded;

  Contest({
    required this.title,
    required this.description, // Added to constructor
    required this.startDate,
    required this.endDate,
    required this.resultDate,
    required this.imageUrl,
    this.isEnded = false,
  });
}
