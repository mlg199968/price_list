import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/pay_services/pay_service.dart';

class PurchaseScreen extends StatelessWidget {
  static const String id = "/purchaseScreen";

  PurchaseScreen({super.key});

  final licenseTextController = TextEditingController();
  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * .8,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 25).copyWith(top: 60),
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: kMainGradiant),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //circle crown

                          SizedBox(
                            height: 100,
                          ),

                          Center(
                              //price
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "13,000".toPersianDigit(),
                                style:
                                    TextStyle(color: Colors.yellow, fontSize: 35),
                              ),
                              Text(
                                "تومان",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          )),
                          SizedBox(height: 50),
                          Center(
                              child: Text(
                            "قابلیت های نسخه حرفه ای :",
                            style: TextStyle(color: Colors.yellow, fontSize: 17),
                          )),
                          SizedBox(height: 20),
                          TextWithIcon(
                              text:
                                  "امکان گرفتن خروجی پی دی اف کالا های انتخابی"),
                          TextWithIcon(
                              text:
                                  "تغییر و چاپ گروهی کالا ها بصورت درصدی یا مبلغ ثابت"),

                          TextWithIcon(text: "شخصی سازی نمایش فیلد ها"),
                          SizedBox(
                            height: 25,
                          ),
                          CustomTextField(
                            label: "لایسنس خریداری شده را اینجا وارد کنید",
                            validate: true,
                            maxLength: 50,
                            controller: licenseTextController,
                            width: double.maxFinite,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomButton(
                              text: "اعمال لایسنس",
                              onPressed: () {
                                if(formKey.currentState!.validate()) {
                                  PayService.checkLicense(
                                      context, licenseTextController.text);
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
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
                  child: Icon(
                    FontAwesomeIcons.crown,
                    size: 80,
                    color: Colors.yellow,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellow.shade600),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.deepOrange),
                    ),
                    child: Text(
                      "خرید",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      urlLauncher(
                        context: context,
                        urlTarget: "https://mlggrand.ir/product/%D9%84%D8%A7%DB%8C%D8%B3%D9%86%D8%B3-%D8%A8%D8%B1%D9%86%D8%A7%D9%85%D9%87-%D9%84%DB%8C%D8%B3%D8%AA-%D9%82%DB%8C%D9%85%D8%AA/",
                      );
                    },
                  ),
                ),
              ),
            ],
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
          ),
          SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: 17, color: Colors.white),
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
