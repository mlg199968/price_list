import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_list/constants.dart';
import 'package:price_list/data/notes_database.dart';
import 'price_screen.dart';
import 'add_product_screen.dart';
import 'setting_screen.dart';

class MainScreen extends StatefulWidget {
  static String id="mainScreen";
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex=0;

  List<Widget> screens=[
    PriceScreen(),
    AddProductScreen(const []),
    const SettingScreen(),
  ];

  Future<bool> onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        title:  const Text('آیا می خواهید خارج شوید؟',
            style:  TextStyle(color: Colors.black, fontSize: 20.0)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context), // this line dismisses the dialog
            child:  const Text('No', style:  TextStyle(fontSize: 18.0)),
          ),
          TextButton(
            onPressed: () {
              // this line exits the app.
              SystemChannels.platform
                  .invokeMethod('SystemNavigator.pop');
              NotesDatabase.instance.close();
            },
            child:
            const Text('Yes', style:  TextStyle(fontSize: 18.0)),
          )
        ],
      ),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body:screens[currentPageIndex] ,
        bottomNavigationBar: Container(

          decoration: const BoxDecoration(gradient:kGradiantColor1),
          child: Wrap(
            children:[ BottomNavigationBar(
              backgroundColor: Colors.transparent,
              unselectedItemColor: Colors.white70,
              selectedItemColor: Colors.white,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              elevation: 20,
              iconSize: 40,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              currentIndex: currentPageIndex,
              type:BottomNavigationBarType.fixed,
              onTap: (index){setState(() {
                currentPageIndex=index;
              });},
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.list_alt,),
                    label: "List"),
                BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline,size: 40,),
                    label: 'add'),
                BottomNavigationBarItem(icon: Icon(Icons.settings),
                    label: "Setting"),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
