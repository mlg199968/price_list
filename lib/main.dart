import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:price_list/model/bug.dart';
import 'package:price_list/model/notice.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/router.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';
import 'screens/load_screen.dart';

void main() async {
  await Hive.initFlutter();
  //Adaptors
  Hive.registerAdapter(WareHiveAdapter());
  Hive.registerAdapter(ShopAdapter());
  Hive.registerAdapter(NoticeAdapter());
  Hive.registerAdapter(BugAdapter());
  //create box for store data
  await Hive.openBox<WareHive>("ware_db");
  await Hive.openBox<Shop>("shop_db");
  await Hive.openBox<Bug>("bug_db");
  await Hive.openBox<Notice>("notice_db");

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => WareProvider()),
    ],
    child: const MyApp(),

  ));}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   Provider.of<WareProvider>(context,listen: false).getFontFromHive();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
          fontFamily: context.watch<WareProvider>().fontFamily,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.indigo,
              foregroundColor: Colors.white),
          scaffoldBackgroundColor: const Color(0XFFf5f5f5)),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (setting) => generateRoute(setting),
      home: LoadScreen(),
      //initialRoute:LoadScreen.id, //LoadScreen.id,

      // routes: {
      //   PriceScreen.id: (context) => PriceScreen(),
      //   AddProductScreen.id: (context) => AddProductScreen(),
      //   SettingScreen.id: (context) => const SettingScreen(),
      //   LoadScreen.id: (context) => const LoadScreen(),
      // },
    );
  }
}
