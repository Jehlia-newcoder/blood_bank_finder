class PhLocationData {
  static const List<String> islandGroups = ['Luzon', 'Visayas', 'Mindanao'];

  static const Map<String, List<String>> cities = {
    'Luzon': ['Manila', 'Quezon City', 'Baguio', 'Angeles', 'Tagaytay'],
    'Visayas': ['Cebu City', 'Iloilo City', 'Bacolod', 'Tacloban', 'Dumaguete'],
    'Mindanao': [
      'Davao City',
      'Zamboanga',
      'Cagayan de Oro',
      'General Santos',
      'Butuan',
    ],
  };

  static const Map<String, List<String>> barangays = {
    'Manila': ['Binondo', 'Ermita', 'Malate', 'Quiapo', 'Sampaloc'],
    'Quezon City': [
      'Batasan Hills',
      'Commonwealth',
      'Loyola Heights',
      'Socorro',
    ],
    'Cebu City': ['Banilad', 'Guadalupe', 'Lahug', 'Mabolo', 'Pardo'],
    'Davao City': ['Buhangin', 'Calinan', 'Poblacion', 'Talomo'],
    // Add more as needed for demo
  };

  static List<String> getCitiesForIsland(String island) => cities[island] ?? [];
  static List<String> getBarangaysForCity(String city) =>
      barangays[city] ?? ['Barangay 1', 'Barangay 2', 'Barangay 3'];

  static List<String> get allCities =>
      cities.values.expand((element) => element).toList();
}
