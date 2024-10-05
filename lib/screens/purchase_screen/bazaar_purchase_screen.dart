import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
// import 'package:myket_iap/myket_iap.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/dynamic_button.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/screens/purchase_screen/services/bazaar_api.dart';
import 'package:price_list/screens/purchase_screen/services/purchase_tools.dart';
// import 'package:price_list/screens/purchase_screen/purchase_screen.dart';
import 'package:price_list/services/pay_service.dart';
import 'package:provider/provider.dart';
import '../../components/custom_text.dart';
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
  String productId="m6";
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
      List<PurchaseInfo> purchaseList = await FlutterPoolakey.getAllPurchasedProducts();
      List<PurchaseInfo> subsList = await FlutterPoolakey.getAllSubscribedProducts();
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(purchaseInfo?.purchaseTime ?? 1);
      // PurchaseInfo? purchaseInfo2 =await FlutterPoolakey.purchase("3");
      print(dateTime);
      print(subsList);
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
                  // mainAxisSize: MainAxisSize.min,
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
                    TextWithIcon(text: "در صورت بروز مشکل در پرداخت با پیشتیبانی در ارتباط باشید",
                      icon: Icons.error_outline_outlined,
                      iconColor: Colors.red,
                    ),
                    //TODO: bazaar purchase button
                    Gap(10),
                    DynamicButton(
                      height: 40,
                      width: 400,
                      label: "خرید اشتراک دائم",
                      icon: FontAwesomeIcons.infinity,
                      bgColor: Colors.transparent,
                      borderColor: Colors.amberAccent,
                      iconColor: Colors.amber,
                      borderRadius: 10,
                      onPress: ()async{
                        await BazaarApi.connectToBazaar2(context);
                      },
                    ),
                    Gap(10),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white70)
                          ),
                          child: Column(
                            children: [
                              SubscribeHolder(
                                title: "یک ماهه",
                                type: "m1",
                                selected: productId=="m1",
                                onChange: (val){
                                  productId=val;
                                  setState(() {});
                                },
                              ),
                              SubscribeHolder(
                                title: "شش ماهه",
                                type: "m6",
                                selected: productId=="m6",
                                onChange: (val){
                                  productId=val;
                                  setState(() {});
                                },
                              ),
                              SubscribeHolder(
                                title: "یک ساله",
                                type: "m12",
                                selected: productId=="m12",
                                onChange: (val){
                                  productId=val;
                                  setState(() {});
                                },
                              ),
                             // SubscribeHolder(
                             //    title: "test",
                             //    type: "0",
                             //    selected: productId=="0",
                             //    onChange: (val){
                             //      productId=val;
                             //      setState(() {});
                             //    },
                             //  ),
                              Gap(15),
                              BazaarButton(productId: productId,),
                            ],
                          ),
                        ),
                      ],
                    ),
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

///
class SubscribeHolder extends StatelessWidget {
  const SubscribeHolder({
    super.key,
    required this.onChange,
    this.selected=false,
    required this.title,
    required this.type,this.showSubsText=true,
  });

  final String title;
  final Function(String type) onChange;
  final bool selected;
  final String type;
  List<Color> get colors =>PurchaseTools.convertPlan(type)["colors"];
  final bool showSubsText;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onChange(type);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        transformAlignment: Alignment.center,
        curve: Curves.bounceInOut,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        width: 400,
        height: selected?40:35,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(selected?1:.7),
            gradient: LinearGradient(
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(selected?20:5),
            border: Border.all(
                color: selected?Colors.orange:Colors.white70,
                width: selected?1:0.5
            ),
            boxShadow:selected? [const BoxShadow(color: Colors.orange,blurRadius: 10)]:null
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(showSubsText)
            const CText(" اشتراک ",fontSize: 13,color: Colors.amberAccent,),
            CText(title,fontSize: 15,color: Colors.white,),
          ],
        ),
      ),
    );
  }
}
///
class CrownIcon extends StatelessWidget {
  const CrownIcon({
    super.key, this.size=80,
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
          // color: Colors.white,
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
    super.key, required this.productId, this.isPurchase=false,
  });
  final String productId;
  final bool isPurchase;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: DynamicButton(
        height: 45,
        width: 400,
        bgColor: Colors.black54,
        borderColor: Colors.amber,
        label: "خرید از بازار",
        borderRadius: 15,
        iconSize: 14,
        icon: CupertinoIcons.back,
        image: "assets/icons/bazaar.png",
        direction: TextDirection.ltr,
        onPress: ()async{
          if(isPurchase) {
            await BazaarApi.connectToBazaar2(context);
          }
          else {
            await BazaarApi.connectToBazaar(context, productId);
          }
          // await PayService.connectToBazaar2(context);
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
    required this.text, this.icon, this.iconColor,
  });

  final String text;
  final IconData? icon;
  final Color? iconColor;
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
           icon ?? FontAwesomeIcons.circleCheck,
            color: iconColor ?? Colors.yellow,
            size: 17,
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.white),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}

