import 'package:flutter/material.dart';
import 'cell_content.dart';


// ignore: must_be_immutable
class TableView extends StatelessWidget {
 TableView(this.tableRow, {super.key});
List<String> tableRow;
  @override
  Widget build(BuildContext context) {
    //tableRow.removeWhere((element) => tableRow.indexOf(element)>2);
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [rowBuilder(tableRow)],
    );
  }
}

Row rowBuilder(List<String> cells) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    CellContent(cells[2],cells,4),
    CellContent(cells[1],cells,2),
    CellContent(cells[0],cells,5),
  ]
);

// cells.reversed.map(
// (cell) {
// //TODO:Column Visibility this condition make chosen column became invisible
// return Visibility(
// visible: cells.indexOf(cell)>2?false:true,
// child: CellContent(cell,cells));
//
// },
// ).toList(),