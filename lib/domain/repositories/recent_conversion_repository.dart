import 'package:currency_converter/domain/entities/recent_conversion.dart';

// Interface
abstract class RecentConversionRepository {
  Future<int> addRecentConversion(RecentConversion recentConversion);
  Future<List<RecentConversion>> getAllRecentConversions(int uid);
}