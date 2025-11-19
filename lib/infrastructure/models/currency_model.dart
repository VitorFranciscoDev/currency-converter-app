import 'package:currency_converter/domain/entities/currency.dart';

// Currency's Model
class CurrencyModel extends Currency {
  // Constructor
  const CurrencyModel({
    required super.base,
    required super.rates,
  });

  // Json => Currency
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      base: json['base'], 
      rates: json['rates'],
    );
  }
}