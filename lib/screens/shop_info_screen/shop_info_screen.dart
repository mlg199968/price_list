import 'dart:io';
import 'package:flutter/material.dart';
import 'package:price_list/components/custom_float_action_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/components/image_picker_holder.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class ShopInfoScreen extends StatefulWidget {
  static const String id = "/ShopInfoScreen";
  const ShopInfoScreen({super.key});

  @override
  State<ShopInfoScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<ShopInfoScreen> {
  TextEditingController shopNameController = TextEditingController();
  TextEditingController shopCodeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController phoneNumberController2 = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? logoImage;
  File? stampImage;
  File? signatureImage;


void storeInfoShop(){
  Shop? shop=HiveBoxes.getShopInfo().get(0);
  if(shop!=null){
    shop
      ..shopName=shopNameController.text
      ..shopCode=shopCodeController.text
      ..address=addressController.text
      ..phoneNumber=phoneNumberController.text
      ..phoneNumber2=phoneNumberController2.text
      ..description=descriptionController.text
      ..logoImage=logoImage==null?null:logoImage!.path;
  }else {
    shop=Shop()
      ..shopName=shopNameController.text
      ..shopCode=shopCodeController.text
      ..address=addressController.text
      ..phoneNumber=phoneNumberController.text
      ..phoneNumber2=phoneNumberController2.text
      ..description=descriptionController.text
      ..signatureImage=signatureImage==null?null:signatureImage!.path
      ..stampImage=stampImage==null?null:stampImage!.path
      ..logoImage=logoImage==null?null:logoImage!.path;
  }
  Provider.of<UserProvider>(context,listen: false).getData(shop);
       HiveBoxes.getShopInfo().put(0,shop);
}

void getData(){
  Shop? shopInfo=HiveBoxes.getShopInfo().get(0);
  if(shopInfo!=null){
   shopNameController.text= shopInfo.shopName;
   shopCodeController.text= shopInfo.shopCode;
    addressController.text=shopInfo.address;
    phoneNumberController.text=shopInfo.phoneNumber;
    phoneNumberController2.text=shopInfo.phoneNumber2;
    descriptionController.text=shopInfo.description;
    logoImage=shopInfo.logoImage==null?null:File(shopInfo.logoImage!);
  }
}
@override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    shopNameController.dispose();
    shopCodeController.dispose();
    phoneNumberController.dispose();
    phoneNumberController2.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileSize=screenType(context)==ScreenType.mobile;
    return HideKeyboard(
      child: Scaffold(
        floatingActionButtonLocation:isMobileSize ?null: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustomFloatActionButton(
          label: "ذخیره",
            icon:Icons.check_rounded,
            onPressed: (){
          storeInfoShop();
          setState(() {});
          Navigator.of(context).pop();
        }),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("اطلاعات شرکت/فروشگاه"),
        ),
        body: Container(
          padding:isMobileSize?EdgeInsets.all(5).copyWith(top: 60):EdgeInsets.all(20).copyWith(top: 60),
          alignment: Alignment.center,
          decoration: BoxDecoration(gradient: kMainGradiant),
          child: SingleChildScrollView(
            child: Container(
              width: 550,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: kBlackWhiteGradiant,
                borderRadius: BorderRadius.circular(20),

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  ///Choose shop logo part
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ImagePickerHolder(
                      text: "انتخاب لوگو",
                      icon: Icons.add_photo_alternate_outlined,
                      imageFile: logoImage,
                      onPress: () async {
                        //for replace the image with another image we need to give null value first then choose another image.
                        logoImage = null;
                        setState(() {});
                        logoImage = await pickFile("shop_logo.png");
                        setState(() {});
                      },
                      onDelete: (){logoImage = null;
                      setState(() {});},
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  /// Name Inputs
                  CustomTextField(
                      maxLength: 35,
                      label: "نام فروشگاه",
                      controller: shopNameController),

                  const SizedBox(
                    height: 20,
                  ),
                  /// Name Inputs
                  CustomTextField(
                      maxLength: 35,
                      label: "کد فروشگاه",
                      controller: shopCodeController),

                  const SizedBox(
                    height: 20,
                  ),

                  ///phones number part
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                          textFormat: TextFormatter.number,
                          maxLength: 15,
                          label: "شماره تلفن",
                          controller: phoneNumberController),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                          textFormat: TextFormatter.number,
                          maxLength: 15,
                          label: "شماره تلفن دوم",
                          controller: phoneNumberController2),
                    ],
                  ),
                  const SizedBox(
                    height: 10 ,
                  ),
                  CustomTextField(
                      maxLine: 2,
                      maxLength: 120,
                      label: "آدرس",
                      controller: addressController),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    label: "توضیحات",
                    controller: descriptionController,
                    maxLine: 4,
                    maxLength: 120,
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


