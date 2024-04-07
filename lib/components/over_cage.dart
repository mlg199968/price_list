import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_text.dart';

class OverCage extends StatelessWidget {
  const OverCage({super.key,this.child, this.count, this.active=false});
  final Widget? child;
  final int? count;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(active)
        CircleAvatar(

          minRadius: 5,
          maxRadius: 7,
          backgroundColor: Colors.red,
          child:count==null?null: CText(count.toString().toPersianDigit(),fontSize: 10,),
        ),
        if(child!=null)
        child!
      ],
    );
  }
}
