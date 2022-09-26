import 'package:agent/resources/colors.dart';
import 'package:agent/resources/constants.dart';
import 'package:agent/screens/common_widgets/stream_messages.dart';
import 'package:agent/screens/monthly_orders/domain/monthly_service.dart';
import 'package:agent/screens/monthly_orders/domain/utils.dart';
import 'package:agent/screens/profile/domain/notifier/profile_notifier.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/utils.dart';

class MonthlyOrders extends StatelessWidget {
  const MonthlyOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MonthlyService monthlyService = MonthlyService();

    ///get language
    var local = getAppLang(context);

    final profileWatch = context.watch<ProfileProvider>();

    StreamLoading _streamLoading = StreamLoading();

    return FutureBuilder<DatabaseEvent>(
        future: monthlyService.getCurrentYearOrdersKey(),
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
                children = _streamLoading.connectionStateWaiting(local.wait);

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

                  List<String> date = [];
                  json.forEach((key, value) {
                    if (date.isNotEmpty) {
                      List<String> foundList = date
                          .where((element) =>
                              getPeriod(currentDate: element) ==
                              getPeriod(currentDate: key))
                          .toList();

                      if (foundList.isEmpty) {
                        date.add(key);
                      }
                    } else {
                      date.add(key);
                    }
                  });

                  date.sort((b, a) => b.compareTo(a));

                  children = <Widget>[
                    GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: date.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                            onTap: () {
                              ///navigate to Tasks Screen
                              Navigator.pushNamed(
                                context,
                                oneMonthOrdersRoute,
                                arguments: date[index],
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                getPeriod(
                                    currentDate: date[index],
                                    lang: profileWatch.locale.languageCode),
                                style: const TextStyle(
                                    color: secondColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20),
                              ),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          );
                        }),

                    // const SizedBox(
                    //   height: 20,
                    // )
                  ];
                }
                break;
              case ConnectionState.active:
                // TODO: Handle this case.
                break;
            }
          }
          return Stack(
            children: children,
          );
        });
  }
}
