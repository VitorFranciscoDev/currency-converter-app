// Recent Conversion Entitie
class RecentConversion {
  // Attributes
  final int _uid;
  final String _from;
  final String _to;
  final double _amount;
  final double _result;
  final DateTime _time;

  // Constructor
  const RecentConversion({
    required int uid,
    required String from,
    required String to,
    required double amount,
    required double result,
    required DateTime time,
  }) :
    _uid = uid,
    _from = from,
    _to = to,
    _amount = amount,
    _result = result,
    _time = time;

  // Getters
  int get uid => _uid;
  String get from => _from;
  String get to => _to;
  double get amount => _amount;
  double get result => _result;
  DateTime get time => _time;

  // debug
  @override
  String toString() {
    return "$_from, $_to $_amount, $_result, $_time";
  }
}