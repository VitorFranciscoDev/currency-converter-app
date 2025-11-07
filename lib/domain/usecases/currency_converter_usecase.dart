import 'dart:convert';
import 'package:currency_converter/domain/entities/currency_converter.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterUseCase {

  // function to validate the amount
  String? validateAmount(String amount) => amount.isEmpty || double.tryParse(amount) == null ? "Invalid amount" : null;

  Future<CurrencyConverter> fetchConversion(String from, String to, double amount) async {
    final url = Uri.parse('http://[IP]:8080/convert?from=$from&to=$to&amount=$amount'); // replace the [IP] with your IP

    final response = await http.get(url); // response of the http request
    
    if(response.statusCode == 200) {
      // transforms data in json and returns it
      final data = jsonDecode(response.body);
      return CurrencyConverter.fromJson(data);
    } else {
      throw Exception("Failed to fetch conversion");
    }
  }
}