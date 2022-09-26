import 'package:agent/config/utils.dart';
import 'package:agent/resources/colors.dart';
import 'package:agent/resources/styles.dart';
import 'package:agent/screens/common_widgets/custom_container.dart';
import 'package:agent/screens/settings/presentation/widgets/drop_down_lang.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MobSettings extends StatelessWidget {
  const MobSettings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      //const CustomContainer(),
      Container(
        margin: EdgeInsets.only(
            top: getScreenHeight(context) * .2,
            left: getScreenWidth(context) * .1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Language',
                  style:
                      nameProfile.copyWith(color: fieldTextColor, fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  width: getScreenWidth(context) * .5,
                ),
                const DropDownLanguage()
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Privacy & Policy',
              style: nameProfile.copyWith(color: fieldTextColor, fontSize: 15),
              textAlign: TextAlign.left,
            ),
            Container(
              alignment: Alignment.bottomCenter,
            //  margin: EdgeInsets.only(top: getScreenHeight(context) * .3),
              child: Text(
                'Next Evolution © 2022',
                style: companyText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
