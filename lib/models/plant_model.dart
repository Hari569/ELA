class Plant {
  final String name;
  final String species;
  final String sunlight;
  final String water;
  final String fertilization;
  final String pruning;
  final List<GrowthPhoto> growthPhotos;

  Plant({
    required this.name,
    required this.species,
    required this.sunlight,
    required this.water,
    required this.fertilization,
    required this.pruning,
    required this.growthPhotos,
  });
}

class GrowthPhoto {
  final String imagePath;
  final DateTime dateTaken;

  GrowthPhoto({required this.imagePath, required this.dateTaken});
}
