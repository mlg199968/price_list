import 'package:flutter/material.dart';


const String uri = 'http://192.168.1.3:3000';




const String kCustomFont="persian";




const kBgColor=Colors.white70;
const kMainGradiant = LinearGradient(
  colors: [Colors.deepPurple, Colors.blueAccent],
);

// var kCardGradiant = const LinearGradient(
//   begin: Alignment.bottomLeft,
//   end: Alignment.topLeft,
//   stops: [0,0.5],
//   colors: [Colors.blueAccent, Colors.transparent],
// );
const kWhiteColor=Colors.white;
const kColor1=Colors.deepPurple;
const List<String> unitList=['عدد','متر','کیلو','متر مربع','متر مکعب','گرم','شاخه','بسته'];
const List<String> sortList=['تاریخ تسویه','حروف الفبا','تاریخ ثبت'];
const List<String> kCurrencyList=["ریال","تومان","دلار","لیر","درهم"];

const kSpaceBetween=20.0;

final kBoxDecoration=BoxDecoration(
  color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: Colors.blue));






///Text styles
const kHeaderStyle = TextStyle(
  fontWeight:FontWeight.bold,
  fontSize: 20,
  //color: Colors.white
);
const kCellStyle = TextStyle(
  fontSize: 14,
);
const kSmallText = TextStyle(
  fontSize: 12,
);


final kInputDecoration=InputDecoration(
  hintText: 'نام محصول',

  hintStyle: const TextStyle(color: kColorController,fontSize: 15,),
  contentPadding: const EdgeInsets.all(10),
  focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: kColorController)
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
  ),
);

final kButtonStyle=TextButtonThemeData(

  style: ButtonStyle(
    backgroundColor:
    MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.focused) ||
          states.contains(MaterialState.pressed)) {
        return kColorController;
      }
      if(states.contains(MaterialState.disabled)) {
        return kColorController.withOpacity(0.3);
      } else {
        return kColorController;
      }
    }),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),



  ),
);



const kGradiantColor1=LinearGradient(
  colors: [Color(0XFF4A00E0),Color(0XFF8E2DE2),],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
const kColorController=Color(0XFF4A00E0);
