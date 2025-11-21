import 'package:currency_converter/domain/entities/currency.dart';

// Interface
abstract class CurrencyRepository {
  Future<Currency> getRates(String base);
}