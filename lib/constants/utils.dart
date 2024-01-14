import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/shape/shape02.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:url_launcher/url_launcher.dart';




///Show snake bar in active context
void showSnackBar(BuildContext context, String title,
    {SnackType type=SnackType.normal,double? height}) {
  Color? color;
  switch(type){
    case SnackType.normal:
      color=Colors.blue;
      break;
    case SnackType.success:
      color=Colors.green;
      break;
    case SnackType.error:
      color=Colors.red;
      break;
    case SnackType.warning:
      color=Colors.orange;
      break;

  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        showCloseIcon: true,
        width: 350,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.transparent,
        content: BlurryContainer(
          padding: const EdgeInsets.all(0),
          height:height ?? 50,
          color: Colors.black.withOpacity(.8),
          borderRadius: BorderRadius.circular(20),
          child: BackgroundShape2(
            color: color ,
            height: height ?? 50,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(title.toPersianDigit(),style: const TextStyle(fontFamily: kCustomFont,color: Colors.white),textDirection: TextDirection.rtl,),
            ),
          ),
        )),
  );
}

// ///Show snake bar in active context
// void showSnackBar(BuildContext context, String text) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(text),
//     ),
//   );
// }

///Show snake bar in active context
Divider customDivider({required BuildContext context, Color? color}) {
  double indent = MediaQuery.of(context).size.width / 7;
  return Divider(
    thickness: 1,
    height: 20,
    indent: indent,
    endIndent: indent,
    color: color ?? Colors.black12,
  );
}

///convert string to double
double stringToDouble(String text) {
  String englishText = text.toEnglishDigit();

  return double.parse(englishText.replaceAll(RegExp(r'[^0-9.-]'), ''))
      .toDouble();
}

///add separator for show price number and persian number
String addSeparator(num number) {
  return intl.NumberFormat('###,###,###,###').format(number).toPersianDigit();
}

/// for launch urls
Future<void> urlLauncher({required context, required String urlTarget}) async {
  Uri url = Uri.parse(urlTarget);
  if (!await launchUrl(url,mode: LaunchMode.externalApplication)) {
    showSnackBar(context, "Could not open this url!",
        type: SnackType.error);
  }
}

///choose directory
Future<String?> chooseDirectory() async {
  String? result = await FilePicker.platform.getDirectoryPath();

  if (result != null) {
    //print(File(result).path);
    // File backupFile = File(result);
    return result;
  }
  return null;
}




/// condition for pick image from device storage
Future<File?> pickFile(String imageName) async {
    int imageIndex=0;
  final Directory directory = await getApplicationDocumentsDirectory();
  final newDirectory = Directory("${directory.path}/cache/images");
  File? copyFile;
  try {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      //here we create new path for cache images and condition check if directory not exist,create directory
      if (!await newDirectory.exists()) {
        newDirectory.create(recursive: true);
      }
      if(!await File("${newDirectory.path}/0 $imageName").exists()){
        copyFile = await File(pickedFile.files.single.path!)
            .copy("${newDirectory.path}/$imageIndex $imageName");
        imageIndex++;
        copyFile = await File(pickedFile.files.single.path!)
            .copy("${newDirectory.path}/$imageIndex $imageName");
      }else {
        imageIndex++;
        while (!await File("${newDirectory.path}/$imageIndex $imageName")
                .exists() &&
            imageIndex < 1000) {
          imageIndex++;
        }
       await File("${newDirectory.path}/$imageIndex $imageName").delete(recursive: true);
        imageIndex++;
        copyFile = await File(pickedFile.files.single.path!)
            .copy("${newDirectory.path}/$imageIndex $imageName");
      }
      //delete cache file
      Directory(pickedFile.files.single.path!).delete(recursive: true);
      return copyFile;
    }
  } catch (e) {
    debugPrint('file picker error:::::: $e');
  }
  // if(await File("${newDirectory.path}/$imageName").exists()){
  //   copyFile=File("${newDirectory.path}/$imageName");
  // }
  return copyFile;
}

/// find max date in the date list
DateTime findMaxDate(List<DateTime> dateList) {
  DateTime maxDate = dateList[0];
  for (int i = 1; i < dateList.length; i++) {
    if (maxDate.isBefore(dateList[i])) {
      maxDate = dateList[i];
    }
  }
  return maxDate;
}

DateTime findMinDate(List<DateTime> dateList) {
  DateTime minDate = dateList[0];
  for (int i = 1; i < dateList.length; i++) {
    if (minDate.isAfter(dateList[i])) {
      minDate = dateList[i];
    }
  }
  return minDate;
}
