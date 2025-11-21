// Class for Database Constants like the Tables Names, Columns Names...
class DatabaseConstants {
  // Database Version
  static const currentDatabaseVersion = 1;

  // Tables Names
  static const usersTableName = "users";
  static const recentConversionsTableName = "recentConversions";

  // Users Columns Names
  static const usersColumnID = "id";
  static const usersColumnName = "name";
  static const usersColumnEmail = "email";
  static const usersColumnPassword = "password";

  // Recent Conversions Columns Names
  static const recentConversionsColumnUID = "uid";
  static const recentConversionsColumnFrom = "from";
  static const recentConversionsColumnTo = "to";
  static const recentConversionsColumnAmount = "amount";
  static const recentConversionsColumnResult = "result";
  static const recentConversionsColumnTime = "time";
}