import 'package:agent/config/shared_preference.dart';
import 'package:agent/resources/constants.dart';
import 'package:agent/screens/profile/domain/notifier/profile_notifier.dart';
import 'package:agent/screens/tasks/data/models/agent_order.dart';
import 'package:agent/screens/tasks/data/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String loginTitle = 'Login';

String setCapitalize(String name) {
  name = name[0].toUpperCase() + name.substring(1).toLowerCase();
  return name;
}

///get agent list orders
List<Map<String, AgentOrder>> fetchListOrders(
    List<Map<String, Order>> orders, BuildContext context,
    {bool finished = false, bool today = false}) {
  ///get agent ID
  String agId = Prefs.getString(agentId)!;
  final profileWatch = context.watch<ProfileProvider>();
  double prices = 0;

  List<Map<String, AgentOrder>> agentOrders = [];

  for (Map<String, Order> order in orders) {
    order.forEach((key, value) {
      for (int i = 0; i < value.orderItems.length; i++) {
        var item = value.orderItems[i];

        ///get all agent finished orders
        if (finished) {
          if (item.agentId == agId && item.status == Status.finished.name) {

            if(item.finalPrice == 0) {
              prices = prices + item.price;
            }else{
              prices = prices + item.finalPrice;
            }

            Map<String, AgentOrder> map = {};
            map.putIfAbsent(
                key,
                () => AgentOrder(
                    orderItem: item,
                    orderItemKey: i.toString(),
                    customerID: value.customerId,
                    invoiceNumber: value.invoiceNumber,
                    time: value.time));
            agentOrders.add(map);
          }
        }

        ///get all active agent orders
        else {
          if (item.agentId == agId && item.status != 'finished') {
            Map<String, AgentOrder> map = {};
            map.putIfAbsent(
                key,
                () => AgentOrder(
                    orderItem: item,
                    orderItemKey: i.toString(),
                    customerID: value.customerId,
                    invoiceNumber: value.invoiceNumber,
                    time: value.time));
            agentOrders.add(map);
          }
        }
      }
    });
  }
  if (finished) {
    ///order list by invoice number ascending
    agentOrders.sort((a, b) =>
        b.values.single.invoiceNumber.compareTo(a.values.single.invoiceNumber));


    ///set total order prices
    if(today){
      profileWatch.setTotalTodayPrices(prices);
    }else{
      profileWatch.setTotalPrices(prices);
    }

  } else {
    ///order list by invoice number descending
    agentOrders.sort((b, a) =>
        b.values.single.invoiceNumber.compareTo(a.values.single.invoiceNumber));
  }

  return agentOrders;
}

// List<Map<String, AgentOrder>> fetchListMonthOrders(
//     List<Map<String, Order>> orders) {
//   List<Map<String, AgentOrder>> agentOrders =
//       fetchListOrders(orders, context, finished: true);
//
//   return agentOrders;
// }
