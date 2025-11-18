import 'package:currency_converter/domain/entities/currency.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({
    required super.base,
    required super.rates,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      base: json['base'], 
      rates: json['rates'],
    );
  }
}