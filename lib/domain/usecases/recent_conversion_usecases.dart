import 'package:currency_converter/domain/entities/recent_conversion.dart';
import 'package:currency_converter/domain/repositories/recent_conversion_repository.dart';

class RecentConversionUseCases {
  const RecentConversionUseCases({ required RecentConversionRepository repository })
    : _repository = repository;
  
  final RecentConversionRepository _repository;

  Future<int> addRecentConversion(RecentConversion recentConversion) async {
    return await _repository.addRecentConversion(recentConversion);
  }

  Future<List<RecentConversion>> getAllRecentConversions(int uid) async {
    return await _repository.getAllRecentConversions(uid);
  }
}