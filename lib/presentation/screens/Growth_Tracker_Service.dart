import 'dart:collection';

class GrowthTrackerService {
  static final GrowthTrackerService _instance =
      GrowthTrackerService._internal();

  factory GrowthTrackerService() {
    return _instance;
  }

  GrowthTrackerService._internal();

  final Map<String, List<GrowthEntry>> _growthEntries = {};

  void addGrowthEntry(String plantId, GrowthEntry entry) {
    if (!_growthEntries.containsKey(plantId)) {
      _growthEntries[plantId] = [];
    }
    _growthEntries[plantId]!.add(entry);
  }

  List<GrowthEntry> getGrowthEntries(String plantId) {
    return _growthEntries[plantId] ?? [];
  }

  void removeGrowthEntry(String plantId, int index) {
    if (_growthEntries.containsKey(plantId) &&
        index >= 0 &&
        index < _growthEntries[plantId]!.length) {
      _growthEntries[plantId]!.removeAt(index);
    }
  }

  UnmodifiableMapView<String, List<GrowthEntry>> get allEntries =>
      UnmodifiableMapView(_growthEntries);
}

class GrowthEntry {
  final String plantId;
  final String plantName;
  final double height;
  final DateTime date;

  GrowthEntry({
    required this.plantId,
    required this.plantName,
    required this.height,
    required this.date,
  });
}
