import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/pay_services/pay_service.dart';

class PurchaseScreen extends StatefulWidget {
  static const String id = "/purchaseScreen";

  PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  final licenseTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool running = false;
  @override
  void dispose() {
    super.dispose();
    licenseTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.deepPurple,
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: kMainGradiant,
              boxShadow: [
                BoxShadow(
                    blurRadius: 5, color: Colors.black26, offset: Offset(5, 5))
              ]),
          child: SingleChildScrollView(
            child: SizedBox(
              width: 500,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        Gap(50),

                        ///info part
                        Center(
                            child: Text(
                          "قابلیت های نسخه کامل :",
                          style: TextStyle(color: Colors.yellow, fontSize: 20),
                        )),
                        Gap(20),
                        TextWithIcon(
                            text:
                                "امکان گرفتن خروجی پی دی اف کالا های انتخابی"),
                        TextWithIcon(
                            text:
                                "تغییر و چاپ گروهی کالا ها بصورت درصدی یا مبلغ ثابت"),

                        TextWithIcon(text: "دسترسی به پنل تنظیمات"),
                        SizedBox(
                          height: 25,
                        ),
                        CustomTextField(
                          label: "لایسنس خریداری شده را اینجا وارد کنید",
                          validate: true,
                          maxLength: 50,
                          controller: licenseTextController,
                          extraValidate: (val) {
                            if ((Platform.isAndroid || Platform.isIOS )&& !val!.contains("pl-")) {
                              return "لایسنس وارد شده شناخته شده نیست";
                            }
                            if(Platform.isWindows && !val!.contains("plw-")){
                              return "لایسنس وارد شده شناخته شده نیست";
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        running
                            ? Center(
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(),
                              ))
                            : CustomButton(
                                text: "اعمال لایسنس",
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    running = true;
                                    setState(() {});
                                    await PayService.checkLicense(
                                        context, licenseTextController.text);
                                    running = false;
                                    setState(() {});
                                  }
                                }),
                        SizedBox(
                          height: 50,
                        ),

                        ///buy license button
                        Center(
                          child: CustomButton(
                            fontSize: 18,
                            width: 200,
                            radius: 20,
                            color: Colors.orange,
                            text: "خرید لایسنس",
                            onPressed: () {
                              urlLauncher(
                                context: context,
                                urlTarget:Platform.isWindows?"https://mlggrand.ir/product/pricelist-windows-license/"
                                    : "https://mlggrand.ir/product/%D9%84%D8%A7%DB%8C%D8%B3%D9%86%D8%B3-%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D9%84%DB%8C%D8%B3%D8%AA-%D9%82%DB%8C%D9%85%D8%AA/",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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
