import 'package:flutter/material.dart';
import 'package:price_list/constants.dart';
import 'package:price_list/data/notes_database.dart';
import 'package:price_list/parts/final_list.dart';
import 'package:price_list/screens/add_product_screen.dart';
import 'package:price_list/screens/main_screen.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class InfoPanel extends StatelessWidget {
  InfoPanel(this.infoData, {super.key});
  List<String> infoData;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('info Panel'),
      actions: [
        Container(
          padding: const EdgeInsetsDirectional.all(15),
          child: Column(
            children: <Widget>[
              infoPanelRow(title: "نام محصول",infolist: infoData[0]),
              infoPanelRow(title: "واحد",infolist: infoData[1]),
              infoPanelRow(title: "قیمت خرید",infolist: infoData[3]),
              infoPanelRow(title: "قیمت فروش",infolist: infoData[2]),
              infoPanelRow(title: "سرگروه",infolist: infoData[4]),
              infoPanelRow(title: "ID",infolist: infoData[5]),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient:kGradiantColor1 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  GestureDetector(
                    onTap:(){
                      NotesDatabase.instance.delete(infoData[5]);
                      Provider.of<FinalList>(context,listen: false).selectedGroup='همه';
                      Provider.of<FinalList>(context,listen: false).groupDropListValue='همه';
                      Navigator.pushNamed(context, MainScreen.id);


                    },
                    child: const Icon(Icons.delete,color: Colors.white70,),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AddProductScreen(infoData),
                      ));
                    },
                    child: const Icon(Icons.drive_file_rename_outline_sharp,color: Colors.white70,),
                  ),

                ],),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class infoPanelRow extends StatelessWidget {
  const infoPanelRow({super.key,
    required this.infolist,required this.title
  });

  final String infolist;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
     Text(infolist),
     Text(title),

    ],);
  }
}


