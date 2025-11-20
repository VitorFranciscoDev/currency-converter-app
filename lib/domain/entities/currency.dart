// Currency's Entitie
class Currency {
  // Attributes
  final String _base;
  final List<Map<String, double>> _rates;

  // Constructor
  const Currency({
    required String base,
    required List<Map<String, double>> rates,
  }) : 
    _base = base,
    _rates = rates;

  // Getters
  String get base => _base;
  List<Map<String, double>> get rates => _rates;

  // Debug Print
  @override
  String toString() {
    return 'Currency(base: $_base, rates: $_rates)';
  }
}