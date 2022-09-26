
import 'package:agent/config/utils.dart';
import 'package:agent/resources/colors.dart';
import 'package:agent/resources/styles.dart';
import 'package:agent/screens/common_widgets/app_bar.dart';
import 'package:agent/screens/common_widgets/stream_messages.dart';
import 'package:agent/screens/monthly_orders/domain/monthly_service.dart';
import 'package:agent/screens/monthly_orders/domain/utils.dart';
import 'package:agent/screens/profile/domain/notifier/profile_notifier.dart';
import 'package:agent/screens/profile/presentation/widgets/list_orders.dart';
import 'package:agent/screens/tasks/common_utils.dart';
import 'package:agent/screens/tasks/data/models/agent_order.dart';
import 'package:agent/screens/tasks/data/models/order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OneMonthOrders extends StatelessWidget {
  final String date;
  const OneMonthOrders({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    MonthlyService monthlyService = MonthlyService();

    ///get language
    var local = getAppLang(context);

    final profileWatch = context.watch<ProfileProvider>();
    StreamLoading _streamLoading = StreamLoading();

    return Scaffold(
      appBar: AgentBar(
        color: secondColor,
        title: getPeriod(currentDate: date, lang: profileWatch.locale.languageCode),
        context: context,
        showBack: true,
        // size: getScreenHeight(context) * .2,
      ),
      body: FutureBuilder<DatabaseEvent>(
          future: monthlyService.getOrdersByMonthStream(date: date),
          builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            List<Widget> children =[];
            if (snapshot.hasError) {
              children =
                _streamLoading.hasError(snapshot);

            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  children =
                    _streamLoading.connectionStateNone(local.noConnection);

                  break;
                case ConnectionState.waiting:
                  children =
                    _streamLoading.connectionStateWaiting(local.wait);

                  break;
                case ConnectionState.done:
                  if (snapshot.data!.snapshot.value == null) {
                    children = <Widget>[
                      Container(
                          margin: EdgeInsets.symmetric(
                            vertical: getScreenHeight(context) / 7,
                          ),
                          alignment: Alignment.bottomCenter,
                          child: Text(local.noTasksFound))
                    ];
                  } else {
                    final json =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                    List<Map<String, Order>> orders = [];
                    json.forEach((key, value) {
                      final val = value as Map<dynamic, dynamic>;

                      val.forEach((key, value) {
                        Map<String, Order> map = {};
                        map.putIfAbsent(key, () => Order.fromJson(value));
                        orders.add(map);
                      });

                    });

                    ///fetch order list by agent id
                    List<Map<String, AgentOrder>> agentOrders = fetchListOrders(orders, context,finished: true);

                    double total = 0;
                    for(int i = 0;i<agentOrders.length;i++){
                      if(agentOrders[i].values.first.orderItem.finalPrice == 0) {
                        total =
                            total + agentOrders[i].values.first.orderItem.price;
                      }else{
                        total =
                            total + agentOrders[i].values.first.orderItem.finalPrice;
                      }
                    }

                    if(agentOrders.isEmpty){
                      children = <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(
                              vertical: getScreenHeight(context) / 7,
                            ),
                            alignment: Alignment.bottomCenter,
                            child: Text(local.noTasksFound))
                      ];
                    }else {
                      children = <Widget>[
                        Text(
                          '${local.totalIncome}: $total ${local.kwd}',
                          style: nameProfile.copyWith(
                              color: fieldTextColor, fontSize: 15),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        ListOrders(
                          orders: agentOrders,
                          //keys: listKeys,
                        ),
                      ];
                    }
                  }
                  break;
                case ConnectionState.active:
                  // TODO: Handle this case.
                  break;
              }
            }
            return SingleChildScrollView(
              child: Column(
                children: children,
              ),
            );
          }),
    );
  }
}
