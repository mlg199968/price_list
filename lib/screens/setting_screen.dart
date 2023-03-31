
import 'package:flutter/material.dart';
import 'package:price_list/constants/constants.dart';

class SettingScreen extends StatefulWidget {
  static String id = 'settingScreen';
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient:kGradiantColor1 ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: <Widget>[
            Expanded(
              child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(top: 100),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70), topRight: Radius.circular(70))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButtonTheme(
                    data: kButtonStyle,
                    child: TextButton(
                      onPressed:true?null: () async {
                        // String dbPath =
                        //     "${await getDatabasesPath()}/price_list_data.db";
                        // String? result =
                        //     await FilePicker.platform.getDirectoryPath();
                        // if (result != null) {
                        //   String newPath = result;
                        //   File dbFile = File(dbPath);
                        //   dbFile.copy("$newPath/price_list_data.db");
                        //   print("my own file path provider $newPath");
                        //   print("my own file path provider $dbPath");
                       // }
                      },
                      child: const Text('خلق نسخه پشتیبان'),
                    ),
                  ),
                  TextButtonTheme(
                    data: kButtonStyle,
                    child: TextButton(

                      onPressed:true ? null  :() async {

                        // String dbDirectory =
                        //     await getDatabasesPath();
                        // String dbPath0="$dbDirectory/price_list_data_backup.db";
                        // FilePickerResult? result =
                        //     await FilePicker.platform.pickFiles();
                        //
                        // if (result != null) {
                        //   ProductsDatabase.instance.close();
                        //   print(File(result.files.single.path!).path);
                        //   File backupFile = File(result.files.single.path!);
                        //   File oldFile= File(dbPath0);
                        //   await oldFile.delete();
                        //   await backupFile.copy(dbPath0);
                        //   setState(() {
                        //     print('successfully restore');
                        //     print(File(result.files.single.path!).path);
                        //
                        //   });
                        // }
                      },
                      child: const Text('بارگیری نسخه پشتیبان'),
                    ),
                  ),
                  const Text(' در آپدیت های بعد فعال می شود '),

                ],
              ),
          ),
            ),
        ]),
      ),
    );
  }
}
