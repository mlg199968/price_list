import 'dart:io';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/over_cage.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/purchase_screen/bazaar_purchase_screen.dart';
import 'package:price_list/screens/notice_screen/notice_screen.dart';
import 'package:price_list/screens/notice_screen/services/notice_tools.dart';
import 'package:price_list/screens/setting/setting_screen.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/screens/shop_info_screen/shop_info_screen.dart';
import 'package:provider/provider.dart';

class SideBarPanel extends StatelessWidget {
  const SideBarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final wareProvider=Provider.of<WareProvider>(context,listen: false);
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 600,
          child: Drawer(
            width: 250,
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              child: BlurryContainer(
                color: Colors.white.withOpacity(.3),
                borderRadius: BorderRadius.only(topRight: Radius.circular(0),bottomRight: Radius.circular(40)),
                elevation: 1,
                padding: EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ///top info part
                    Stack(children: [
                      Opacity(
                        opacity: .6,
                        child: Container(
                          height: 150,
                          decoration: const BoxDecoration(gradient: kMainGradiant),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const BackButton(color: Colors.white,),
                            OverCage(
                              active: NoticeTools.checkNewNotifications(),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, NoticeScreen.id);
                                  },
                                  icon: const Icon(
                                    Icons.notifications,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      ///cafe name
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0).copyWith(top: 40),
                          child: Text(
                            wareProvider.shopName,
                            style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                       AvatarHolder(),
                    ]),
                    Column(
                      children: [
                        BarButton(
                          text: "مشخصات فروشگاه",
                          icon: Icons.storefront_rounded,
                          onPress: () {
                              Navigator.pushNamed(context, ShopInfoScreen.id);}
                        ),
                        // BarButton(
                        //   text: "مدیریت گروه ها",
                        //   icon: Icons.account_tree_rounded,
                        //   onPress: () {
                        //     Navigator.pushNamed(context, GroupManagementScreen.id);
                        //   },
                        // ),
                        BarButton(
                          text: "اطلاع رسانی ها",
                          active:NoticeTools.checkNewNotifications(),
                          icon: Icons.notifications_active_rounded,
                          onPress: () {
                            Navigator.pushNamed(context, NoticeScreen.id);
                          },
                        ),
                        BarButton(
                          text: "تنظیمات",
                          icon: Icons.settings_rounded,
                          onPress: () {
                            Navigator.pushNamed(context, SettingScreen.id);
                          },
                        ),
                        /// contact us
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CText(
                                    "ارتباط با ما",
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  Icon(Icons.support_agent_outlined,color: Colors.white,)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ///web site icon button
                                  ActionButton(
                                    onPress: () {
                                      urlLauncher(
                                          context: context,
                                          urlTarget:
                                          "http://mlggrand.ir");
                                    },
                                    icon:
                                    Icons.web,
                                    bgColor: Colors.teal,
                                    borderRadius: 5,
                                  ),
                                  ///instagram icon button
                                  ActionButton(
                                    onPress: () {
                                      urlLauncher(
                                          context: context,
                                          urlTarget:
                                          'https://instagram.com/mlg_grand?igshid=YmMyMTA2M2Y=');
                                    },
                                    icon:
                                    FontAwesomeIcons.instagram,
                                    bgColor: Colors.pinkAccent,
                                    borderRadius: 5,
                                  ),
                                  ///telegram
                                  ActionButton(
                                    onPress: () {
                                      urlLauncher(
                                          context: context,
                                          urlTarget: "http://t.me/mlg_grand");
                                    },
                                    icon:
                                    FontAwesomeIcons.telegram,
                                    bgColor: Colors.lightBlueAccent,
                                    borderRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ],),
                        ),
                      ],
                    ),
                    ///purchase Button
                    //we check here if user is vip ,we hide the purchase button
                    wareProvider.isVip?SizedBox():
                    PurchaseButton(),

                    ///mlg grand logo
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0,bottom: 5),
                        child: Image.asset(
                          'assets/images/mlggrand.png',
                          width: 90,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
///
class PurchaseButton extends StatelessWidget {
  const PurchaseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        // Navigator.pushNamed(context, PurchaseScreen.id);
        Navigator.pushNamed(context, BazaarPurchaseScreen.id);
      },
      child: Container(
        width: 400,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.yellow, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(blurRadius: 2,color: Colors.grey,offset: Offset(1, 1))
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("خرید نسخه کامل"),
            SizedBox(
              width: 8,
            ),
            Icon(
              FontAwesomeIcons.crown,
              color: Colors.yellowAccent,
            ),
          ],
        ),
      ),
    );
  }
}
///
class AvatarHolder extends StatelessWidget {
  const AvatarHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String? logo = Provider.of<WareProvider>(context, listen: false).logoImage;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        heightFactor: 1.7,
        alignment: Alignment.bottomCenter,
        child: CircleAvatar(
          backgroundColor: Colors.white70,
          radius: 50,
          child: CircleAvatar(
            backgroundColor: kMainColor,
            foregroundImage: logo != null
                ? FileImage(
              File(logo),
            )
                : null,
            radius: 48,
            child: logo != null
                ? null
                : Image.asset(
              'assets/images/logo.png',
              height: 60,
            ),
          ),
        ),
      ),
    );
  }
}
///
class BarButton extends StatelessWidget {
  const BarButton(
      {super.key, required this.text, required this.onPress, this.icon, this.enable=true,this.active=false});
  final String text;
  final bool enable;
  final IconData? icon;
  final VoidCallback onPress;
  final bool active;
  @override
  Widget build(BuildContext context) {
    //decelerations
    Color textColor = Colors.white;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 1),
      decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(5),
          // boxShadow: const [BoxShadow(color: Colors.black45,blurRadius: 3,offset: Offset(2, 3))]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 8,vertical: 1),
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 0),
            decoration: BoxDecoration(
              color: Colors.black,
              gradient: LinearGradient(colors: [Colors.indigoAccent,Colors.deepPurpleAccent]),
              // border: Border(
              //   bottom: BorderSide(
              //     width: 2,
              //     color: borderColor,
              //   ),
              // ),
            ),
            child: TextButtonTheme(
              data: const TextButtonThemeData(
                style: ButtonStyle(
                  alignment: Alignment.centerRight,
                  padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
                ),
              ),
              child: TextButton(
                  onPressed:enable? onPress : (){},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if(active)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.circle,
                              size: 15
                              ,color: Colors.red,
                              ),
                        ),
                      Expanded(child: SizedBox()),
                      CText(
                        text,
                        fontSize: 15, color: textColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      if(icon!=null)
                      Icon(icon, color: Colors.amber.withOpacity(.7),size: 20,),
                    ],
                  )),
            )),
      ),
    );
  }
}