import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/consts_class.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:price_list/model/ware.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';



class BackupTools {
  BackupTools({this.quickBackup = false});
  final bool quickBackup;
  static const String _outPutName = "data-file.mlg";
  final String formattedDate =
  intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());
  String get zipFileName => quickBackup
      ? "$kAppName$formattedDate-database.plmlg"
      : "$kAppName$formattedDate-full.plmlg";
  ///
  static Future<String?> chooseDirectory() async {
    String? result = await FilePicker.platform
        .getDirectoryPath(dialogTitle: "انتخاب مکان ذخیره فایل پشتیبان");
    if(result!=null){
      return result;
    }else{
      return null;
    }
  }
  ///create backup
   Future<void> createBackup(BuildContext context,{List<Ware>? wareList,String? directory,bool isSharing=false}) async{
    List<Ware> wares =wareList ?? HiveBoxes.getWares().values.toList();
   List wareListJson=wares.map((e) => e.toJson()).toList();
    try {
      if(directory!=null && directory!="") {
        await createZipFile(
            await Address.waresImage(), jsonEncode(wareListJson), context,
            directory: directory,isSharing: isSharing);
      }else{
        showSnackBar(context, "مسیر ذخیره سازی انتخاب نشده است!",type: SnackType.warning);
      }
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(context, e,stacktrace: stacktrace,
          title: "BackupTools - createBackup error", showSnackbar: true);
    }
  }
///this triggered when just json file uploaded
  static Future<void> restoreMlgFileBackup(context,String filePath) async {
    try {
        File backupFile = File(filePath);
        String jsonFile = await backupFile.readAsString();
        Iterable l = json.decode(jsonFile);
        List<Ware> restoredDb = List<Ware>.from(
            l.map((e) => Ware().fromJson(e)));
        for (Ware ware in restoredDb) {
          HiveBoxes.getWares().put(ware.wareID, ware);
        }
        Provider.of<WareProvider>(context,listen: false).loadGroupList();
          showSnackBar(context, "فایل پشتیبان با موفقیت بارگیری شد !",type: SnackType.success);


    }catch(e,stacktrace){
ErrorHandler.errorManger(
    context,
    e,
    stacktrace: stacktrace,
    title: "BackupTools restoreMlgFileBackup function error",showSnackbar: true);
    }
  }

  ///read zip file
   readZipFile(context) async {
    try {
      await Address.waresImage();
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        String directory = (await getApplicationDocumentsDirectory()).path;
        //read backup and convert
        String path = result.files.single.path!;
        //condition for which type backup is being read
        if(path.contains(".zip") || path.contains(".plmlg")) {
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
        updateImagePath();
      }
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(
          context,
          e,
          stacktrace: stacktrace,
          title: "BackupTools - readZipFile error", showSnackbar: true);
    }
  }
///create zip backup
   createZipFile(String imagesDir, String json, context,{required String directory,bool isSharing=false}) async {
    try {
        // Zip a directory to out.zip using the zipDirectory convenience method
        var encoder = ZipFileEncoder();
        // Manually create a zip of a directory and individual files.
      final String path='$directory/$zipFileName';
        encoder.create(path);
        if(quickBackup==false) {
        encoder.addDirectory(Directory(imagesDir));
      }
      File jsonFile = await _createJsonFile(json, directory);
        encoder.addFile(jsonFile);
        encoder.close();
        await jsonFile.delete(recursive: true);
        if(isSharing==false) {
        showSnackBar(context, "فایل پشتیبان با موفقیت ذخیره شد !",
            type: SnackType.success);
      }else{
          await Share.shareXFiles([XFile(path)]);
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
      List<Ware> restoredDb = List<Ware>.from(
          l.map((e) => Ware().fromJson(e)));


      for (Ware ware in restoredDb) {
        HiveBoxes.getWares().put(ware.wareID, ware);
      }
      Provider.of<WareProvider>(context,listen: false).loadGroupList();
      showSnackBar(context, "فایل پشتیبان با موفقیت بارگیری شد !",
          type: SnackType.success);
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(
          context,
          e,
          stacktrace: stacktrace,
          title: "BackupTools - restoreJsonData error", showSnackbar: true);
    }
  }
  ///
  static Future<void> updateImagePath2()async{
    String directoryPath=await Address.waresImage();
    List<Ware> itemsList=HiveBoxes.getWares().values.toList();
    for (int i = 0; i < itemsList.length; i++) {
      String id=itemsList[i].wareID!;
      String imagePath="$directoryPath/$id.jpg";
      if(await File(imagePath).exists()) {
        itemsList[i].imagePath=imagePath;
      }else{
        itemsList[i].imagePath=null;
      }
      HiveBoxes.getWares()
          .put(id,itemsList[i]);
    }

  }
 ///
   Future<void> updateImagePath()async{
    String directoryPath=await Address.waresImage();
    List<Ware> itemsList=HiveBoxes.getWares().values.toList();
    for (int i = 0; i < itemsList.length; i++) {
      //
      if(itemsList[i].imagePath!=null){
        String imgName = _extractFileName(itemsList[i].imagePath!);
        itemsList[i].imagePath="$directoryPath/$imgName";
        if(!(await File(itemsList[i].imagePath!).exists())) {
          itemsList[i].imagePath=null;
        }
      }
      //
      if(itemsList[i].images!=null &&itemsList[i].images!.isNotEmpty ){
        for(int j=0;itemsList[i].images!.length>j;j++) {
          String img=itemsList[i].images![j];
          String imgName = _extractFileName(img);
          itemsList[i].images![j] = "$directoryPath/$imgName";
          if(!(await File(itemsList[i].images![j]).exists())) {
            itemsList[i].images!.removeAt(j);  }
        }
      }
      String id=itemsList[i].wareID!;
      HiveBoxes.getWares()
          .put(id,itemsList[i]);
    }

  }
  ///
  String _extractFileName(String text) {
    List<String> parts = [];
    String currentPart = "";
    for (int i = 0; i < text.length; i++) {
      if (text[i] == '/' || text[i] == '\\') {
        parts.add(currentPart);
        currentPart = "";
      } else {
        currentPart += text[i];
      }
    }
    if (currentPart.isNotEmpty) {
      parts.add(currentPart);
    }
    return parts.last;
  }
  // static Future<void> _saveJson(String json,BuildContext context) async {
  //   String formattedDate= intl.DateFormat('yyyyMMdd-kkmmss').format(DateTime.now());
  //
  //   String? result = await FilePicker.platform.getDirectoryPath();
  //   if (result != null) {
  //     String path = result;
  //     File createdFile =
  //     File("$path/$formattedDate.json");
  //     createdFile.create(recursive: true);
  //     createdFile.writeAsString(json);
  //
  //     if(context.mounted) {
  //       showSnackBar(context, "فایل پشتیبان با موفقیت ذخیره شد !",type: SnackType.success);
  //     }
  //
  //   }
  // }
}

