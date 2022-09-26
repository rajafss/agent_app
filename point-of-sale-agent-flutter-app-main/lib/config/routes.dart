import 'package:agent/resources/constants.dart';
import 'package:agent/screens/common_widgets/bottom_bar.dart';
import 'package:agent/screens/login/presentation/old/login.dart';
import 'package:agent/screens/login/presentation/online_agents.dart';
import 'package:agent/screens/login/presentation/verification_agent.dart';
import 'package:agent/screens/login/presentation/verification_company.dart';
import 'package:agent/screens/monthly_orders/presentation/one_month_orders.dart';
import 'package:agent/screens/splash/splash.dart';
import 'package:flutter/material.dart';


class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return  MaterialPageRoute(builder: (_) => const Splash());
      case loginRoute:
        return  MaterialPageRoute(builder: (_) => const Login());
      case bottomBarRoute:
        return  MaterialPageRoute(builder: (_) => const BottomBar());
      case companyRoute:
        return MaterialPageRoute(builder: (_) => const VerificationCompany());
      case agentCodeRoute:
        return MaterialPageRoute(builder: (_) =>  VerificationAgent());

      case agentOnlineRoute:
      //  final  routeArgs = settings.arguments as int;
        return MaterialPageRoute(builder: (_) =>  const AgentsOnline());
      case oneMonthOrdersRoute:
        final  routeArgs = settings.arguments as String;
        return MaterialPageRoute(builder: (_) =>   OneMonthOrders(date: routeArgs,));
      // case tasksRoute:
      //   final  routeArgs = settings.arguments as ArgumentData;
      //   //argumentData: routeArgs,
      //   return  MaterialPageRoute(builder: (_) =>  Tasks());
      // case profileRoute:
      //   return  MaterialPageRoute(builder: (_) => const Profile());
      // case settingsRoute:
      //   return  MaterialPageRoute(builder: (_) => const Settings());

    // case feedRoute:
    //   var data = about.arguments as String;
    //   return MaterialPageRoute(builder: (_) => Feed(data));
      default:
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}