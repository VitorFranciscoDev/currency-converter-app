// model to receive the data from api
class CurrencyConverter {
  final String from;
  final String to;
  final double amount;
  final double converted;
  final double rate;

  CurrencyConverter({ required this.from, required this.to, required this.amount, required this.converted, required this.rate });

  factory CurrencyConverter.fromJson(Map<String, dynamic> json) {
    return CurrencyConverter(
      from: json['from'], 
      to: json['to'], 
      amount: (json['amount'] as num).toDouble(), 
      converted: (json['converted'] as num).toDouble(), 
      rate: (json['rate'] as num).toDouble(),
    );
  }
}