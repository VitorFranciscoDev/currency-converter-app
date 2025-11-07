import 'package:currency_converter/infrastructure/datastore/interfaces/currency_repository.dart';

class CurrencyUseCases {
  CurrencyUseCases({ required this.repository });

  final CurrencyRepository repository;
}