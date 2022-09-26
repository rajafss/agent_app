import 'package:agent/config/utils.dart';
import 'package:agent/screens/common_widgets/stream_messages.dart';
import 'package:agent/screens/login/data/models/agent_data.dart';
import 'package:agent/screens/profile/data/repository/profile_repository.dart';
import 'package:agent/screens/profile/presentation/widgets/profile_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //#FE7D01
    return   const ProfileInfo();



      // FutureBuilder<DatabaseEvent>(
      //   future: _profileRepository.getAgentInfoById(),
      //   builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
      //     List<Widget> children;
      //     if (snapshot.hasError) {
      //       children = _streamLoading.hasError(snapshot);
      //     } else {
      //
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.none:
      //           children =
      //               _streamLoading.connectionStateNone(local.noConnection);
      //
      //           break;
      //         case ConnectionState.waiting:
      //           children = _streamLoading.connectionStateWaiting(local.wait);
      //
      //           break;
      //         case ConnectionState.done:
      //           if (snapshot.data!.snapshot.value == null) {
      //             children = <Widget>[Text(local.noInfoFound)];
      //           } else {
      //             Agent agent;
      //             Map<String, Agent> map =
      //                 getAgentDataInType(snapshot.data!.snapshot.value);
      //             agent = map.values.single;
      //
      //             children = <Widget>[
      //               ProfileInfo(
      //                 picture: agent.picture,
      //                 fullName: agent.fullName,
      //                 status: agent.status,
      //                 services: agent.serviceIds,
      //               )
      //             ];
      //           }
      //           break;
      //         case ConnectionState.active:
      //           children = <Widget>[];
      //           break;
      //       }
      //     }
      //     return Stack(
      //       children: children,
      //     );
      //   });

    //   ResponsiveBuilder(
    //   builder: (context, sizingInformation) {
    //     if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
    //       return const TabProfile();
    //     }
    //     return const MobProfile();
    //   },
    // );
  }
}
