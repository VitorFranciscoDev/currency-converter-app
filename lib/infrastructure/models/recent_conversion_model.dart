import 'package:currency_converter/domain/entities/recent_conversion.dart';

class RecentConversionModel extends RecentConversion {
  // Constructor
  const RecentConversionModel({
    required super.uid,
    required super.from,
    required super.to,
    required super.amount,
    required super.result,
    required super.time,
  });

  // RecentConversion => Json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'from': from,
      'to': to,
      'amount': amount,
      'result': result,
      'time': time,
    };
  }

  // Json => RecentConversion
  factory RecentConversionModel.fromJson(Map<String, dynamic> json) {
    return RecentConversionModel(
      uid: json['uid'], 
      from: json['from'], 
      to: json['to'], 
      amount: json['amount'], 
      result: json['result'], 
      time: json['time'],
    );
  }
}