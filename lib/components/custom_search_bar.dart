import 'package:flutter/material.dart';
import 'package:price_list/components/drop_list_model.dart';



class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {super.key,
      required this.controller,
      required this.hint,
      required this.onChange(val),
      required this.selectedSort,
      required this.sortList,
      required this.onSort,
      this.focusNode

      });
  final TextEditingController controller;
  final String hint;
  final Function onChange;
  final String selectedSort;
  final Function onSort;
  final List sortList;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: Expanded(
            child: SizedBox(
              height: 50,
              child: Card(
                elevation: 4,
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  onChanged: (val) {
                    onChange(val);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: hint,
                    suffixIcon: const Icon(Icons.search_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  cursorHeight: 30,
                ),
              ),
            ),
          ),
        ),
        DropListModel(
          icon: const Icon(Icons.sort,size: 30,color: Colors.white70,),
            listItem: sortList,
            selectedValue: selectedSort,
            onChanged: (val) {
              onSort(val);
            })
      ],
    );
  }
}
