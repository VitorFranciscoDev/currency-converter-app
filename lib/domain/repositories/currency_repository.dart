import 'package:currency_converter/domain/entities/currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> getCurrency();
  Future<Currency?> getCurrencyByBase(String baseCurrency);
  Future<double?> getExchangeRate({
    required String from,
    required String to,
  });
  Future<List<String>> getSupportedCurrencies();
  Future<double?> convertCurrency({
    required double amount,
    required String from,
    required String to,
  });
  Future<bool> refreshRates();
  Future<DateTime?> getLastUpdateTime();
}