import 'package:flutter/material.dart';
import 'package:price_list/constants/constants.dart';

class CustomFloatActionButton extends StatelessWidget {
  const CustomFloatActionButton(
      {super.key,
        required this.onPressed,
        this.icon,
        this.bgColor=kSecondaryColor,
        this.fgColor=Colors.white,
        this.label, this.iconSize});

  final IconData? icon;
  final double? iconSize;
  final String? label;
  final Color? bgColor;
  final Color? fgColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: label==null?null:50,
      width: label==null?60:null,
      child: FloatingActionButton.extended(
        key: key,
        label:Text(label ?? "",style: const TextStyle(fontSize: 20),),
        icon:  Icon(
          icon ?? Icons.add_rounded,
          size: iconSize ?? 45,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        isExtended: label==null?false:true,
        elevation: 4,
        onPressed: onPressed,
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

class CustomFabLoc extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      scaffoldGeometry.scaffoldSize.width * .8,

      ///customize here
      scaffoldGeometry.scaffoldSize.height * .83,
    );
  }
}

