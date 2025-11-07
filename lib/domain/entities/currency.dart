class Currency {
  final String from;
  final String to;
  final double rate;
  final double amount;
  final double converted;

  const Currency({
    required this.from,
    required this.to,
    required this.rate,
    required this.amount,
    required this.converted,
  });

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'rate': rate,
      'amount': amount,
      'converted': converted,
    };
  }

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      from: json['from'],
      to: json['to'],
      rate: json['rate'], 
      amount: json['amount'], 
      converted: json['converted'],
    );
  }

  @override
  String toString() {
    return "from: $from, to: $to, rate: $rate, amount: $amount, converted: $converted";
  }
}