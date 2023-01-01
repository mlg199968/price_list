import 'package:flutter/material.dart';
import 'package:price_list/parts/final_list.dart';
import 'package:price_list/screens/main_screen.dart';
import 'screens/price_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/setting_screen.dart';
import 'package:provider/provider.dart';
import 'screens/load_screen.dart';

void main() => runApp(const MyApp());

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
        return FinalList();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: LoadScreen.id,
        routes: {
          PriceScreen.id: (context) => PriceScreen(),
          AddProductScreen.id: (context) => AddProductScreen([]),
          SettingScreen.id: (context) => const SettingScreen(),
          LoadScreen.id: (context) => const LoadScreen(),
          MainScreen.id: (context) => const MainScreen(),
        },
      ),
    );
  }
}
