import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/services/hive_boxes.dart';

import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../widgets/drop_list_field.dart';
import '../widgets/price_input_field.dart';
import '../widgets/switch_item.dart';

class CurrencyScreen extends StatefulWidget {
  static const String id = "/CurrencyScreen";

  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final usdController = TextEditingController();
  final tryController = TextEditingController();
  final aedController = TextEditingController();
  final cnyController = TextEditingController();
  final eurController = TextEditingController();
  late UserProvider provider;
  bool showCostPrice = false;
  bool showQuantity = false;
  String selectedCurrency = kCurrencyList[0];
  bool replacedCurrency=false;
  void storeInfoShop() {
    Map currencyValueMap = {
      "USD": stringToDouble(usdController.text),
      "TRY": stringToDouble(tryController.text),
      "AED": stringToDouble(aedController.text),
      "CNY": stringToDouble(cnyController.text),
      "EUR": stringToDouble(eurController.text),
      "IRR": 0.1,
    };
    Shop dbShop = HiveBoxes.getShopInfo().values.first.copyWith(
        showCost: showCostPrice,
        showQuantity: showQuantity,
        replacedCurrency:replacedCurrency,
        currency: selectedCurrency,
        currenciesValue: currencyValueMap);
    provider.getData(dbShop);
    HiveBoxes.getShopInfo().putAt(0, dbShop);
  }

  void getData() async {
    Shop shop=HiveBoxes.getShopInfo().values.first;
    showCostPrice = provider.showCostPrice;
    showQuantity = provider.showQuantity;
    selectedCurrency = provider.currency;
    replacedCurrency=shop.replacedCurrency ?? false;
    usdController.text=shop.currenciesValue?["USD"].toString() ?? "";
    tryController.text=shop.currenciesValue?["TRY"].toString() ?? "";
    aedController.text=shop.currenciesValue?["AED"].toString() ?? "";
    cnyController.text=shop.currenciesValue?["CNY"].toString() ?? "";
    eurController.text=shop.currenciesValue?["EUR"].toString() ?? "";
    setState(() {});
  }

  @override
  void initState() {
    provider = Provider.of<UserProvider>(context, listen: false);
    getData();
    super.initState();
  }


  @override
  void dispose() {
    storeInfoShop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("تنظیمات ارز"),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            padding: EdgeInsets.only(top: 80),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(gradient: kMainGradiant),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 450,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Gap(30),

                      ///currency unit
                      DropListItem(
                          title: "واحد ارز",
                          selectedValue: selectedCurrency,
                          listItem: kCurrencyList,
                          onChange: (val) {
                            selectedCurrency = val;
                            setState(() {});
                          }),
                      SwitchItem(
                        title: "نمایش قیمت ها به تومان",
                        value: replacedCurrency,
                        onChange: (val) {
                          replacedCurrency = val;
                          provider.updateSetting(showCostPrice, showQuantity,val);
                          setState(() {});
                        },
                      ),
                      SwitchItem(
                        title: "نمایش قیمت خرید",
                        value: showCostPrice,
                        onChange: (val) {
                          showCostPrice = val;
                          provider.updateSetting(val, showQuantity,replacedCurrency);
                          setState(() {});
                        },
                      ),
                      SwitchItem(
                        title: "نمایش موجودی",
                        value: showQuantity,
                        onChange: (val) {
                          showQuantity = val;
                          provider.updateSetting(showCostPrice, val,replacedCurrency);
                          setState(() {});
                        },
                      ),
                      const CText(
                        "ارزش ارز ها به تومان",
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                      ///usd
                      PriceInputItem(
                        controller: usdController,
                        label: "دلار به تومان",
                        inputLabel: "ارزش",
                      ),
                    ///try
                      PriceInputItem(
                        controller: tryController,
                        label: "لیر به تومان",
                        inputLabel: "ارزش",
                      ),
                    ///aed
                      PriceInputItem(
                        controller: aedController,
                        label: "درهم به تومان",
                        inputLabel: "ارزش",
                      ),
                    ///cny
                      PriceInputItem(
                        controller: cnyController,
                        label: "یوان به تومان",
                        inputLabel: "ارزش",
                      ),
                    ///eur
                      PriceInputItem(
                        controller: eurController,
                        label: "یورو به تومان",
                        inputLabel: "ارزش",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
