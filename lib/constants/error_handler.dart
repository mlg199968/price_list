import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/providers/user_provider.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:price_list/model/bug.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart' as intl;

import '../model/device.dart';

class ErrorHandler {
  final String formattedDate =
  intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());
   String get  outPutName => "$kAppName-$formattedDate-errors.json";
  ///error catch manager
  static errorManger(BuildContext? context, var errorObject,
      {String? title,var stacktrace, String? errorText, String? route,bool showSnackbar=false}) {
    String? routeDir=context!=null ?ModalRoute.of(context)?.settings.name:null;
    debugPrint("title: $title");
    debugPrint("error route :${route ?? routeDir }");
    debugPrint("error content :${errorText ?? errorObject.toString()}");
    debugPrint("stacktrace :$stacktrace");

    Bug bug = Bug()
      ..title = title
      ..errorText = errorText ?? errorObject.toString()
      ..directory = routeDir
      ..bugDate=DateTime.now()
      ..stacktrace=stacktrace?.toString()
      ..bugId = const Uuid().v1();
    HiveBoxes.getBugs().put(bug.bugId, bug);
    if(showSnackbar && title!=null && context!=null) {
      showSnackBar(context, title,type: SnackType.error);
    }
  }
  ///
  shareErrors(BuildContext context)async{
    File errorsFile = await _createErrorFile(context);
    if(Platform.isAndroid || Platform.isIOS) {
      await Share.shareXFiles([XFile(errorsFile.path)]);
    }
    else{
      String? directory=await chooseDirectory();
      if(directory!=null){
        print(directory);
        await errorsFile.copy("$directory\\$outPutName");
      }
    }
  }

    ///save error list
    Future<File> _createErrorFile(BuildContext context) async {
      Device device = await getDeviceInfo();
      String appVersion =
          Provider.of<UserProvider>(context, listen: false).appVersion;
      final Directory directory = await getApplicationDocumentsDirectory();
      List<Map> bugList =
          HiveBoxes.getBugs().values.map((e) => e.toMap()).toList();
      Map finalFile = {
        "appVersion": appVersion,
        "device": device.toMap(),
        "bugList": bugList
      };
      File createdFile = File("${directory.path}/$outPutName");
      print("createdFile.path");
      print(createdFile.path);
      await createdFile.create(recursive: true);
      await createdFile.writeAsString(jsonEncode(finalFile));

      return createdFile;
    }
}
