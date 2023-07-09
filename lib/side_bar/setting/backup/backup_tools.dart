import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:price_list/constants/utils.dart';
import 'package:price_list/data/hive_boxes.dart';
import 'package:price_list/model/ware_hive.dart';


class BackupTools {


  static Future<void> createBackup(BuildContext context) async{
    List<WareHive> wares = HiveBoxes.getWares().values.toList();
   List ware=wares.map((e) => e.toJson()).toList();


    await _saveJson(jsonEncode(ware),context);
  }

  static Future<void> restoreBackup(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        File backupFile = File(result.files.single.path!);
        String jsonFile = await backupFile.readAsString();
        Iterable l = json.decode(jsonFile);
        List<WareHive> restoredDb = List<WareHive>.from(
            l.map((e) => WareHive().fromJson(e)));


        for (int i = 0; i < restoredDb.length; i++) {
          HiveBoxes.getWares().put(restoredDb[i].wareID, restoredDb[i]);
        }
        if(context.mounted) {
          showSnackBar(context, "فایل پشتیبان با موفقیت بارگیری شد !",type: SnackType.success);
        }
      }

    }catch(e){
      print(e.toString());
      if(context.mounted) {

        showSnackBar(context, e.toString(),type: SnackType.error);
      }
    }
  }


  static Future<void> _saveJson(String json,BuildContext context) async {
    String formattedDate= intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());

    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      String path = result;
      File createdFile =
      File("$path/$formattedDate.json");
      createdFile.create(recursive: true);
      createdFile.writeAsString(json);

      if(context.mounted) {
        showSnackBar(context, "فایل پشتیبان با موفقیت ذخیره شد !",type: SnackType.success);
      }

    }
  }
}

