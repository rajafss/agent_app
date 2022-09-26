import 'package:agent/config/shared_preference.dart';
import 'package:agent/config/utils.dart';
import 'package:agent/resources/colors.dart';
import 'package:agent/resources/constants.dart';
import 'package:agent/resources/styles.dart';
import 'package:agent/screens/common_widgets/custom_container.dart';
import 'package:agent/screens/login/data/repository/login_repository.dart';
import 'package:agent/screens/profile/domain/notifier/profile_notifier.dart';
import 'package:agent/screens/settings/data/repository/repository.dart';
import 'package:agent/screens/settings/data/repository/settings_repository.dart';
import 'package:agent/screens/settings/domain/utils.dart';
import 'package:agent/screens/settings/presentation/widgets/button_widget.dart';
import 'package:agent/screens/settings/presentation/widgets/drop_down_lang.dart';
import 'package:agent/screens/settings/presentation/widgets/password_field.dart';
import 'package:agent/screens/settings/presentation/widgets/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginRepository _loginRepository = LoginRepository();
    final _formKey = GlobalKey<FormState>();

    ///get language
    var local = getAppLang(context);

    final profileWatch = context.watch<ProfileProvider>();

    var newPassController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    var passwordController = TextEditingController();

    final SettingsRepository _settingRepository = SettingsRepository();

    void clearText() {
      confirmPasswordController.clear();
      newPassController.clear();
      passwordController.clear();
    }

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            //     insetPadding: const EdgeInsets.symmetric(vertical: 150),
            title: Text(
              local.updatePass, //style: profileData,
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PasswordFromField(
                        onPressed: () {},
                        hintText: local.enterPass,
                        textEditingController: passwordController,
                        validator: (value) =>
                            passwordFieldValidator(value, context)

                        ///passwordFieldValidator(passwordController.text, context),
                        ),

                    const SizedBox(
                      height: 10,
                    ),

                    PasswordFromField(
                        onPressed: () {},
                        hintText: local.enterNewPass,
                        textEditingController: newPassController,
                        validator: (value) =>
                            passwordFieldValidator(value, context)
                        //passwordFieldValidator(newPassController.text, context),
                        ),

                    const SizedBox(
                      height: 10,
                    ),

                    PasswordFromField(
                        onPressed: () {},
                        hintText: local.enterAgainNewPass,
                        textEditingController: confirmPasswordController,
                        validator: (value) {
                          //     passwordFieldValidator(value, context);

                          if (value != newPassController.text) {
                            return local.matchPassword;
                          }
                        }),

                    const SizedBox(
                      height: 10,
                    ),

                    // BlocConsumer<ProfileCubit, ProfileState>(
                    //     listener: (context, state) {},
                    //     builder: (context, state) {
                    //       if (state is UpdatePasswordLoading) {
                    //         return const CircularProgressIndicator(
                    //           color: primaryColor,
                    //         );
                    //       } else {
                    //         return Container();
                    //       }
                    //     }
                    // )
                  ],
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: <Widget>[
              ButtonWidget(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _settingRepository
                        .updatePassword(
                            oldPassword: int.tryParse(passwordController.text)!,
                            newPassword: int.tryParse(newPassController.text)!)
                        .then((value) {
                      if (value == PasswordResult.success) {
                        showMessage(
                          local.passSuccess,
                          context: context,
                        );
                      } else if (value == PasswordResult.same) {
                        showMessage(
                          local.sameOldPass,
                          context: context,
                        );
                      } else {
                        showMessage(
                          local.passFailed,
                          context: context,
                        );
                      }
                    });
                    clearText();
                    Navigator.pop(buildContext);
                  }
                },
                color: primaryColor,
                title: local.update,
              ),
              ButtonWidget(
                onPressed: () {
                  clearText();
                  Navigator.pop(buildContext);
                },
                color: endTaskButton,
                title: local.cancel,
              )
            ],
          );
        },
      );
    }

    return

        //    Stack(children: [

        CustomContainer(
            widget: Container(
      margin: EdgeInsets.only(
        top: getScreenHeight(context) * .2,
        right: getScreenWidth(context) * .1,
        left: getScreenWidth(context) * .1,
      ),
      // padding: EdgeInsets.symmetric(
      //     horizontal: profileWatch.locale.languageCode == 'en'
      //         ? 10
      //         : getScreenWidth(context) * .1
      // ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  local.language,
                  style:
                      nameProfile.copyWith(color: fieldTextColor, fontSize: 15),
                  textAlign: profileWatch.locale.languageCode == 'en'
                      ? TextAlign.left
                      : TextAlign.right,
                ),

                // SizedBox(
                //   width: getScreenWidth(context) * .4,
                // ),
                DropDownLanguage(),
              ],
            ),

            const SizedBox(
              height: 5,
            ),

            ///Password
            Row(
              children: [
                Expanded(
                  child: Text(
                    local.password,
                    style: nameProfile.copyWith(
                        color: fieldTextColor, fontSize: 15),
                  ),
                ),
                SizedBox(
                  width: getScreenWidth(context) * .2,
                ),
                Expanded(
                  child: IconButton(
                      onPressed: () async {
                        await _showMyDialog();
                      },
                      icon: const Icon(Icons.edit)),
                )
              ],
            ),

            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewPage(
                            selectedUrl:
                                "https://www.freeprivacypolicy.com/live/f6b44808-e70d-450a-a9b7-d5333693236b",
                            title: local.privacy)));
              },
              child: Text(
                local.privacy,
                style:
                    nameProfile.copyWith(color: fieldTextColor, fontSize: 15),
                textAlign: profileWatch.locale.languageCode == 'en'
                    ? TextAlign.left
                    : TextAlign.right,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                ///get agent Id from shared preference
                final agID = Prefs.getString(agentId);

                ///get agent Code from shared preference
                final agCode = Prefs.getString(agentCodeSave);
                final listAgentPassword = Prefs.getStringList(listAgentsCode);
                //code agent
                listAgentPassword?.remove(agCode);

                ///save codes agent list
                Prefs.setStringList(listAgentsCode, listAgentPassword!);

                ///set login history
                //final date = DateTime.now().millisecondsSinceEpoch;
                await _loginRepository.addLoginHistory(
                    type: 'sign out', agentID: agID);

                Navigator.pushNamed(context, agentOnlineRoute);
              },
              child: Text(
                local.signOut,
                style:
                    nameProfile.copyWith(color: fieldTextColor, fontSize: 15),
                textAlign: profileWatch.locale.languageCode == 'en'
                    ? TextAlign.left
                    : TextAlign.right,
              ),
            ),
            Container(
              //  alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(
                top: getScreenHeight(context) * .2,
                right: 20,
              ),
              child: const Text(
                'Next Evolution © 2022',
                style: companyText,
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ));
    //  ]);

    //   ResponsiveBuilder(
    //   builder: (context, sizingInformation) {
    //     if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
    //       return const TabSettings();
    //     }
    //     return   const MobSettings();
    //   },
    // );
  }
}
