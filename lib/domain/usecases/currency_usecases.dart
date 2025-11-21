import 'package:currency_converter/domain/entities/currency.dart';
import 'package:currency_converter/domain/repositories/currency_repository.dart';

class CurrencyUseCases {
  // Constructor
  CurrencyUseCases({ required CurrencyRepository repository })
    : _repository = repository;

  // Repository
  final CurrencyRepository _repository;

  Future<Currency> getRates(String base) async {
    return await _repository.getRates(base);
  }
}