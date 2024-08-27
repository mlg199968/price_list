


import 'package:flutter/material.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:myket_iap/myket_iap.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/constants/constants.dart';
// import 'package:price_list/screens/purchase_screen/purchase_screen.dart';
import 'package:price_list/services/pay_service.dart';
import 'package:provider/provider.dart';

import '../../constants/enums.dart';
import '../../constants/private.dart';
import '../../constants/utils.dart';
import '../../providers/user_provider.dart';
import '../ware_list/ware_list_screen.dart';

class BazaarPurchaseScreen extends StatefulWidget {
  static const String id = "/bazaarPurchaseScreen";

  BazaarPurchaseScreen({super.key});

  @override
  State<BazaarPurchaseScreen> createState() => _BazaarPurchaseScreenState();
}

class _BazaarPurchaseScreenState extends State<BazaarPurchaseScreen> {
  final licenseTextController = TextEditingController();
//TODO:myket starter api
  getMyketStartUpData()async{
    // if (Platform.isAndroid) {
    //   var iabResult = await MyketIAP.init(
    //       rsaKey: PrivateKeys.rsaKeyMyket, enableDebugLogging: true);
    //   print("myket starter checker");
    //   print(iabResult?.toJson());
    //   if(iabResult==null || !iabResult.isSuccess()){
    //     ErrorHandler.errorManger(context, iabResult,title:"مشکل برقراری ارتباط با برنامه مایکت",showSnackbar: true);
    //   }
    // }
  }

  getBazaarData()async{
    bool connectionState=await FlutterPoolakey.connect(
      PrivateKeys.rsaKey,
      onDisconnected: () {
        showSnackBar(context, "خطا در ارتباط با بازار");
        print("bazaar not connected");
      },
    );
    if(connectionState){
      PurchaseInfo? purchaseInfo = await FlutterPoolakey.querySubscribedProduct('0');
      print(purchaseInfo.toString());
      if(false){
        Provider.of<UserProvider>(context,listen: false).setUserLevel(1);
        Navigator.pushNamedAndRemoveUntil(context, WareListScreen.id,(route)=>false);
        showSnackBar(context, "برنامه با موفقیت فعال شد",type: SnackType.success,dialogMode: true);
      }
    }
  }
@override
  void initState() {
    getBazaarData();
   getMyketStartUpData();

  super.initState();
  }
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,),
      backgroundColor: Colors.deepPurple,
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: double.maxFinite,
        decoration: BoxDecoration(
            gradient: kMainGradiant,
),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///circle crown
                    CrownIcon(),
                    SizedBox(height: 50),

                    ///info part
                    Center(
                        child: Text(
                      "قابلیت های نسخه کامل برنامه :",
                      style: TextStyle(color: Colors.yellow, fontSize: 20),
                    )),
                    SizedBox(height: 20),
                    TextWithIcon(
                        text: "امکان گرفتن خروجی پی دی اف کالا های انتخابی"),
                    TextWithIcon(
                        text:
                            "تغییر و چاپ گروهی کالا ها بصورت درصدی یا مبلغ ثابت"),

                    TextWithIcon(text: "دسترسی به بخش تنظیمات"),
                    SizedBox(
                      height: 50,
                    ),

                    //TODO: bazaar purchase button
                   BazaarButton(),
                    //TODO: myket purchase button
                    // MyketButton(),
                    //TODO:license payment
                    ///alternative way for payment
                    //    Divider(height: 40,),
                    // Text("درصورت مواجه شدن با خطا درخرید از بازار می توانید از روش زیر اقدام به فعال سازی نسخه کامل اپ نمایید.",style: TextStyle(color: Colors.white70,fontSize: 12),),
                    // SizedBox(height: 30,),
                    // ///buy license button
                    // Center(
                    //   child: CustomButton(
                    //     height: 35,
                    //     fontSize: 15,
                    //     width: 200,
                    //     radius: 20,
                    //     color: Colors.deepPurpleAccent,
                    //     text: "فعال سازی با لایسنس",
                    //     onPressed: ()  {
                    //      Navigator.pushNamed(context, PurchaseScreen.id);
                    //     },
                    //   ),
                    // ),


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

class CrownIcon extends StatelessWidget {
  const CrownIcon({
    super.key, this.size=150,
  });
  final double size;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.orangeAccent,
              strokeAlign: BorderSide.strokeAlignCenter,
              width: 5),
          shape: BoxShape.circle,
        ),
        child: ShaderMask(
          shaderCallback: (rect) => const LinearGradient(
            colors: [
              Colors.orangeAccent,
              Colors.yellow,
              Colors.orangeAccent,
            ],
          ).createShader(rect),
          child:  Icon(
            FontAwesomeIcons.crown,
            size: size*.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
///
class BazaarButton extends StatelessWidget {
  const BazaarButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        fontSize: 18,
        width: 200,
        radius: 20,
        color: Colors.green,
        text: "خرید از بازار",
        onPressed: ()async{
          await PayService.connectToBazaar(context);
        },
      ),
    );
  }
}
///
class MyketButton extends StatelessWidget {
  const MyketButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        fontSize: 18,
        width: 200,
        radius: 20,
        color: Colors.blue,
        text: "خرید از مایکت",
        onPressed: ()async{
         await PayService.connectToMyket(context);
        },
      ),
    );
  }
}


///
class TextWithIcon extends StatelessWidget {
  const TextWithIcon({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            FontAwesomeIcons.circleCheck,
            color: Colors.yellow,
            size: 17,
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 15, color: Colors.white),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
