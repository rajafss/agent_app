import 'package:agent/config/utils.dart';
import 'package:agent/screens/common_widgets/stream_messages.dart';
import 'package:agent/screens/profile/data/repository/profile_repository.dart';
import 'package:agent/screens/profile/domain/notifier/profile_notifier.dart';
import 'package:agent/screens/profile/presentation/widgets/list_orders.dart';
import 'package:agent/screens/tasks/common_utils.dart';
import 'package:agent/screens/tasks/data/models/agent_order.dart';
import 'package:agent/screens/tasks/data/models/order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalTasks extends StatelessWidget {
  const TotalTasks({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ProfileRepository _profileRepository = ProfileRepository();

    final profileRead = context.read<ProfileProvider>();

    ///get language
    var local = getAppLang(context);
    StreamLoading _streamLoading = StreamLoading();

    return FutureBuilder<DatabaseEvent>(
        future: _profileRepository.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          List<Widget> children = [];
          if (snapshot.hasError) {
            children = _streamLoading.hasError(snapshot);
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                children =
                    _streamLoading.connectionStateNone(local.noConnection);

                break;
              case ConnectionState.waiting:
                Future.delayed(Duration.zero, () async {
                  ///set waiting
                  profileRead.setTasksWaiting(true);
                });

                children = _streamLoading.connectionStateWaiting(local.wait);

                break;
              case ConnectionState.done:
                if (snapshot.data!.snapshot.value == null) {
                  children = <Widget>[
                    const NotFound()
                  ];
                } else {


                  List<Map<String, Order>> orders = [];

                  final json =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                  json.forEach((key, value) {
                    final val = value as Map<dynamic, dynamic>;
                    val.forEach((key, value) {
                      Map<String, Order> map = {};
                      map.putIfAbsent(key, () => Order.fromJson(value));
                      orders.add(map);
                    });
                  });

                  ///fetch order list by agent id
                  List<Map<String, AgentOrder>> agentOrders =
                      fetchListOrders(orders, context, finished: true);

                  Future.delayed(Duration.zero, () async {
                    ///set waiting
                    profileRead.setTasksWaiting(false);
                  });


                  Future.delayed(Duration.zero, () async {
                    ///set Total finish orders
                    profileRead.setTotalTasks(agentOrders.length);
                  });

                  children = <Widget>[

                    agentOrders.isNotEmpty ?
                    ListOrders(
                      orders: agentOrders,
                    ): const NotFound(),


                    const SizedBox(
                      height: 20,
                    )
                  ];
                }
                break;
              case ConnectionState.active:
                // TODO: Handle this case.
                break;
            }
          }
          return
            Stack(
              children: children,
          );
        });

    // StreamBuilder<DatabaseEvent>(
    //   stream: _profileRepository.getAllOrders(),
    //   builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
    //     List<Widget> children;
    //     if (snapshot.hasError) {
    //       children =
    //         _streamLoading.hasError(snapshot);
    //
    //     } else {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.none:
    //           children =
    //           _streamLoading.connectionStateNone(local.noConnection);
    //
    //           break;
    //         case ConnectionState.waiting:
    //           children =
    //             _streamLoading.connectionStateWaiting(local.wait);
    //
    //           break;
    //         case ConnectionState.active:
    //           if (snapshot.data!.snapshot.value == null) {
    //             children = <Widget>[
    //               Container(
    //                   margin: EdgeInsets.symmetric(
    //                     vertical: getScreenHeight(context) / 7,
    //                   ),
    //                   alignment: Alignment.bottomCenter,
    //                   child: Text(local.noTasksFound))
    //             ];
    //           } else {
    //             List<Map<String, Order>> orders = [];
    //
    //             final json =
    //                 snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
    //
    //             json.forEach((key, value) {
    //               final val = value as Map<dynamic, dynamic>;
    //               val.forEach((key, value) {
    //                 Map<String, Order> map = {};
    //                 map.putIfAbsent(key, () => Order.fromJson(value));
    //                 orders.add(map);
    //               });
    //             });
    //
    //             ///fetch order list by agent id
    //             List<Map<String, AgentOrder>> agentOrders =
    //                 fetchListOrders(orders, finished: true);
    //
    //             Future.delayed(Duration.zero, () async {
    //               ///set Total finish orders
    //               profileRead.setTotalTasks(agentOrders.length);
    //             });
    //
    //             children = <Widget>[
    //               ListOrders(
    //                 orders: agentOrders,
    //                 //keys: listKeys,
    //               ),
    //             ];
    //           }
    //           break;
    //         case ConnectionState.done:
    //           children = <Widget>[
    //             const SizedBox(
    //               width: 60,
    //               height: 60,
    //               child: CircularProgressIndicator(),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(top: 16),
    //               child: Text(local.wait),
    //             )
    //           ];
    //           break;
    //       }
    //     }
    //     return Column(
    //       children: children,
    //
    //     );
    //   });
  }




}


class NotFound extends StatelessWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ///get language
    var local = getAppLang(context);

    return    Container(
        margin: EdgeInsets.symmetric(
          vertical: getScreenHeight(context) / 7,
        ),
        alignment: Alignment.bottomCenter,
        child: Text(local.noTasksFound));
  }
}



