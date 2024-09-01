import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/action_button.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({super.key,
    this.onYes,
    this.onNo,
    this.extraContent,
    required this.title,});
  final String title;
  final VoidCallback? onYes;
  final VoidCallback? onNo;
  final Widget? extraContent;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      iconPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.black,
      scrollable: true,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///close icon button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.multiply_square_fill,
                color: Colors.red,
                size: 30,
                shadows: [BoxShadow(blurRadius: 1,offset:Offset(.2, .4),color: Colors.black54)],
              ),
            ),
          ),
          ///title part
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: const TextStyle(color: Colors.black87,fontSize: 14,),
              textDirection: TextDirection.rtl,
            ),
          ),
          /// extra widget if need something extra
          SizedBox(
            child: extraContent,
          ),
          ///yes and no buttons part
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(8),
                height: 70,
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ActionButton(
                      bgColor: Colors.black87,
                      borderRadius: 5,
                      icon: Icons.done,
                      iconColor: Colors.teal,
                      borderColor: Colors.teal,
                      onPress: onYes,
                      label: 'بله',
                    ),
                    const SizedBox(width: 5,),
                    ActionButton(
                      bgColor: Colors.black87,
                      icon: Icons.close,
                      iconColor: Colors.red,
                      borderColor: Colors.red,
                      borderRadius: 5,
                      onPress: onNo ?? (){Navigator.pop(context,false);}, // this line dismisses the dialog
                      label: 'خیر',
                    )
                  ],)),
          ),
        ],
      ),
    );
  }
}
