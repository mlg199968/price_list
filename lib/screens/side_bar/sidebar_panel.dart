import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/over_cage.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/bazaar_purchase_screen.dart';
import 'package:price_list/screens/group_management_screen.dart';
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
    return Drawer(
      width: 250,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 3),
        child: BlurryContainer(
          color: Colors.white.withOpacity(.3),
          borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(40)),
          elevation: 10,
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
                 AvatarHolder(vip: wareProvider.isVip,)
              ]),
              Column(
                children: [
                  BarButton(
                    text: "مشخصات فروشگاه",
                    icon: Icons.storefront_outlined,
                    onPress: () {
                        Navigator.pushNamed(context, ShopInfoScreen.id);}
                  ),
                  BarButton(
                    text: "مدیریت گروه ها",
                    icon: Icons.account_tree_outlined,
                    onPress: () {
                      Navigator.pushNamed(context, GroupManagementScreen.id);
                    },
                  ),
                  BarButton(
                    text: "تنظیمات",
                    icon: Icons.settings_outlined,
                    onPress: () {
                      Navigator.pushNamed(context, SettingScreen.id);
                    },
                  ),
                  BarButton(
                    onPress: () {
                      urlLauncher(
                          context: context, urlTarget: "http://mlggrand.ir");
                    },
                    text: "ارتباط با ما",
                    icon: Icons.support_agent_outlined,
                  ),
                ],
              ),
              ///purchase Button
              //we check here if user is vip ,we hide the purchase button
              wareProvider.isVip?SizedBox():
              PurchaseButton(),

              ///links
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      'assets/images/mlggrand.png',
                      width: 110,
                    ),
                    //instagram button
                    IconButton(
                        onPressed: () {
                          urlLauncher(
                              context: context,
                              urlTarget:
                                  'https://instagram.com/mlg_grand?igshid=YmMyMTA2M2Y=');
                        },
                        icon: const Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.white,
                          size: 25,
                        )),
                    //telegram button
                    IconButton(
                        onPressed: () {
                          urlLauncher(
                              context: context,
                              urlTarget: "http://t.me/mlg_grand");
                        },
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

class PurchaseButton extends StatelessWidget {
  const PurchaseButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, BazaarPurchaseScreen.id);
        //Navigator.pushNamed(context, PurchaseScreen.id);
      },
      child: Container(
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



class AvatarHolder extends StatelessWidget {
  const AvatarHolder({
    super.key, this.vip=false,
  });
  final bool vip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        heightFactor: 1.7,
        alignment: Alignment.bottomCenter,
        child:vip
        ?CrownIcon(size: 100,)
        :CircleAvatar(
          backgroundColor: Colors.white70,
          radius: 50,
          child: CircleAvatar(
            backgroundColor:Colors.deepPurple,
            radius: 48,
            child:Icon(
                    Icons.person,
                    size: 70,
                  ),
          ),
        ),
      ),
    );
  }
}

class BarButton extends StatelessWidget {
  const BarButton(
      {super.key, required this.text, required this.onPress, this.icon, this.enable=true});
  final String text;
  final bool enable;
  final IconData? icon;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    //decelerations
    Color textColor = Colors.black.withOpacity(.7);
    Color borderColor = kMainColor;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.7),
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: borderColor,
            ),
            left: BorderSide(
              width: 10,
              color: textColor,
            ),
          ),
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
                  CText(
                    text,
                    fontSize: 15, color: textColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                      child:
                      icon == null ? null : Icon(icon, color: textColor.withOpacity(.5))),
                ],
              )),
        ));
  }
}
