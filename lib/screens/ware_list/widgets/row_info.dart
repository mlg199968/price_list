import 'package:flutter/material.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_text.dart';

class InfoPanelRow extends StatelessWidget {
  const InfoPanelRow({super.key, required this.infoList, required this.title});

  final String? infoList;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.black12,
              ))),
      width: MediaQuery.of(context).size.width * .5,
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CText(title.toPersianDigit(),fontSize: 12,color: Colors.black45,textDirection: TextDirection.rtl,),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: SelectableText(
              (infoList ?? "").toPersianDigit(),
              textAlign: TextAlign.left,
              minLines: 1,
              maxLines: 7,
              // overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}