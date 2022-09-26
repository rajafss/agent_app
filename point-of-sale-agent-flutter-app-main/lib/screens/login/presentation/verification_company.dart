import 'package:agent/config/shared_preference.dart';
import 'package:agent/config/utils.dart';
import 'package:agent/resources/colors.dart';
import 'package:agent/resources/constants.dart';
import 'package:agent/resources/styles.dart';
import 'package:agent/screens/common_widgets/app_bar.dart';
import 'package:agent/screens/login/data/models/company_data.dart';
import 'package:agent/screens/login/data/repository/login_repository.dart';
import 'package:agent/screens/login/presentation/widgets/verification_code.dart';
import 'package:agent/screens/profile/domain/notifier/profile_notifier.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class VerificationCompany extends StatelessWidget {
  const VerificationCompany({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///Hide Bottom Bar (android & ios )
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    final LoginRepository _loginRepository = LoginRepository();
    Stream<DatabaseEvent> stream;

    ///get language
    var local = getAppLang(context);

    final profileWatch = context.watch<ProfileProvider>();

    return WillPopScope(
      onWillPop: () async => Future<bool>.value(false),
      child: Scaffold(
        appBar: AgentBar(
          color: secondColor,
          title: local.companyCode,
          context: context,

          // size: getScreenHeight(context) * .2,
        ),
        body: Container(
          margin: EdgeInsets.only(
            top: getScreenHeight(context) * .2,
          ),
          child: Center(
            child: VerificationCode(
              cursorColor: primaryColor,
              autofocus: true,
              itemSize: getScreenWidth(context) * .1,

              textStyle: const TextStyle(fontSize: 20.0, color: primaryColor),
              keyboardType: TextInputType.number,

              // in case underline color is null it will use primaryColor: Colors.red from Theme
              underlineColor: Colors.amber,
              length: 5,
              // clearAll is NOT required, you can delete it
              // takes any widget, so you can implement your design
              clearAll: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(local.clearAll, style: fieldText),
              ),
              onCompleted: (String value) async {
                if (num.tryParse(value) != null) {

                  value = profileWatch.locale.languageCode == 'ar'
                      ? value.split('').reversed.join()
                      : value;

                  ///Check Code Verification
                  DatabaseEvent event = await _loginRepository
                      .getCompanyInfoByCode(code: int.parse(value));

                  Company _company;
                  if (event.snapshot.value != null) {
                    final json = event.snapshot.value as Map<dynamic, dynamic>;
                    _company = Company.fromJson(json.values.single);

                    /// save company ID
                    await Prefs.setString(companyId, _company.companyId);

                    ///navigate to agent online screen
                    Navigator.pushReplacementNamed(context, agentOnlineRoute);
                  } else {
                    closeKeyboard(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar(local.wrongCode));
                  }
                } else {
                  closeKeyboard(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar(local.numberRequired));
                }
              },
              onEditing: (bool value) {
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
      ),
    );
  }
}
