// Currency's Entitie
class Currency {
  // Attributes
  final String base;
  final List<Map<String, double>> rates;

  // Constructor
  const Currency({
    required this.base,
    required this.rates,
  });

  // Currency's Copy
  Currency copyWith({
    String? base,
    List<Map<String, double>>? rates,
  }) {
    return Currency(
      base: base ?? this.base,
      rates: rates ?? this.rates,
    );
  }

  // Override to Compare Objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Currency &&
        other.base == base &&
        _areRatesEqual(other.rates, rates);
  }

  // Operator ==
  bool _areRatesEqual(
    List<Map<String, double>> rates1,
    List<Map<String, double>> rates2,
  ) {
    if (rates1.length != rates2.length) return false;

    for (int i = 0; i < rates1.length; i++) {
      final map1 = rates1[i];
      final map2 = rates2[i];

      if (map1.length != map2.length) return false;

      for (final key in map1.keys) {
        if (!map2.containsKey(key) || map1[key] != map2[key]) {
          return false;
        }
      }
    }

    return true;
  }

  // Override to Compare Objects
  @override
  int get hashCode => base.hashCode ^ rates.hashCode;

  // Debug Print
  @override
  String toString() {
    return 'Currency(base: $base, rates: $rates)';
  }
}