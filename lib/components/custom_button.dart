import 'package:flutter/material.dart';
import 'package:price_list/constants/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height = 50,
    this.fontSize=15,
    this.radius=5,
  }) : super(key: key);
  final String text;

  // ignore: prefer_typing_uninitialized_variables
  final onPressed;
  final double? width;
  final double height;
  final Color? color;
  final double fontSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          elevation: MaterialStatePropertyAll(5),
          padding: MaterialStatePropertyAll(EdgeInsets.all(0))),
      onPressed: onPressed,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: color,
              gradient: color == null
                  ? kGradiantColor1
                  : LinearGradient(
                      colors: [color!, color!.withBlue(200)],
                    ),
              borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(blurRadius: 2,offset: Offset(1, 3),color: Colors.black26)
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style:  TextStyle(color: Colors.white, fontSize: fontSize),
          )),
    );
  }
}
