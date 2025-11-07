import 'package:currency_converter/infrastructure/presentation/components/country_container.dart';
import 'package:currency_converter/infrastructure/presentation/screens/currency_converter_screen.dart';
import 'package:currency_converter/infrastructure/presentation/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCurrencyScreen extends StatefulWidget {
  const ListCurrencyScreen({ super.key, required this.from });
  final bool from;

  @override
  State<ListCurrencyScreen> createState() => _ListCurrencyScreenState();
}

class _ListCurrencyScreenState extends State<ListCurrencyScreen> {
  @override
  Widget build(BuildContext context) {
    final currencies = context.read<CurrencyProvider>().currencies;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final currency = currencies[index];
                  return Padding(
                    padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                    child: GestureDetector(
                      onTap: () {
                        widget.from ?
                          context.read<CurrencyProvider>().changeCurrencyFrom(currency)
                          : context.read<CurrencyProvider>().changeCurrencyTo(currency);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CurrencyConverterScreen()));
                      },
                      child: CountryContainer(
                        currency: currency,
                        initialScreen: false,
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}