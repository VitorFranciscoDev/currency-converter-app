import 'package:currency_converter/presentation/components/country_container.dart';
import 'package:currency_converter/presentation/providers/currency_provider.dart';
import 'package:currency_converter/presentation/screens/list_currency_screen.dart';
import 'package:currency_converter/usecases/currency_converter_usecase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  // controllers of the text fields
  final TextEditingController controllerFrom = TextEditingController();
  final TextEditingController controllerTo = TextEditingController();

  CurrencyConverterUseCase currencyConverterUseCase = CurrencyConverterUseCase(); // use cases of the currency converter

  // function to convert the amount from one currency to another
  Future<void> convert() async {
    String? error = currencyConverterUseCase.validateAmount(controllerFrom.text);
    if(error!=null) return;

    final currencyFrom = context.read<CurrencyProvider>().currencyFrom;
    final currencyTo = context.read<CurrencyProvider>().currencyTo;

    try {
      final amount = double.parse(controllerFrom.text);
      final result = await currencyConverterUseCase.fetchConversion(currencyFrom.code, currencyTo.code, amount);
      setState(() {
        controllerTo.text = result.converted.toStringAsFixed(2);
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFrom = context.read<CurrencyProvider>().currencyFrom;
    final currencyTo = context.read<CurrencyProvider>().currencyTo;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 80)),
              Text("Currency Converter", style: 
                TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 60)),
              CountryContainer(
                currency: currencyFrom, 
                read: false, 
                controller: controllerFrom, 
                onChanged: (value) => convert(), 
                navigate: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListCurrencyScreen(from: true)))
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              Image.asset("assets/trade.png", height: 80),
              Padding(padding: EdgeInsets.only(top: 40)),
              CountryContainer(
                currency: currencyTo, 
                read: true, 
                controller: controllerTo, 
                navigate: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListCurrencyScreen(from: false))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}