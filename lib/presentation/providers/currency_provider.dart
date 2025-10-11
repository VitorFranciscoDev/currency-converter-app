import 'package:currency_converter/entities/currency.dart';
import 'package:flutter/material.dart';

class CurrencyProvider with ChangeNotifier {
  late Currency currencyFrom;
  late Currency currencyTo;

  List<Currency> currencies = [
    Currency(code: "BRL", name: "Brazilian Real"),
    Currency(code: "USD", name: "US Dollar"),
    Currency(code: "EUR", name: "Euro"),
    Currency(code: "GBP", name: "British Pound"),
    Currency(code: "CNY", name: "Chinese Yuan"),
    Currency(code: "JPY", name: "Japanese Yen"),
    Currency(code: "INR", name: "Indian Rupee"),
    Currency(code: "CHF", name: "Swiss Franc"),
  ];

  CurrencyProvider() {
    currencyTo = currencies[0];
    currencyFrom = currencies[1];
  }

  changeCurrencyFrom(Currency currency) {
    currencyFrom = currency;
    notifyListeners();
  }

  changeCurrencyTo(Currency currency) {
    currencyTo = currency;
    notifyListeners();
  }
}