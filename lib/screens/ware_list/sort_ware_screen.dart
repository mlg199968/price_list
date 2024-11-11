import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/check_button.dart';
import 'package:price_list/components/custom_float_action_button.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/screens/ware_list/services/ware_tools.dart';
import 'package:price_list/services/hive_boxes.dart';
import '../../constants/constants.dart';
import '../../model/ware.dart';

class SortWareScreen extends StatefulWidget {
  static const String id = "/sort-ware-screen";
  const SortWareScreen({super.key, required this.wareList});
  final List<Ware> wareList;

  @override
  State<SortWareScreen> createState() => _SortWareScreenState();
}

class _SortWareScreenState extends State<SortWareScreen> {
  late List<DragAndDropList> _contents;
  String sortItem = kSortList[4];
  bool _groupSortEnabled = false; // متغیر برای چک‌باکس
  late List<Ware> updatedList;

  @override
  void initState() {
    updatedList = WareTools.filterList(widget.wareList, "", sortItem, "همه");
    super.initState();
    _contents = createContents();
  }

  // ایجاد محتوا برای Drag and Drop
  List<DragAndDropList> createContents({String? sort}) {
    updatedList = sort != null
        ? WareTools.filterList(widget.wareList, "", sort, "همه")
        : updatedList;

    // مرتب‌سازی بر اساس گروه در صورت فعال بودن چک‌باکس
    if (_groupSortEnabled) {
      // updatedList.sort((a, b) => a.groupName.compareTo(b.groupName));

      // دسته‌بندی کالاها بر اساس گروه
      Map<String, List<Ware>> groupedItems = {};
      for (Ware ware in updatedList) {
        groupedItems.putIfAbsent(ware.groupName, () => []).add(ware);
      }

      // ایجاد DragAndDropList برای هر گروه
      List<DragAndDropList> groupLists = groupedItems.entries.map((entry) {
        return DragAndDropList(
          header: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              entry.key,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          children: entry.value
              .map((ware) => DragAndDropItem(
            canDrag: false,
                    key: ValueKey(ware.wareID ?? "0"),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        gradient: kBlackWhiteGradiant,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              ware.wareName,
                              textDirection: TextDirection.rtl,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                          Text(
                            ware.groupName,
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        );
      }).toList();

      return groupLists;
    } else {
      // نمایش به صورت لیست ساده بدون دسته‌بندی
      return [
        DragAndDropList(
          children: updatedList
              .map((ware) => DragAndDropItem(
                    child: Container(
                      padding: EdgeInsets.all(10).copyWith(right: 25),
                      decoration: BoxDecoration(
                        gradient: kBlackWhiteGradiant,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              ware.wareName,
                              textDirection: TextDirection.rtl,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ),
                          Text(
                            ware.groupName,
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatActionButton(
        label: "ذخیره کردن",
        icon: Icons.save,
        iconSize: 30,
        onPressed: () {
          for (int i = 0; i < updatedList.length; i++) {
            Ware ware = updatedList[i];
            ware.sortIndex = i;
            HiveBoxes.getWares().put(ware.wareID, ware);
          }
          Navigator.pop(context);
        },
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('ویرایش ترتیب'),
        bottom: PreferredSize(preferredSize: Size(400, 30),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade100.withOpacity(.9)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CheckButton(
                    label:'مرتب‌سازی بر اساس گروه' ,
                    value: _groupSortEnabled,
                    onChange: (bool? value) {
                      setState(() {
                        _groupSortEnabled = value ?? false;
                        _contents = createContents(sort: sortItem);
                      });
                    },
                  ),
                  Flexible(
                    child: DropListModel(
                      height: 25,
                      listItem: kSortList,
                      selectedValue: sortItem,
                      onChanged: (val) {
                        setState(() {
                          sortItem = val;
                          _contents = createContents(sort: sortItem);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),),
        actions: [


        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 60),
        decoration: BoxDecoration(gradient: kMainGradiant),
        child: SizedBox(
          width: 500,
          child: DragAndDropLists(
            children: _contents,
            onItemReorder: _onItemReorder,
            onListReorder: _onListReorder,
            listPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemDivider: Divider(thickness: 0, height: 2),
            listDragHandle: DragHandle(
                child: Icon(
                  Icons.menu_rounded,
                  size: 30,
                  color: Colors.white70,
                ),
                verticalAlignment: DragHandleVerticalAlignment.top),
            itemDragHandle: DragHandle(child: Icon(Icons.drag_handle_rounded)),
            itemDecorationWhileDragging: BoxDecoration(
              color: kMainColor[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
      Ware movedWare = updatedList.removeAt(oldItemIndex);
      updatedList.insert(newItemIndex, movedWare);
      // بروزرسانی sortIndex برای هر Ware
      for (int i = 0; i < updatedList.length; i++) {
        updatedList[i].sortIndex = i;
      }
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
   int indexLocation=0;

    var movedList = _contents.removeAt(oldListIndex);
    _contents.insert(newListIndex, movedList);


   for (int i = 0; i < newListIndex; i++){
     indexLocation+= _contents[i].children.length;
     print(indexLocation);
   }

    List<Ware> movedItems = _contents[newListIndex].children.map((item) => updatedList.firstWhere((element) => element.wareID==(item.key as ValueKey).value)).toList();
   updatedList.removeWhere((ware) => movedItems.map((movedWare) => movedWare.wareID).contains(ware.wareID));
    updatedList.insertAll(indexLocation, movedItems);

   // بروزرسانی sortIndex برای هر Ware
   for (int i = 0; i < updatedList.length; i++) {
     updatedList[i].sortIndex = i;
   }
    setState(() {});
  }
}
