import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:price_list/constants/global_task.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';





class LoadScreen extends StatefulWidget {
  static String id = 'loadingScreen';
  const LoadScreen({Key? key}) : super(key: key);

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {

  @override
  void didChangeDependencies() async{
    await GlobalTask().getStartUpData(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      Timer(const Duration(milliseconds: 900), () async{
       // await GlobalTask().getStartUpData(context);

        Navigator.of(context).pushReplacementNamed(
            WareListScreen.id);
      });
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
            child: Image.asset('assets/images/logo.png',width: 200,),
          ),
          Expanded(
            flex: 1,
            child: Image.asset('assets/images/mlggrand.png',width: 100,),
          ),
        ],
      ),
    );
  }
}
