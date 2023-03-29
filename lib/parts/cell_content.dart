
import 'package:flutter/material.dart';
import 'package:price_list/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

// ignore: must_be_immutable
class CellContent extends StatelessWidget {
  CellContent(this.cell,this.cells,this.holderFlex);
  int holderFlex=1;
  String cell;
  List<String> cells;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      flex: holderFlex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GestureDetector(
          onTap: (){
           // Provider.of<FinalList>(context,listen: false).removeFromList(cells);
           //  showDialog(
           //    context: context,
           //    builder: (BuildContext context) {
           //      return InfoPanel(cells);
           //        //Consumer<FinalList>(builder:(context,productList,child){return InfoPanel(productList.dataList[productList.currentIndex]);},);
           //    },
           //  );
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: kColorController.withOpacity(.2),borderRadius: BorderRadius.circular(0)),
            child: AutoSizeText(
              cell,

              overflow: TextOverflow.ellipsis,
              textAlign: holderFlex==4?TextAlign.left:TextAlign.right,
              style:kCellStyle,
              minFontSize: 15.0,
            ),
          ),
        ),
      ),
    );
  }
}