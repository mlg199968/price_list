import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
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
    updatedList=WareTools.filterList(widget.wareList, "", sortItem, "همه");
    super.initState();
    _contents = createContents();
  }

  // ایجاد محتوا برای Drag and Drop
  List<DragAndDropList> createContents({String? sort}) {
    updatedList = sort != null
        ? WareTools.filterList(updatedList, "", sort, "همه")
        : updatedList;

    // مرتب‌سازی بر اساس گروه در صورت فعال بودن چک‌باکس
    if (_groupSortEnabled) {
      updatedList.sort((a, b) => a.groupName.compareTo(b.groupName));
    }

    return [
      DragAndDropList(
        children: updatedList
            .map((ware) => DragAndDropItem(
          child: Container(
            padding: EdgeInsets.all(10).copyWith(right: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    ware.wareName,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                Text(
                  ware.groupName,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 9),
                ),
              ],
            ),
          ),
        ))
            .toList(),
      )
    ];
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
        actions: [
          // DropListModel برای مرتب‌سازی
          Flexible(
            child: DropListModel(
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
          // چک‌باکس برای مرتب‌سازی بر اساس گروه
          Row(
            children: [
              const Text(
                'مرتب‌سازی بر اساس گروه',
                style: TextStyle(fontSize: 12),
              ),
              Checkbox(
                value: _groupSortEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    _groupSortEnabled = value ?? false;
                    _contents = createContents(sort: sortItem);
                  });
                },
              ),
            ],
          ),
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
            listPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemDivider: Divider(
              thickness: 2,
              height: 2,
            ),
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
            listInnerDecoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            lastItemTargetHeight: 8,
            addLastItemTargetHeightToTop: true,
            lastListTargetSize: 40,
            listDragHandle: const DragHandle(
              verticalAlignment: DragHandleVerticalAlignment.top,
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.menu,
                  color: Colors.black26,
                ),
              ),
            ),
            itemDragHandle: const DragHandle(
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.menu,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // متد برای جابه‌جایی آیتم‌ها
  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
print("old");
print(updatedList[oldItemIndex].wareName);
      Ware movedWare = updatedList.removeAt(oldItemIndex);
      updatedList.insert(newItemIndex, movedWare);
      print("new");
      print(updatedList[newItemIndex].wareName);
      // بروزرسانی sortIndex برای هر Ware
      for (int i = 0; i < updatedList.length; i++) {
        updatedList[i].sortIndex = i;
      }
    });
  }

  // متد برای جابه‌جایی لیست‌ها
  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }
}