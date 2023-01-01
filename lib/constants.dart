import 'package:flutter/material.dart';


const kTaskbarDecoration=BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0XFF4A00E0),Color(0XFF8E2DE2),],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.only(
      topLeft: Radius.circular(40.0),
      topRight: Radius.circular(40.0)),
);

const kHeaderStyle = TextStyle(
  fontWeight:FontWeight.bold,
  fontSize: 20,
  //color: Colors.white
);
const kCellStyle = TextStyle(
  fontSize: 20,
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

const List<String> myUnitList=['عدد','متر','کیلو','متر مربع','متر مکعب','گرم'];

const kGradiantColor1=LinearGradient(
  colors: [Color(0XFF4A00E0),Color(0XFF8E2DE2),],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
const kColorController=Color(0XFF4A00E0);
