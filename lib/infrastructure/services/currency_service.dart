import 'dart:convert';

import 'package:currency_converter/infrastructure/models/currency_model.dart';
import 'package:http/http.dart' as http;

class CurrencyService {
  Future<CurrencyModel?> getRates(String base) async {
    final url = Uri.parse("https://api.exchangerate-api.com/v4/latest/$base");

    try {
      final response = await http.get(url);

      if(response.statusCode == 200) {
        final data = json.decode(response.body);

        return CurrencyModel.fromJson(data);
      } else {
        return null;
      }
    } catch(error) {
      return null;
    }
  }
}