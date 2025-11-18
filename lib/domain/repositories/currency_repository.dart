import 'package:currency_converter/domain/entities/currency.dart';

/// Repository contract for currency and exchange rate operations.
///
/// This abstract class defines the contract (interface) for currency-related
/// operations in the domain layer, following the Repository Pattern and
/// Clean Architecture principles. It acts as a boundary between the domain
/// layer and the data layer, abstracting the data source implementation
/// (REST API, local database, cache, etc.).
///
/// ## Responsibilities:
/// - Define currency data retrieval operations
/// - Abstract exchange rate data source details
/// - Provide a consistent API for currency use cases
/// - Enable testability through dependency inversion
///
/// ## Implementation:
/// This interface should be implemented in the data layer (e.g.,
/// `CurrencyRepositoryImpl`) which handles:
/// - HTTP requests to currency API (e.g., ExchangeRate-API, Fixer.io)
/// - Local caching for offline support
/// - Error handling and retry logic
/// - Data transformation from API models to domain entities
///
/// ## Usage Example:
/// ```dart
/// class GetExchangeRatesUseCase {
///   final CurrencyRepository repository;
///
///   Future<Either<Failure, List<Currency>>> call() {
///     return repository.getCurrency();
///   }
/// }
/// ```
///
/// ## Design Patterns Applied:
/// - **Repository Pattern**: Encapsulates data access logic
/// - **Dependency Inversion Principle**: Domain depends on abstraction
/// - **Single Responsibility**: Focused on currency operations only
abstract class CurrencyRepository {
  /// Retrieves a list of currencies with their current exchange rates.
  ///
  /// Fetches currency information including base currency codes and their
  /// corresponding exchange rates. This method typically retrieves data from
  /// an external exchange rate API or a local cache.
  ///
  /// The list usually contains:
  /// - Multiple currency objects with different base currencies, or
  /// - A single currency object with one base and multiple target rates
  ///
  /// ## Data Source Options:
  /// The implementation can fetch data from:
  /// 1. **Remote API**: Real-time exchange rates from services like:
  ///    - ExchangeRate-API (https://exchangerate-api.com)
  ///    - Fixer.io (https://fixer.io)
  ///    - Currency Layer (https://currencylayer.com)
  /// 2. **Local Cache**: Previously fetched data stored locally
  /// 3. **Fallback Strategy**: Try remote first, fallback to cache if offline
  ///
  /// Returns:
  /// - A [List<Currency>] containing currency objects with exchange rates.
  /// - An empty list if no currencies are available (should be rare).
  ///
  /// Throws:
  /// - [NetworkException]: If there's no internet connection and no cache available.
  /// - [ServerException]: If the API returns an error (4xx, 5xx status codes).
  /// - [TimeoutException]: If the API request exceeds the timeout duration.
  /// - [CacheException]: If there's an error reading from local storage.
  /// - [ParseException]: If the API response format is invalid or unexpected.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final currencies = await repository.getCurrency();
  ///   
  ///   if (currencies.isNotEmpty) {
  ///     final usdRates = currencies.firstWhere(
  ///       (c) => c.base == 'USD',
  ///       orElse: () => currencies.first,
  ///     );
  ///     
  ///     print('Base: ${usdRates.base}');
  ///     print('Available currencies: ${usdRates.availableCurrencies}');
  ///   }
  /// } on NetworkException catch (e) {
  ///   print('No internet connection');
  /// }
  /// ```
  ///
  /// **Performance Note**: Consider implementing caching to:
  /// - Reduce API calls and costs
  /// - Improve app responsiveness
  /// - Enable offline functionality
  /// - Respect API rate limits
  ///
  /// **Best Practice**: Exchange rates should be refreshed periodically
  /// (e.g., every hour or when the app becomes active) as they change
  /// frequently in real-world scenarios.
  Future<List<Currency>> getCurrency();

  /// Retrieves exchange rates for a specific base currency.
  ///
  /// Fetches exchange rates with a specified currency as the base.
  /// This is useful when the user wants to convert from a specific currency.
  ///
  /// Parameters:
  /// - [baseCurrency]: The base currency code (e.g., 'USD', 'EUR', 'BRL').
  ///
  /// Returns:
  /// - A [Currency] object with the specified base and all available rates.
  /// - `null` if the base currency is not supported or unavailable.
  ///
  /// Throws:
  /// - [NetworkException]: If there's no internet connection.
  /// - [ServerException]: If the API returns an error.
  /// - [ValidationException]: If the currency code format is invalid.
  /// - [UnsupportedCurrencyException]: If the currency is not supported by the API.
  ///
  /// Example:
  /// ```dart
  /// final eurRates = await repository.getCurrencyByBase('EUR');
  /// if (eurRates != null) {
  ///   print('1 EUR = ${eurRates.getRateFor('USD')} USD');
  /// }
  /// ```
  Future<Currency?> getCurrencyByBase(String baseCurrency);

  /// Retrieves the exchange rate between two specific currencies.
  ///
  /// Fetches the conversion rate from one currency to another.
  /// This is a more targeted approach when only a single conversion
  /// rate is needed.
  ///
  /// Parameters:
  /// - [from]: The source currency code.
  /// - [to]: The target currency code.
  ///
  /// Returns:
  /// - The exchange rate as a [double] (e.g., 1.18 means 1 USD = 1.18 EUR).
  /// - `null` if the conversion is not available.
  ///
  /// Throws:
  /// - [NetworkException]: If there's no internet connection.
  /// - [ServerException]: If the API returns an error.
  /// - [ValidationException]: If currency codes are invalid.
  ///
  /// Example:
  /// ```dart
  /// final rate = await repository.getExchangeRate(
  ///   from: 'USD',
  ///   to: 'BRL',
  /// );
  /// if (rate != null) {
  ///   final converted = 100 * rate;
  ///   print('100 USD = $converted BRL');
  /// }
  /// ```
  Future<double?> getExchangeRate({
    required String from,
    required String to,
  });

  /// Retrieves a list of all supported currency codes.
  ///
  /// Returns all currency codes that the API/data source supports.
  /// Useful for populating dropdowns or validating user input.
  ///
  /// Returns:
  /// - A [List<String>] of currency codes (e.g., ['USD', 'EUR', 'BRL']).
  /// - An empty list if no currencies are available.
  ///
  /// Throws:
  /// - [NetworkException]: If there's connectivity issues.
  /// - [ServerException]: If the API is unavailable.
  ///
  /// Example:
  /// ```dart
  /// final supportedCurrencies = await repository.getSupportedCurrencies();
  /// print('We support ${supportedCurrencies.length} currencies');
  /// ```
  Future<List<String>> getSupportedCurrencies();

  /// Converts an amount from one currency to another.
  ///
  /// This is a convenience method that combines fetching the exchange rate
  /// and performing the conversion calculation in one call.
  ///
  /// Parameters:
  /// - [amount]: The amount to convert.
  /// - [from]: The source currency code.
  /// - [to]: The target currency code.
  ///
  /// Returns:
  /// - The converted amount as a [double].
  /// - `null` if the conversion cannot be performed.
  ///
  /// Throws:
  /// - [NetworkException]: If there's no internet connection.
  /// - [ValidationException]: If amount is negative or currencies are invalid.
  ///
  /// Example:
  /// ```dart
  /// final converted = await repository.convertCurrency(
  ///   amount: 100,
  ///   from: 'USD',
  ///   to: 'EUR',
  /// );
  /// if (converted != null) {
  ///   print('100 USD = ${converted.toStringAsFixed(2)} EUR');
  /// }
  /// ```
  Future<double?> convertCurrency({
    required double amount,
    required String from,
    required String to,
  });

  /// Refreshes the cached exchange rate data.
  ///
  /// Forces a refresh of cached data by fetching the latest rates from
  /// the API, regardless of cache validity. Useful when:
  /// - User explicitly requests fresh data (pull-to-refresh)
  /// - App comes back from background
  /// - Cache is stale
  ///
  /// Returns:
  /// - `true` if refresh was successful.
  /// - `false` if refresh failed (might still have stale cache).
  ///
  /// Throws:
  /// - [NetworkException]: If there's no internet connection.
  /// - [ServerException]: If the API is unavailable.
  ///
  /// Example:
  /// ```dart
  /// await repository.refreshRates();
  /// final updatedCurrencies = await repository.getCurrency();
  /// ```
  Future<bool> refreshRates();

  /// Gets the timestamp of when rates were last updated.
  ///
  /// Returns the date and time when the exchange rates were last
  /// fetched from the API. Useful for showing data freshness to users.
  ///
  /// Returns:
  /// - [DateTime] of the last update.
  /// - `null` if rates have never been fetched.
  ///
  /// Example:
  /// ```dart
  /// final lastUpdate = await repository.getLastUpdateTime();
  /// if (lastUpdate != null) {
  ///   final age = DateTime.now().difference(lastUpdate);
  ///   print('Rates updated ${age.inMinutes} minutes ago');
  /// }
  /// ```
  Future<DateTime?> getLastUpdateTime();
}