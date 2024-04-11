import 'package:flutter/material.dart';



const String kAppName="price-list";
const String uri = 'http://192.168.1.3:3000';
const String hostUrl = "https://mlggrand.ir/db";

const String kCustomFont = "persian";

const kBgColor = Colors.white70;
const kSecondaryGradiant = LinearGradient(
  colors: [Colors.deepPurple, Colors.blueAccent],
);
const kMainGradiant = LinearGradient(
  colors: [
    Color(0XFF4A00E0),
    Color(0XFF8E2DE2),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
const kColorController = Color(0XFF4A00E0);

const kBlackWhiteGradiant = LinearGradient(colors: [
  Color(0XFFffffff),
  Color(0XFFE0E4E4),
  Color(0XFFffffff),
  Color(0XFFE0E0E0)
], begin: Alignment.topRight, end: Alignment.bottomLeft);
const kMainColor = Colors.indigo;
const kSecondaryColor = Colors.teal;

const kMainDisableColor = Colors.orangeAccent;
const kMainActiveColor = Colors.deepOrange;
const kMainColor2 = Colors.black38;
const kMainColor3 = Colors.black87;

// var kCardGradiant = const LinearGradient(
//   begin: Alignment.bottomLeft,
//   end: Alignment.topLeft,
//   stops: [0,0.5],
//   colors: [Colors.blueAccent, Colors.transparent],
// );
const kWhiteColor = Colors.white;
const kColor1 = Colors.deepPurple;
const List<String> kUnitList = [
  'عدد',
  'متر',
  'کیلو گرم',
  'متر مربع',
  'متر مکعب',
  'گرم',
  'شاخه',
  'بسته',
  'دسته',
  'گیگ',
  'مگ',
  'شل',
  'میلی متر',
  'پک',
];
const List<String> kSortList = ['تاریخ تسویه', 'حروف الفبا', 'تاریخ ثبت'];
const List<String> kCurrencyList = ["ریال", "تومان", "دلار", "لیر", "درهم"];
const List<String> kFonts = [
  'Shabnam',
  'Sahel',
  'Mitra',
  'Koodak',
  'Roya',
  'Terafik',
  'Elham',
  'Titr'
];
const List kPrintTypeList = ['کاستوم','ساده', 'اتیکت','کاتالوگ'];

const kSpaceBetween = 20.0;

final kBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: Colors.blue));
const BoxShadow kShadow= BoxShadow(
    blurRadius: 5, offset: Offset(1, 2), color: Colors.black54);
///Text styles
const kHeaderStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  //color: Colors.white
);
const kCellStyle = TextStyle(
  fontSize: 14,
);
const kSmallText = TextStyle(
  fontSize: 12,
);

final kInputDecoration = InputDecoration(
  hintText: 'نام محصول',
  hintStyle: const TextStyle(
    color: kColorController,
    fontSize: 15,
  ),
  contentPadding: const EdgeInsets.all(10),
  focusedBorder:
      const OutlineInputBorder(borderSide: BorderSide(color: kColorController)),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
  ),
);

final kButtonStyle = TextButtonThemeData(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return kColorController;
      }
      if (states.contains(WidgetState.disabled)) {
        return kColorController.withOpacity(0.3);
      } else {
        return kColorController;
      }
    }),
    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
  ),
);

