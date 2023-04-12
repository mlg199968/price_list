import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:price_list/data/hive_boxes.dart';
import 'package:price_list/model/ware_hive.dart';


class BackupTools {


  static Future<void> createBackup() async{
    List<WareHive> wares = HiveBoxes.getWares().values.toList();
   List ware=wares.map((e) => e.toJson()).toList();


    await _saveJson(jsonEncode(ware));
  }

  static Future<void> restoreBackup() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File backupFile = File(result.files.single.path!);
      String jsonFile = await backupFile.readAsString();
    Iterable l=json.decode(jsonFile);
      List<WareHive> restoredDb =List<WareHive>.from(l.map((e) => WareHive().fromJson(e)));



      for(int i=0;i<restoredDb.length;i++) {
        HiveBoxes.getWares().put(restoredDb[i].wareID,restoredDb[i]);
      }
    }
  }


  static Future<void> _saveJson(String json) async {
    String formattedDate= intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());

    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      String path = result;
      File createdFile =
      File("$path/$formattedDate.json");
      createdFile.create(recursive: true);
      createdFile.writeAsString(json);

    }
  }
}

