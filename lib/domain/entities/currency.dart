/// Represents a currency with its base code and exchange rates.
///
/// This domain entity encapsulates currency information and exchange rates
/// for converting between different currencies. It follows Clean Architecture
/// principles by remaining framework-independent and focused on business logic.
///
/// ## Properties:
/// - [base]: The base currency code (e.g., 'USD', 'EUR', 'BRL').
/// - [rates]: List of exchange rates where each map contains currency codes
///   as keys and conversion rates as values.
///
/// ## Usage Example:
/// ```dart
/// final currency = Currency(
///   base: 'USD',
///   rates: [
///     {'EUR': 0.85, 'BRL': 5.25, 'GBP': 0.73},
///   ],
/// );
///
/// // Convert 100 USD to EUR
/// final eurRate = currency.getRateFor('EUR'); // 0.85
/// final convertedAmount = 100 * eurRate; // 85.0 EUR
/// ```
class Currency {
  /// The base currency code following ISO 4217 standard.
  ///
  /// This represents the currency from which all exchange rates are calculated.
  /// Common examples include:
  /// - 'USD' - United States Dollar
  /// - 'EUR' - Euro
  /// - 'BRL' - Brazilian Real
  /// - 'GBP' - British Pound Sterling
  /// - 'JPY' - Japanese Yen
  ///
  /// The code should always be in uppercase and follow the ISO 4217 format
  /// (3-letter currency code).
  final String base;

  /// List of exchange rate maps for converting from the base currency.
  ///
  /// Each map contains currency codes as keys and their corresponding
  /// exchange rates as values. The rate indicates how much of the target
  /// currency equals one unit of the base currency.
  ///
  /// Example structure:
  /// ```dart
  /// [
  ///   {
  ///     'EUR': 0.85,  // 1 USD = 0.85 EUR
  ///     'BRL': 5.25,  // 1 USD = 5.25 BRL
  ///     'GBP': 0.73,  // 1 USD = 0.73 GBP
  ///   }
  /// ]
  /// ```
  ///
  /// **Note**: In most cases, this list will contain a single map with all rates.
  /// The list structure allows for potential extensions like historical rates
  /// or time-based rate changes.
  final List<Map<String, double>> rates;

  /// Creates a new [Currency] instance.
  ///
  /// Both parameters are required to ensure the currency object has
  /// complete information for exchange rate calculations.
  ///
  /// Parameters:
  /// - [base]: The base currency code (e.g., 'USD', 'EUR').
  /// - [rates]: List of maps containing exchange rates for different currencies.
  ///
  /// Example:
  /// ```dart
  /// final currency = Currency(
  ///   base: 'BRL',
  ///   rates: [
  ///     {
  ///       'USD': 0.19,
  ///       'EUR': 0.16,
  ///       'GBP': 0.14,
  ///     }
  ///   ],
  /// );
  /// ```
  const Currency({
    required this.base,
    required this.rates,
  });

  /// Creates a copy of this currency with the given fields replaced with new values.
  ///
  /// This method maintains immutability while allowing for updates to
  /// currency data, such as refreshing exchange rates.
  ///
  /// Example:
  /// ```dart
  /// final updatedRates = currency.copyWith(
  ///   rates: [
  ///     {'EUR': 0.86, 'BRL': 5.30, 'GBP': 0.74},
  ///   ],
  /// );
  /// ```
  Currency copyWith({
    String? base,
    List<Map<String, double>>? rates,
  }) {
    return Currency(
      base: base ?? this.base,
      rates: rates ?? this.rates,
    );
  }

  /// Gets the exchange rate for a specific target currency.
  ///
  /// Searches through the rates list to find the conversion rate
  /// from the base currency to the specified target currency.
  ///
  /// Parameters:
  /// - [currencyCode]: The target currency code (e.g., 'EUR', 'BRL').
  ///
  /// Returns the exchange rate if found, or `null` if the currency
  /// code doesn't exist in the rates.
  ///
  /// Example:
  /// ```dart
  /// final eurRate = currency.getRateFor('EUR');
  /// if (eurRate != null) {
  ///   print('1 ${currency.base} = $eurRate EUR');
  /// }
  /// ```
  double? getRateFor(String currencyCode) {
    for (final rateMap in rates) {
      if (rateMap.containsKey(currencyCode)) {
        return rateMap[currencyCode];
      }
    }
    return null;
  }

  /// Converts an amount from the base currency to a target currency.
  ///
  /// Calculates the converted amount by multiplying the input amount
  /// by the exchange rate for the target currency.
  ///
  /// Parameters:
  /// - [amount]: The amount in the base currency to convert.
  /// - [targetCurrency]: The target currency code.
  ///
  /// Returns the converted amount, or `null` if the target currency
  /// is not found in the rates.
  ///
  /// Example:
  /// ```dart
  /// final convertedAmount = currency.convert(100, 'EUR');
  /// if (convertedAmount != null) {
  ///   print('100 ${currency.base} = $convertedAmount EUR');
  /// }
  /// ```
  double? convert(double amount, String targetCurrency) {
    final rate = getRateFor(targetCurrency);
    return rate != null ? amount * rate : null;
  }

  /// Gets all available currency codes that can be converted from the base currency.
  ///
  /// Returns a list of all currency codes present in the rates maps.
  /// Useful for displaying available currencies in a dropdown or list.
  ///
  /// Example:
  /// ```dart
  /// final availableCurrencies = currency.availableCurrencies;
  /// print('You can convert to: ${availableCurrencies.join(', ')}');
  /// // Output: You can convert to: EUR, BRL, GBP
  /// ```
  List<String> get availableCurrencies {
    final currencies = <String>{};
    for (final rateMap in rates) {
      currencies.addAll(rateMap.keys);
    }
    return currencies.toList()..sort();
  }

  /// Checks if a specific currency code is available for conversion.
  ///
  /// Parameters:
  /// - [currencyCode]: The currency code to check.
  ///
  /// Returns `true` if the currency can be converted, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (currency.hasCurrency('EUR')) {
  ///   print('EUR conversion is available');
  /// }
  /// ```
  bool hasCurrency(String currencyCode) {
    return getRateFor(currencyCode) != null;
  }

  /// Gets the total number of available currencies for conversion.
  ///
  /// Example:
  /// ```dart
  /// print('${currency.currencyCount} currencies available');
  /// ```
  int get currencyCount => availableCurrencies.length;

  /// Checks if this currency has any exchange rates available.
  ///
  /// Returns `true` if rates list is not empty, `false` otherwise.
  bool get hasRates => rates.isNotEmpty;

  /// Compares this currency with another object for equality.
  ///
  /// Two currencies are considered equal if they have the same base
  /// currency code and the same exchange rates.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Currency &&
        other.base == base &&
        _areRatesEqual(other.rates, rates);
  }

  /// Helper method to compare two rate lists for equality.
  ///
  /// Performs deep comparison of the maps in both lists.
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

  /// Returns a hash code for this currency.
  ///
  /// The hash code is computed based on the base currency and rates
  /// to ensure consistent behavior with the equality operator.
  @override
  int get hashCode => base.hashCode ^ rates.hashCode;

  /// Returns a string representation of this currency.
  ///
  /// Useful for debugging purposes. Shows the base currency and
  /// the number of available exchange rates.
  ///
  /// Example output: `Currency(base: USD, currencies: 3)`
  @override
  String toString() {
    return 'Currency(base: $base, currencies: $currencyCount)';
  }
}