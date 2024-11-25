import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
// import 'package:myket_iap/myket_iap.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/dynamic_button.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/screens/purchase_screen/services/bazaar_api.dart';
import 'package:price_list/screens/purchase_screen/services/myket_api.dart';
import 'package:price_list/screens/purchase_screen/services/purchase_tools.dart';
import 'package:price_list/services/pay_service.dart';
import '../../components/custom_text.dart';
import 'bazaar_purchase_screen.dart';



class MyketPurchaseScreen extends StatefulWidget {
  static const String id = "myket-purchase-screen";

  MyketPurchaseScreen({super.key});

  @override
  State<MyketPurchaseScreen> createState() => _MyketPurchaseScreenState();
}

class _MyketPurchaseScreenState extends State<MyketPurchaseScreen> {
  final licenseTextController = TextEditingController();
  String productId="m6";
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
                    //TODO: myket purchase button
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
                        await MyketApi().purchase(context,"p1");
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
                             if(kDebugMode)
                             SubscribeHolder(
                                title: "test",
                                type: "m0",
                                selected: productId=="m0",
                                onChange: (val){
                                  productId=val;
                                  setState(() {});
                                },
                              ),
                              Gap(15),
                              MyketButton(productId: productId,),
                            ],
                          ),
                        ),
                      ],
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
class MyketButton extends StatelessWidget {
  const MyketButton({
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
        label: "خرید از مایکت",
        borderRadius: 15,
        iconSize: 14,
        icon: CupertinoIcons.back,
        image: "assets/icons/myket.png",
        direction: TextDirection.ltr,
        onPress: ()async{
          if(isPurchase) {
          }
          else {
            await MyketApi().purchase(context, productId);
          }
          // await PayService.connectToBazaar2(context);
        },
      ),
    );
  }
}




