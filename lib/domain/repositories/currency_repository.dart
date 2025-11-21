// Currency Contracts
import 'package:currency_converter/infrastructure/models/currency_model.dart';

abstract class CurrencyRepository {
  Future<CurrencyModel?> getRates(String base);
}