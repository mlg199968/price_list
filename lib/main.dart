import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:price_list/constants/consts_class.dart';
import 'package:price_list/constants/global_task.dart';
import 'package:price_list/model/bug.dart';
import 'package:price_list/model/notice.dart';
import 'package:price_list/model/shop.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/providers/user_provider.dart';
import 'package:price_list/router.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';
import 'model/device.dart';
import 'model/plan.dart';
import 'model/subscription.dart';
import 'model/user.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //Adaptors
  Hive.registerAdapter(WareAdapter());
  Hive.registerAdapter(ShopAdapter());
  Hive.registerAdapter(NoticeAdapter());
  Hive.registerAdapter(BugAdapter());
  Hive.registerAdapter(SubscriptionAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(DeviceAdapter());
  Hive.registerAdapter(PlanAdapter());
  //create box for store data
  await Hive.openBox<Ware>("ware_db",path:await Address.hiveDirectory());
  await Hive.openBox<Shop>("shop_db",path:await Address.hiveDirectory());
  await Hive.openBox<Bug>("bug_db",path:await Address.hiveDirectory());
  await Hive.openBox<Notice>("notice_db",path:await Address.hiveDirectory());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => WareProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: const MyApp(),

  ));}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getFont(){
    Provider.of<UserProvider>(context, listen: false).setFontFromHive();
  }
  @override
  void initState() {
    getFont();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: GlobalTask.navigatorState,
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
          fontFamily:context.watch<UserProvider>().fontFamily,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.indigo,
              foregroundColor: Colors.white),
          scaffoldBackgroundColor: const Color(0XFFf5f5f5)),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (setting) => generateRoute(setting),
      home: SplashScreen(),
      //initialRoute:SplashScreen.id, //SplashScreen.id,

      // routes: {
      //   PriceScreen.id: (context) => PriceScreen(),
      //   AddProductScreen.id: (context) => AddProductScreen(),
      //   SettingScreen.id: (context) => const SettingScreen(),
      //   SplashScreen.id: (context) => const SplashScreen(),
      // },
    );
  }
}
