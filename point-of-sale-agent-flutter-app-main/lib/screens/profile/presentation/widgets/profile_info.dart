import 'package:agent/config/utils.dart';
import 'package:agent/resources/colors.dart';
import 'package:agent/resources/styles.dart';
import 'package:agent/screens/common_widgets/custom_container.dart';
import 'package:agent/screens/common_widgets/services_liste.dart';
import 'package:agent/screens/common_widgets/stream_messages.dart';
import 'package:agent/screens/login/data/models/agent_data.dart';
import 'package:agent/screens/profile/data/repository/profile_repository.dart';
import 'package:agent/screens/profile/domain/notifier/profile_notifier.dart';
import 'package:agent/screens/profile/presentation/widgets/photo_worker.dart';
import 'package:agent/screens/profile/presentation/widgets/space_widget.dart';
import 'package:agent/screens/profile/presentation/widgets/total_tasks.dart';
import 'package:agent/screens/tasks/common_utils.dart';
import 'package:agent/screens/tasks/data/models/agent_order.dart';
import 'package:agent/screens/tasks/data/models/order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../monthly_orders/presentation/monthly_orders.dart';

class ProfileInfo extends StatelessWidget {
  // final String fullName;
  // final String picture;
  // final String status;
  // final List<String> services;
  const ProfileInfo({
    Key? key,
    // required this.fullName,
    // required this.picture,
    // required this.status,
    // required this.services
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileWatch = context.watch<ProfileProvider>();

    StreamLoading _streamLoading = StreamLoading();

    final ProfileRepository _profileRepository = ProfileRepository();

    ///get language
    var local = getAppLang(context);

    return CustomContainer(
      widget: Container(
        margin: EdgeInsets.only(
            left: getScreenWidth(context) * .1,
            right: getScreenWidth(context) * .1,
            top: 10 //getScreenHeight(context) / 2 * .1,
            ),
        child: ListView(
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            ///Agent picture
            const AgentPhoto(),

            ///Full name
            FutureBuilder<DatabaseEvent>(
                future: _profileRepository.getAgentInfoById(),
                builder: (context, snapshot) {
                  List<Widget> children = [];
                  if (snapshot.hasError) {
                    children = _streamLoading.hasError(snapshot);
                  } else {
                    if (!snapshot.hasData ||
                        snapshot.data!.snapshot.value == null) {
                      children = <Widget>[Text(local.noInfoFound)];
                    } else {
                      Agent agent;
                      Map<String, Agent> map =
                          getAgentDataInType(snapshot.data!.snapshot.value);
                      agent = map.values.single;

                      children = <Widget>[
                        Text(
                          agent.fullName.toUpperCase(),
                          style: nameProfile,
                          textAlign: TextAlign.center,
                        ),

                        ///services
                        SizedBox(
                            height: 30,
                            child:
                                ServicesList(const [], agent.serviceIds, true)),
                      ];
                    }
                  }
                  return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: children);
                }),

            ///Divider
            Container(
              height: 2,
              margin: EdgeInsets.only(
                  top: 5, right: getScreenWidth(context) / 2 * .1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: nameColor,
              ),
            ),

            ///TODAY TOTALS
            const TodayTotals(),

            const SizedBox(
              height: 10,
            ),

            ///Spacer
            SpaceWidget(
              height: 1,
              width: getScreenWidth(context) * .4 + 15,
              marginTop: 20,
            ),

            ///ALL TOTALS
            const AllTotals(),

            const SizedBox(
              height: 10,
            ),

            ///Switch button tasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  local.tasks,
                  style:
                      nameProfile.copyWith(color: fieldTextColor, fontSize: 25),
                  textAlign: profileWatch.locale.languageCode == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                ),
                const SwitchButton()
              ],
            ),

            //  Expanded(
            // height: getScreenHeight(context) * .3,
            //  child:
            profileWatch.isSwitched == true
                ? const MonthlyOrders()
                : const TotalTasks()

            //  ),
          ],
        ),
      ),
    );
    //   ],
    //  );
  }
}

class SwitchButton extends StatelessWidget {
  const SwitchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileWatch = context.watch<ProfileProvider>();
    final profileRead = context.read<ProfileProvider>();

    ///get language
    var local = getAppLang(context);

    return Row(
      children: [
        Text(
          local.monthly,
          style: serviceItem.copyWith(color: nameColor),
          // textAlign: profileWatch.locale.languageCode == 'en' ? TextAlign.right : TextAlign.left,
        ),
        Transform.scale(
            scale: 1,
            child: Switch(
              onChanged: profileRead.toggleSwitch,
              value: profileWatch.isSwitched,
              activeColor: secColor,
              activeTrackColor: secColor.withOpacity(0.5),
              inactiveThumbColor: nameColor,
              inactiveTrackColor: disableColor,
            )),
      ],
    );
  }
}

///Agent photo
class AgentPhoto extends StatelessWidget {
  const AgentPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileRepository _profileRepository = ProfileRepository();

    StreamLoading _streamLoading = StreamLoading();

    ///get language
    var local = getAppLang(context);

    return StreamBuilder<DatabaseEvent>(
        stream: _profileRepository.getAgentPic(),
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          List<Widget> children;
          if (snapshot.hasError) {
            children = _streamLoading.hasError(snapshot);
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                children =
                    _streamLoading.connectionStateNone(local.noConnection);
                break;
              case ConnectionState.waiting:
                children = _streamLoading.connectionStateWaiting(local.wait);
                break;
              case ConnectionState.active:

                children = <Widget>[
                  Center(
                      child: PhotoWorker(
                    picture: snapshot.data!.snapshot
                        .child('picture')
                        .value
                        .toString(),
                  )),
                ];
                break;
              case ConnectionState.done:
                children = <Widget>[
                  Center(
                      child: PhotoWorker(
                    picture: snapshot.data!.snapshot
                        .child('picture')
                        .value
                        .toString(),
                  )),
                ];
                break;
            }
          }
          return Stack(
            children: children,
          );
        });
  }
}

///TODAY TOTALS
class TodayTotals extends StatelessWidget {
  const TodayTotals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileRepository = ProfileRepository();
    final profileWatch = context.watch<ProfileProvider>();

    return FutureBuilder<DatabaseEvent>(
        future: profileRepository.getTodayOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const TotalText(
              price: 0.0,
              count: 0,
              todayTotal: true,
            );
          } else {
            List<Map<String, Order>> orders = [];

            final json = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

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
                fetchListOrders(orders, context, finished: true, today: true);

            return TotalText(
              price: profileWatch.totalTodayPrice,
              count: agentOrders.length,
              todayTotal: true,
            );
          }
        });
  }
}

///TOTALS
class AllTotals extends StatelessWidget {
  const AllTotals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileRepository = ProfileRepository();
    final profileWatch = context.watch<ProfileProvider>();

    return FutureBuilder<DatabaseEvent>(
        future: profileRepository.getAllOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const TotalText(
              price: 0.0,
              count: 0,
              todayTotal: false,
            );
          } else {
            List<Map<String, Order>> orders = [];

            final json = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

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
                fetchListOrders(orders, context, finished: true, today: true);

            return TotalText(
              price: profileWatch.totalTodayPrice,
              count: agentOrders.length,
              todayTotal: false,
            );
          }
        });
  }
}

///TOTAL TEXT VIEW
class TotalText extends StatelessWidget {
  final double price;
  final bool todayTotal;
  final int count;
  const TotalText({
    Key? key,
    required this.price,
    required this.count,
    required this.todayTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///get language
    var local = getAppLang(context);

    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(
              top: 5,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 35,
                  height: 35,
                  child: Image.asset(
                    'assets/shield.png',
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  '${todayTotal ? local.todayTasks : local.totalTasks}: $count',
                  style:
                      nameProfile.copyWith(color: fieldTextColor, fontSize: 15),
                  textAlign: TextAlign.left,
                )
              ],
            )),
        Container(
          margin: const EdgeInsets.only(
            top: 5,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.monetization_on,
                color: secColor,
                size: 35,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                '${todayTotal ? local.todayIncome : local.totalIncome}: $price',
                style:
                    nameProfile.copyWith(color: fieldTextColor, fontSize: 15),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ],
    );
  }
}
