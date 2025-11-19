class Currency {
  final String base;
  final List<Map<String, double>> rates;

  const Currency({
    required this.base,
    required this.rates,
  });

  Currency copyWith({
    String? base,
    List<Map<String, double>>? rates,
  }) {
    return Currency(
      base: base ?? this.base,
      rates: rates ?? this.rates,
    );
  }

  double? getRateFor(String currencyCode) {
    for (final rateMap in rates) {
      if (rateMap.containsKey(currencyCode)) {
        return rateMap[currencyCode];
      }
    }
    return null;
  }

  double? convert(double amount, String targetCurrency) {
    final rate = getRateFor(targetCurrency);
    return rate != null ? amount * rate : null;
  }

  List<String> get availableCurrencies {
    final currencies = <String>{};
    for (final rateMap in rates) {
      currencies.addAll(rateMap.keys);
    }
    return currencies.toList()..sort();
  }

  bool hasCurrency(String currencyCode) {
    return getRateFor(currencyCode) != null;
  }

  int get currencyCount => availableCurrencies.length;

  bool get hasRates => rates.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Currency &&
        other.base == base &&
        _areRatesEqual(other.rates, rates);
  }

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

  @override
  int get hashCode => base.hashCode ^ rates.hashCode;

  @override
  String toString() {
    return 'Currency(base: $base, currencies: $currencyCount)';
  }
}