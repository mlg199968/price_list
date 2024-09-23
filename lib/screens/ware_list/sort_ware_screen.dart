import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/custom_float_action_button.dart';
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
  // Outer list
  late List<DragAndDropList> _contents;

  @override
  void initState() {
    super.initState();
    print(widget.wareList.length);
    _contents = List.generate(1, (index) {
      return DragAndDropList(
          children: widget.wareList
              .map((ware) => DragAndDropItem(
                    child: Container(
                      padding: EdgeInsets.all(10).copyWith(right: 50),
                      decoration: BoxDecoration(
                        // color: Colors.white,
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 12),
                          )),
                          Text(
                            ware.groupName,
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList());
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      floatingActionButton: CustomFloatActionButton(
        label:"ذخیره کردن" ,
          icon: Icons.change_circle_outlined,
          iconSize: 30,
          onPressed: (){
          for(int i=0;i<widget.wareList.length;i++){
            Ware ware= widget.wareList[i];
           ware.sortIndex=i;
            HiveBoxes.getWares().put(ware.wareID, ware);
          }
          Navigator.pop(context);
          }),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('ویرایش ترتیب'),
      ),
      // drawer: const CustomNavigationDrawer(),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 60),
        decoration:BoxDecoration(gradient: kMainGradiant) ,
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
                  offset: const Offset(0,2), // changes position of shadow
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

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {

    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);

      Ware movedWare = widget.wareList.removeAt(oldItemIndex);
      widget.wareList.insert(newItemIndex, movedWare);

    });
    print(oldItemIndex);
    print("oldItemIndex");
    print(widget.wareList[newItemIndex].wareName);
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }
}
