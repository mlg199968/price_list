import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBackground extends StatelessWidget {
  const GlassBackground({Key? key,required this.child}) : super(key: key);
final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child:child,
        ),
      ),
    );
  }
}
