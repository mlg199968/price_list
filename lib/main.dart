import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/router.dart';
import 'package:price_list/ware_provider.dart';
import 'package:provider/provider.dart';
import 'screens/load_screen.dart';

void main() async {
  await Hive.initFlutter();
  //Adaptors
  Hive.registerAdapter(WareHiveAdapter());
  //create box for store data
  await Hive.openBox<WareHive>("ware_db");

  runApp(const MyApp());}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return WareProvider();
      },
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: "persian",
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
      ),
    );
  }
}
