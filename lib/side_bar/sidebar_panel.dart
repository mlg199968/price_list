
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:price_list/components/glass_bg.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/side_bar/setting/setting_screen.dart';

class SideBarPanel extends StatelessWidget {
  const SideBarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 3),
        decoration: BoxDecoration(
          color: Colors.white70.withOpacity(.5),
          //borderRadius: BorderRadius.only(bottomRight: Radius.elliptical(500, 150),topRight: Radius.circular(10))
        ),
        child: GlassBackground(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ///top info part
              Stack(
                  children: [
                Container(
                  height: 150,
                  decoration: const BoxDecoration(
                      gradient: kMainGradiant ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back,size: 30,)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(top: 40),
                    child: Text(
                      "لیست قیمت",
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const AvatarHolder()
              ]),
              Column(
                children: [
                  menu_button(
                    text: "مشخصات فروشگاه",
                    icon: Icons.factory,
                    onPress: () {
                    },
                  ),
                  menu_button(
                    text: "تنظیمات",
                    icon: Icons.settings_outlined,
                    onPress: () {
                      Navigator.pushNamed(context, SettingScreen.id);
                    },
                  ),
                  menu_button(
                    onPress: () {
                      Navigator.pushNamed(context, SettingScreen.id);
                    },
                    text: "ارتباط با ما",
                    icon: Icons.support_agent_outlined,
                  ),
                ],
              ),

              ///links
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'images/mlggrand.png',
                      width: 110,
                    ),
                    IconButton(
                        onPressed: () {
                          // _launchUrl('https://instagram.com/mlg_grand?igshid=YmMyMTA2M2Y=');
                        },
                        icon: const Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.white,
                          size: 25,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          FontAwesomeIcons.telegram,
                          color: Colors.white,
                          size: 25,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarHolder extends StatelessWidget {
  const AvatarHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? logo;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        heightFactor: 1.7,
        alignment: Alignment.bottomCenter,
        child: CircleAvatar(
          backgroundColor: Colors.white70,
          radius: 50,
          child: CircleAvatar(
            backgroundColor: Colors.indigo,
            foregroundImage: logo != null
                ? FileImage(
                    File(logo),
                  )
                : null,
            radius: 48,
            child: logo != null
                ? null
                : Icon(
              Icons.person,
              size: 70,
            ),
          ),
        ),
      ),
    );
  }
}

class menu_button extends StatelessWidget {
  const menu_button(
      {super.key, required this.text, required this.onPress, this.icon});
  final String text;
  final IconData? icon;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    //decelerations
    Color textColor = Colors.black.withOpacity(.8);
    Color borderColor = Colors.blue;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.4),
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: borderColor,
            ),
            left: BorderSide(
              width: 5,
              color: textColor,
            ),
          ),
        ),
        child: TextButtonTheme(
          data: const TextButtonThemeData(
            style: ButtonStyle(
              alignment: Alignment.centerRight,
              padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
            ),
          ),
          child: TextButton(
              onPressed: onPress,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: TextStyle(fontSize: 18, color: textColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      child:
                          icon == null ? null : Icon(icon, color: textColor)),
                ],
              )),
        ));
  }
}
