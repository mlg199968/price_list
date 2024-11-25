

import 'package:flutter/material.dart';

class PurchaseTools{

  static Map convertPlan(String id){

      if(id == "m1") {
        return {"title":"ماهانه","colors":[Colors.indigo,Colors.teal],"days":30};
      }
      if(id == "m3") {
        return {"title":"سه ماه","colors":[Colors.blueAccent,Colors.teal],"days":90};
      }
      else if(id == "m6"){
        return {"title":"شش ماهه","colors":[Colors.indigo, Colors.deepOrangeAccent],"days":180};
      }
      else if(id == "m12"){
        return {"title":"یک ساله","colors":[Colors.indigo, Colors.purple],"days":365};
      }
      else if(id == "free"){
        return {"title":"رایگان","colors":[Colors.green, Colors.teal],"days":10};
      }
      else if(id == "p1"){
        return {"title":"دائم","colors":[Colors.purpleAccent, Colors.deepPurple,],"days":1000};
      }
      else if(id == "3" || id == "1"){
        return {"title":"خرید قبل","colors":[Colors.deepOrange, Colors.orangeAccent,Colors.deepOrange],"days":400};
      }
      else if(id == "m0"){
        return {"title":"آزمایشی","colors":[Colors.grey, Colors.black54,Colors.black12],"days":0,"sec":100};
      }
      else {
        return {"title":"نامشخص","colors":[Colors.grey, Colors.blueGrey],"days":0};
      }
  }
}