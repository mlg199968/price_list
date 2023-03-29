import 'dart:async';

import 'package:flutter/material.dart';
import 'package:price_list/screens/price_screen.dart';


class LoadScreen extends StatelessWidget {
  static String id = 'loadingScreen';
  const LoadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds:1300 ), () {
      Navigator.of(context).pushNamed(PriceScreen.id);
    });

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [Color(0XFF4A00E0),Color(0XFF8E2DE2),],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Image.asset('images/logo.png',width: 200,),
          ),
          Expanded(
            flex: 1,
            child: Image.asset('images/mlggrand.png',width: 100,),
          ),
        ],
      ),
    );
  }
}
