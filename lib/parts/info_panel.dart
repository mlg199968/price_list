import 'package:flutter/material.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/data/product.dart';
import 'package:price_list/data/product_database.dart';
import 'package:price_list/screens/add_product_screen.dart';


// ignore: must_be_immutable
class InfoPanel extends StatelessWidget {
  InfoPanel(this.infoData, {super.key});
  Product infoData;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('info Panel'),
      actions: [
        Container(
          padding: const EdgeInsetsDirectional.all(15),
          child: Column(
            children: <Widget>[
              infoPanelRow(title: "نام محصول",infolist: infoData.productName),
              infoPanelRow(title: "مقدار",infolist: infoData.unit),
              infoPanelRow(title: "قیمت خرید",infolist: infoData.costPrice),
              infoPanelRow(title: "قیمت فروش",infolist: infoData.salePrice),
              infoPanelRow(title: "سرگروه",infolist: infoData.groupName),
              infoPanelRow(title: "ID",infolist: infoData.id),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),gradient:kGradiantColor1 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  GestureDetector(
                    onTap:(){
                      ProductsDatabase.instance.delete(infoData.id);
                      Navigator.pop(context,false);

                    },
                    child: const Icon(Icons.delete,color: Colors.white70,),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProductScreen(oldProduct: infoData,)));
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


