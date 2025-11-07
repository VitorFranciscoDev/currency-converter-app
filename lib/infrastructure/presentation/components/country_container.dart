import 'package:currency_converter/domain/entities/currency.dart';
import 'package:flutter/material.dart';

class CountryContainer extends StatelessWidget {
  const CountryContainer({ super.key, required this.currency, this.initialScreen = true, this.read, this.controller, this.onChanged, this.navigate });
  final Currency currency; // the currency of the container
  final bool? initialScreen; // determines if the container is in the initial screen
  final bool? read; // determines if the textfield is read only
  final TextEditingController? controller; // controller of the text field
  final void Function(String)? onChanged; // function
  final VoidCallback? navigate; // navigate with the arrow

  // color of the container by the currency code
  Color colorByCurrency(String code) {
    switch(code.toUpperCase()) {
      case "BRL":
        return Colors.green;
      case "USD":
        return Colors.lightBlueAccent;
      case "EUR":
        return Colors.indigo;
      case "GBP":
        return Colors.redAccent;
      case "CNY":
        return const Color.fromARGB(255, 105, 77, 75);
      case "JPY":
        return Colors.grey;
      case "INR":
        return Colors.deepOrange;
      case "CHF":
        return const Color.fromARGB(255, 245, 105, 92);
      default:
        return Colors.white;
    }
  }

  // flag of the container by the currency code
  String flagByCurrency(String code) {
    switch(code.toUpperCase()) {
      case "BRL":
        return "assets/br.png";
      case "USD":
        return "assets/eua.png";
      case "EUR":
        return "assets/eu.png";
      case "GBP":
        return "assets/uk.png";
      case "CNY":
        return "assets/china.png";
      case "JPY":
        return "assets/japan.png";
      case "INR":
        return "assets/india.png";
      case "CHF":
        return "assets/switzerland.png";
      default:
        return "assets/eua.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorByCurrency(currency.code);
    final flag = flagByCurrency(currency.code);

    return Container(
      width: 250,
      height: initialScreen! ? 150 : 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 15)),
                CircleAvatar(
                  backgroundImage: AssetImage(flag),
                ),
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currency.code, style: 
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(currency.name, style: TextStyle(color: Colors.white)),
                  ],
                ),
                Spacer(),
                if(initialScreen!)
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: GestureDetector(
                    onTap: navigate,
                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 25),
                  ),
                )
              ],
            ),
          ),
          if(initialScreen!)
            Padding(
              padding: EdgeInsets.only(top: 25),
              child: SizedBox(
                width: 215,
                height: 50,
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  readOnly: read ?? false,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),  
            ),
        ],
      ),
    );
  }
}