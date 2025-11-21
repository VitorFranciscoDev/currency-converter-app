import 'package:currency_converter/domain/repositories/currency_repository.dart';
import 'package:currency_converter/infrastructure/models/currency_model.dart';

class CurrencyUseCases {
  const CurrencyUseCases({ required CurrencyRepository repository })
    : _repository = repository;

  final CurrencyRepository _repository;

  Future<CurrencyModel?> getRates(String base) async {
    return await _repository.getRates(base);
  }
}