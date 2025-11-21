import 'package:currency_converter/core/constants/database_constants.dart';
import 'package:currency_converter/domain/entities/recent_conversion.dart';
import 'package:currency_converter/domain/repositories/recent_conversion_repository.dart';
import 'package:currency_converter/infrastructure/database/database.dart';
import 'package:currency_converter/infrastructure/models/recent_conversion_model.dart';

class RecentConversionRepositoryImpl implements RecentConversionRepository {
  RecentConversionRepositoryImpl({
    CurrencyConverterDatabase? databaseManager,
  }) : _databaseManager = databaseManager ?? CurrencyConverterDatabase.instance;

  final CurrencyConverterDatabase _databaseManager;

  @override
  Future<int> addRecentConversion(RecentConversion recentConversion) async {
    final db = await _databaseManager.database;

    try {
      final recentConversionModel = RecentConversionModel(
        uid: recentConversion.uid, 
        from: recentConversion.from, 
        to: recentConversion.to, 
        amount: recentConversion.amount, 
        result: recentConversion.result, 
        time: recentConversion.time
      );

      return await db.insert(
        DatabaseConstants.recentConversionsTableName,
        recentConversionModel.toJson(),
      );
    } catch(error) {
      throw Exception("Error on Add Recent Conversion: $error");
    }
  }

  @override
  Future<List<RecentConversion>> getAllRecentConversions(int uid) async {
    final db = await _databaseManager.database;

    try {
      final recentConversions = await db.query(
        DatabaseConstants.recentConversionsTableName,
        where: 'uid = ?',
        whereArgs: [uid],
      );

      return recentConversions.map((recentConversion) => RecentConversionModel.fromJson(recentConversion)).toList();
    } catch(error) {
      throw Exception("Erro on Get All Recent Conversions: $error");
    }
  }
}