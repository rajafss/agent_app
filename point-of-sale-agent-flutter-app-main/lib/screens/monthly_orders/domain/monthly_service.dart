import 'package:agent/config/shared_preference.dart';
import 'package:agent/resources/constants.dart';
import 'package:agent/screens/monthly_orders/domain/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class MonthlyService {
  ///get company id from shared preference
  //final compId = Prefs.getString(companyId);

  ///get current Year Orders
  Future<DatabaseEvent> getCurrentYearOrdersKey() {
    final compId = Prefs.getString(companyId);
    Future<DatabaseEvent> future;
    try {
      ///Current Year
      var now = DateTime.now();
      var _formatter = DateFormat('yyyy');
      var _formatDate = _formatter.format(now);

      ///Next year
      var date = DateTime(now.year + 1);
      var _format = DateFormat('yyyy');
      var _nextFormatDate = _format.format(date);

      var startDate = getFormattedDate(currentDate: _formatDate);
      var endDate =
          getFormattedDate(currentDate: _nextFormatDate, endDate: true);

      DatabaseReference orderRef =
          FirebaseDatabase.instance.ref("company/$compId/order/");

      future = orderRef.orderByKey().startAt(startDate).endAt(endDate).once();

    } catch (e) {
      throw Exception(e);
    }
    return future;
  }

  ///Get orders by every Month
  Future<DatabaseEvent> getOrdersByMonthStream({required String date}) {
    final compId = Prefs.getString(companyId);

    ///get start month and end month
    Future<DatabaseEvent> future;
    try {
      var startDate = formattedStartEndDate(currentDate: date);
      var endDate = formattedStartEndDate(currentDate: date, endDate: true);

      ///Get Orders Path
      final _orderRef = FirebaseDatabase.instance
          .ref("company/$compId/order")
          .orderByKey()
          .startAt(startDate)
          .endAt(endDate);

      future = _orderRef.once();
    } catch (e) {
      throw Exception(e);
    }
    return future;
  }
}
