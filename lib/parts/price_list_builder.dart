import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'final_list.dart';
import 'table_view.dart';

class PriceListBuilder extends StatelessWidget {
  const PriceListBuilder({super.key});


  @override
  Widget build(BuildContext context) {
    return Consumer<FinalList>(builder: (context, dataProduct, child) {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
       if(dataProduct.selectedGroup==dataProduct.dataList[index][4]) {
         return TableView(dataProduct.dataList[index]);
       } else if(dataProduct.selectedGroup=='همه') {
         return TableView(dataProduct.dataList[index]);
       }
        return const SizedBox();
          },
          itemCount: dataProduct.dataList.length,
        ),
      );
    }
    );
  }
}
