import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:price_list/constants/consts_class.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:price_list/model/ware_hive.dart';


class BackupTools {
  static const String _outPutName = "data-file.mlg";

  static Future<void> createBackup(BuildContext context) async{
    List<WareHive> wares = HiveBoxes.getWares().values.toList();
   List wareListJson=wares.map((e) => e.toJson()).toList();
    try {

      // await _saveJson(database.toJson(),context);
      await createZipFile(
          await Address.waresImage(),jsonEncode(wareListJson), context);
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackupTools - createBackup error", showSnackbar: true);
    }
  }

  static Future<void> restoreMlgFileBackup(context,String filePath) async {
    try {
        File backupFile = File(filePath);
        String jsonFile = await backupFile.readAsString();
        Iterable l = json.decode(jsonFile);
        List<WareHive> restoredDb = List<WareHive>.from(
            l.map((e) => WareHive().fromJson(e)));

        for (int i = 0; i < restoredDb.length; i++) {
          HiveBoxes.getWares().put(restoredDb[i].wareID, restoredDb[i]);
        }
          showSnackBar(context, "فایل پشتیبان با موفقیت بارگیری شد !",type: SnackType.success);


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
  ///read zip file
  static readZipFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String directory = (await getApplicationDocumentsDirectory()).path;
        //read backup and convert
        String path = result.files.single.path!;
        //condition for which type backup is being read
        if(path.contains(".zip")) {
          final bytes = File(path).readAsBytesSync();
          // Decode the Zip file
          final archive = ZipDecoder().decodeBytes(bytes);
          // Extract the contents of the Zip archive to disk.
          for (final file in archive) {
            final filename = file.name;
            if (file.isFile) {
              final data = file.content as List<int>;
              File extractedFile = File('$directory/$filename')
                ..createSync(recursive: true)
                ..writeAsBytesSync(data);
              if (filename == _outPutName) {
                await _restoreJsonData(extractedFile, context);
              } else {
                String imagesPath = await Address.waresDirectory();
                await extractedFile.copy("$imagesPath/$filename");
              }
            } else {
              await Directory('$directory/$filename').create(recursive: true);
            }
          }
        }
        //if backup file is just json file this function running
        else if(path.contains(".mlg") || path.contains(".json")){
          restoreMlgFileBackup(context, path);
          //if file type is not .zip or .mlg or .json ,this message being shown
        }else{
          showSnackBar(context, "فایل ناشناخته است",type: SnackType.error);
        }
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackupTools - readZipFile error", showSnackbar: true);
    }
  }
///create zip backup
  static createZipFile(String imagesDir, String json, context) async {
    try {
      String formattedDate =
      intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());
      //select a directory to save zip file
      String? result = await FilePicker.platform
          .getDirectoryPath(dialogTitle: "انتخاب مکان ذخیره فایل پشتیبان");
      if (result != null) {
        // Zip a directory to out.zip using the zipDirectory convenience method
        var encoder = ZipFileEncoder();
        // encoder.zipDirectory(Directory(result),
        //     filename: 'hitop-cafe$formattedDate.zip');

        // Manually create a zip of a directory and individual files.
        encoder.create('$result/price_list$formattedDate.zip');
        encoder.addDirectory(Directory(imagesDir));
        File jsonFile = await _createJsonFile(json, result);
        encoder.addFile(jsonFile);
        encoder.close();
        await jsonFile.delete(recursive: true);
        showSnackBar(context, "فایل پشتیبان با موفقیت ذخیره شد !",
            type: SnackType.success);
      }
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackupTools - createZipFile error", showSnackbar: true);
    }
  }
  /// create json file in directory to copy it in the zip file
  static Future<File> _createJsonFile(String json, String path) async {
    File createdFile = File("$path/$_outPutName");
    await createdFile.create(recursive: true);
    await createdFile.writeAsString(json);
    return createdFile;
  }
  ///read json file in the zip file
  static Future<void> _restoreJsonData(File jsonBack, context) async {
    try {
      String jsonFile = await jsonBack.readAsString();
      Iterable l = json.decode(jsonFile);
      List<WareHive> restoredDb = List<WareHive>.from(
          l.map((e) => WareHive().fromJson(e)));


      for (int i = 0; i < restoredDb.length; i++) {
        HiveBoxes.getWares().put(restoredDb[i].wareID, restoredDb[i]);
      }
      showSnackBar(context, "فایل پشتیبان با موفقیت بارگیری شد !",
          type: SnackType.success);
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "BackupTools - restoreJsonData error", showSnackbar: true);
    }
  }
}

