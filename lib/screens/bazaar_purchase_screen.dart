import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/pay_services/pay_service.dart';
import 'package:price_list/screens/purchase_screen.dart';

class BazaarPurchaseScreen extends StatelessWidget {
  static const String id = "/bazaarPurchaseScreen";

  BazaarPurchaseScreen({super.key});

  final licenseTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 150,
                        height: 150,
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
                          child: const Icon(
                            FontAwesomeIcons.crown,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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

                    TextWithIcon(text: "شخصی سازی نمایش فیلد ها"),
                    SizedBox(
                      height: 50,
                    ),

                    ///buy from bazaar button
                    //BazaarButton(),
                       MyketButton(),
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
        //  await PayService.connectToBazaar(context);
        },
      ),
    );
  }
}

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