import 'package:currency_converter/domain/entities/currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> getCurrency();
}