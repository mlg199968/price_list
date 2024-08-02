import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/global_task.dart';
import 'package:price_list/screens/ware_list/ware_list_screen.dart';





class SplashScreen extends StatefulWidget {
  static const String id = 'loadingScreen';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void didChangeDependencies() async{
    // await GlobalTask().getInitData(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      Timer(const Duration(milliseconds: 900), () async{
        BuildContext currentContext=GlobalTask.navigatorState.currentContext!;
        await GlobalTask().getInitData(currentContext);
        Navigator.of(currentContext).pushNamedAndRemoveUntil(
            WareListScreen.id,(currentContext)=>false);
      });
    });
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
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
            FutureBuilder(
              future:PackageInfo.fromPlatform() ,
              builder: (context,futureInfo) {
                String appVersion=(futureInfo.data?.version ??"");
                String appName=(futureInfo.data?.appName ??"");
                return Text("$appName $appVersion",style: TextStyle(color: Colors.white70,fontSize: 15,shadows: [kShadow]),);
              }
            ),
            SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
