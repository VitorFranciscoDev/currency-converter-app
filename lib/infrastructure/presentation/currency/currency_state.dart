import 'package:currency_converter/domain/entities/recent_conversion.dart';
import 'package:currency_converter/domain/usecases/recent_conversion_usecases.dart';
import 'package:flutter/foundation.dart';

class CurrencyProvider with ChangeNotifier {
  CurrencyProvider({ required RecentConversionUseCases recentConversionUseCases })
    : _recentConversionUseCases = recentConversionUseCases;

  final RecentConversionUseCases _recentConversionUseCases;

  Future<int> addRecentConversion(RecentConversion recentConversion) async {
    return await _recentConversionUseCases.addRecentConversion(recentConversion);
  }

  Future<List<RecentConversion>> getAllRecentConversions(int uid) async {
    return await _recentConversionUseCases.getAllRecentConversions(uid);
  }
}