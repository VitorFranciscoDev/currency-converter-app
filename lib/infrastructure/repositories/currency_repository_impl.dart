import 'package:currency_converter/infrastructure/models/currency_model.dart';
import 'package:currency_converter/infrastructure/services/currency_service.dart';

class CurrencyRepositoryImpl {
  const CurrencyRepositoryImpl({ required CurrencyService service })
    : _service = service;

  final CurrencyService _service;

  Future<CurrencyModel?> getRates(String base) async {
    return await _service.getRates(base);
  }
}