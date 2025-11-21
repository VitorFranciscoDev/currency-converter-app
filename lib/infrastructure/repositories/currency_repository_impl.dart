import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/repositories/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  Future<Currency> getRates(String base) async {
    return Currency(base: base, rates: []);
  }
}