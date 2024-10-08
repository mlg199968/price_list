import 'dart:io';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gap/gap.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/shape/shape02.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/screens/purchase_screen/bazaar_purchase_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/device.dart';
import 'global_task.dart';


/// find out Screen size and return it
ScreenType screenType(BuildContext context){
  late ScreenType screenType;
  if(MediaQuery.of(context).size.width<500){
    screenType=ScreenType.mobile;
  }else if(MediaQuery.of(context).size.width>500 && MediaQuery.of(context).size.width<1000){
    screenType=ScreenType.tablet;
  }else{
    screenType=ScreenType.desktop;
  }
  return screenType;
}

///Show snake bar in active context
void showSnackBar(BuildContext? context, String title,
    {SnackType type=SnackType.normal,double? height,bool dialogMode=false}) {
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
  if(!dialogMode) {
    ScaffoldMessenger.of(context ?? GlobalTask.navigatorState.currentContext!).showSnackBar(SnackBar(
        showCloseIcon: true,
        width: 350,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: Colors.transparent,
        content: BlurryContainer(
          padding: const EdgeInsets.all(0),
          height: height ?? 50,
          color: Colors.black.withOpacity(.8),
          borderRadius: BorderRadius.circular(20),
          child: BackgroundShape2(
            color: color,
            height: height ?? 50,
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title.toPersianDigit(),
                style: const TextStyle(
                    fontFamily: kCustomFont, color: Colors.white),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
        )));
  }
  else {
    showDialog(
        context: context ?? GlobalTask.navigatorState.currentContext!,
        builder: (context) => Dialog(
          child: Container(
            width: 300,
            height: 200,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                gradient: kMainGradiant,
                borderRadius: BorderRadius.circular(10)),
            child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orangeAccent)),
                child: Column(
                  children: [
                    const Align(
                        alignment: Alignment.centerRight,
                        child: CrownIcon(size: 40,)),
                    const Gap(10),
                    CText(title,color: Colors.white,),
                  ],
                )),
          ),
        ));
  }
}

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
  if(text!="") {
    String englishText = text.toEnglishDigit();

    return double.parse(englishText.replaceAll(RegExp(r'[^0-9.-]'), ''))
        .toDouble();
  }
  else{
    return 0;
  }
}

///add separator for show price number and persian number
String addSeparator(num number, {bool decimals = false}) {
  final numberFormatter =intl.NumberFormat('#,##0.00');
  String formattedNumber = numberFormatter.format(number);
  if (!decimals) {
    formattedNumber = formattedNumber.split('.').first;
  }
  return formattedNumber.toPersianDigit();
  // return intl.NumberFormat('###,###,###,###').format(number).toPersianDigit();
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


///
Future<Device> getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Device device =
    Device(platform: 'Android',brand: androidInfo.brand,id: androidInfo.id,name: androidInfo.device);
    return device;
  }

  else if (Platform.isWindows) {
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    Device windowsDevice = Device(platform: 'Windows',
        name:windowsInfo.computerName, brand:windowsInfo.productName,id: windowsInfo.deviceId);
    return windowsDevice;
  }

  else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    Device iosDevice =
    Device(platform: 'ios', brand:iosInfo.model,name: iosInfo.name,id: iosInfo.localizedModel);
    return iosDevice;
  }
  else {
    Device elseDevice =
    Device(platform: Platform.operatingSystem, brand:Platform.version,name: Platform.localeName,id: Platform.operatingSystemVersion);
    return elseDevice;
  }
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
///
DateTime findMinDate(List<DateTime> dateList) {
  DateTime minDate = dateList[0];
  for (int i = 1; i < dateList.length; i++) {
    if (minDate.isAfter(dateList[i])) {
      minDate = dateList[i];
    }
  }
  return minDate;
}

///save image from cache to new path
saveImage(String? path,String idName,String newPath)async{
  try {
    if (path != null) {
      int index=0;
      String newFilePath = "$newPath/$idName-${index}.jpg";
      while (await File(newFilePath).exists()) {
        index++;
        newFilePath = "$newPath/$idName-${index}.jpg";
      }
      File newFile = await File(path).copy(newFilePath);
      //delete file picker cache file in android and ios because windows show original path file so when you delete it's delete orginal file
      if (Platform.isAndroid || Platform.isIOS) {
        await File(path).delete();
      }
      return newFile.path;
    }
  }catch(e,stacktrace){
    ErrorHandler.errorManger(null,
        e,
        stacktrace: stacktrace,
        route: "util.dart saveImage function error ",
        errorText: "خطا در کپی کردن تصویر در مسیر جدید");
  }
  return null;
}
/// resize image
reSizeImage(String iPath,{int width=600,int quality=30})async{
  await (img.Command()
  // Read a jpj image from a file.
    ..decodeJpgFile(iPath)
  // Resize the image so its width is some number and height maintains aspect
  // ratio.
    ..copyResize(width: width)
  // Save the image to a jpj file.
    ..writeToFile(iPath))
  // Execute the image commands in an isolate thread
      .executeThread();
  //******
  //compress image
  ImageFile input=ImageFile(filePath: iPath,rawBytes: File(iPath).readAsBytesSync()); // set the input image file
  Configuration config = Configuration(
    outputType: ImageOutputType.jpg,
    // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
    useJpgPngNativeCompressor:false,//(Platform.isAndroid || Platform.isIOS) ? true : false,
    // set quality between 0-100
    quality: quality,
  );
  final param = ImageFileConfiguration(input: input, config: config);
  final output = await compressor.compress(param);
  debugPrint("Input size : ${input.sizeInBytes}");
  debugPrint("Output size : ${output.sizeInBytes}");

  if(input.sizeInBytes>100100){
    await img.writeFile(iPath, output.rawBytes);
  }
}
///
Future<bool> deleteImageFile(String? path) async {
  if(path!=null){
    final file = File(path);
    if (await file.exists()) {
      try {
        await file.delete();
        print("File deleted successfully");
        return true;
      } catch (e, stacktrace) {
        ErrorHandler.errorManger(null, e,
            stacktrace: stacktrace, errorText: "خطا در حذف تصویر از حافظه");
      }
    }
  }
  return false;
}

/// delete directory
Future<bool> deleteDirectory(String path) async {
  final directory = Directory(path);

  if (await directory.exists()) {
    try {
      await directory.delete(recursive: true);
      print("Directory deleted successfully");
      return true;
    } catch (e,stacktrace) {
      ErrorHandler.errorManger(null, e,stacktrace: stacktrace,errorText: "خطا در حذف دایرکتوری از حافظه");
    }
  }
  return false;
}

/// check internet connection
Future<bool> checkNetworkConnection() async{
  final connectivityResult=await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet ||
        connectivityResult == ConnectivityResult.vpn)
    {
       final result=await InternetAddress.lookup('google.com').timeout(Duration(seconds: 5)).catchError((e,stacktrace){
         debugPrint("connection found but Network error");
       });
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            debugPrint("Network is connected!");
            return true;
          }else{
            debugPrint("connection found but no Network");
            return false;
          }
    }else{
      debugPrint("No connection found!");
      return false;
    }

}