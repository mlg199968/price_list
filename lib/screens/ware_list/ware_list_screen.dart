import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/custom_alert.dart';
import 'package:price_list/components/custom_float_action_button.dart';
import 'package:price_list/components/custom_search_bar.dart';
import 'package:price_list/components/custom_tile.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/components/pdf/pdf_api.dart';
import 'package:price_list/components/pdf/pdf_ware_list_api.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/side_bar/sidebar_panel.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/pay_services/pay_service.dart';
import 'package:price_list/screens/add_ware/add_ware_screen.dart';
import 'package:price_list/screens/ware_list/panels/info_panel.dart';
import 'package:price_list/screens/ware_list/panels/selected_action_panel.dart';
import 'package:price_list/screens/ware_list/panels/ware_action_panel.dart';
import 'package:price_list/screens/ware_list/services/ware_tools.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WareListScreen extends StatefulWidget {
  static const String id = "/wareListScreen";

  const WareListScreen({Key? key}) : super(key: key);

  @override
  State<WareListScreen> createState() => _WareListScreenState();
}

class _WareListScreenState extends State<WareListScreen> {
  TextEditingController searchController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final SharedPreferences prefs;
  late final WareProvider provider;
  String selectedDropListGroup = "همه";
  final List<String> sortList = [
    'تاریخ ویرایش',
    'تاریخ ثبت',
    'حروف الفبا',
    'موجودی کالا',
  ];
  String sortItem = 'تاریخ ویرایش';
  String? keyWord;
  List<WareHive> waresList = [];

  void getStartupData() async {
    //get ware group list
    provider.loadGroupList(HiveBoxes.getGroupWares());
  }

  @override
  void initState() {
    provider = Provider.of<WareProvider>(context, listen: false);
     getStartupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: CustomFloatActionButton(
            onPressed: () async{
              Navigator.pushNamed(context, AddWareScreen.id);
            }),
        drawer: SideBarPanel(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  Consumer<WareProvider>(
                    builder: (context, wareData, child) {
                      return DropListModel(
                        selectedValue: selectedDropListGroup,
                        height: 40,
                        listItem: ["همه", ...wareData.groupList],
                        onChanged: (val) {
                          selectedDropListGroup = val;
                          setState(() {});
                        },
                      );
                    },
                  ),

                  ///dropDown list for Group Select
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => WareActionsPanel(
                                  wares: waresList,
                                  subGroup: selectedDropListGroup,
                                ));
                      },
                      icon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [BoxShadow(offset: Offset(-1, -1),blurRadius: 1,color: Colors.grey)],
                            gradient: kMainGradiant,
                          ),
                          padding: EdgeInsets.all(5),
                          child: const Icon(
                            Icons.print,
                          ))),
                ],
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        scaffoldKey.currentState!.openDrawer();
                      },
                      child: Image.asset('assets/images/logo.png')),
                ),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(gradient: kMainGradiant),
                ),
                title: Container(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Price List"),
                    ],
                  ),
                ),
                elevation: 5.0,
                automaticallyImplyLeading: false,
                expandedHeight: 0,
                floating: true,
                snap: true,
              )
            ];
          },
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('برای خروج دوباره ضربه بزنید'),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(gradient: kMainGradiant),
                    padding: const EdgeInsets.all(10),
                    child: CustomSearchBar(
                      controller: searchController,
                      hint: "جست و جو کالا",
                      onChange: (val) {
                        keyWord = val;
                        setState(() {});
                      },
                      selectedSort: sortItem,
                      sortList: sortList,
                      onSort: (val) {
                        sortItem = val;
                        setState(() {});
                      },
                    ),
                  ),

                  ///get ware list
                  ValueListenableBuilder<Box<WareHive>>(
                      valueListenable: HiveBoxes.getWares().listenable(),
                      builder: (context, box, _) {
                        final productList = box.values.toList().cast<WareHive>();
                        waresList = productList;
                        List<WareHive> filteredList =
                            WareTools.filterList(productList, keyWord, sortItem);
                        if (filteredList.isEmpty) {
                          return const Expanded(
                            child: Center(
                                child: Text(
                              " کالایی یافت نشد!",
                              textDirection: TextDirection.rtl,
                            )),
                          );
                        }
                        return ListPart(
                          key: widget.key,
                          category: selectedDropListGroup,
                          wareList: filteredList,
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ListPart extends StatefulWidget {
  const ListPart({super.key, required this.wareList, required this.category});

  final List<WareHive> wareList;
  final String category;

  @override
  State<ListPart> createState() => _ListPartState();
}

class _ListPartState extends State<ListPart> {
  List<int> selectedItems = [];
  WareHive? selectedWare;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      //if action bottom bar is shown,on will pop first close the action bar then on the second press close the screen
      onWillPop: selectedItems.isEmpty
          ? null
          : () async {
              selectedItems.clear();
              setState(() {});
              return false;
            },
      child: Consumer<WareProvider>(
        builder: (context,wareProvider,child) {
          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.wareList.length,
                      itemBuilder: (context, index) {
                        WareHive ware = widget.wareList[index];
                        if (widget.category == "همه" ||
                            widget.category == widget.wareList[index].groupName) {
                          return InkWell(
                            onTap: () {
                              if (selectedItems.isEmpty) {
                                if (widget.key != null) {
                                  Navigator.pop(context, ware);
                                } else {
                                  selectedWare = ware;
                                  setState(() {});
                                  showDialog(
                                      context: context,
                                      builder: (context) => InfoPanel(
                                          context: context, wareInfo: ware));
                                }
                              } else {
                                if (selectedItems.contains(index)) {
                                  selectedItems.remove(index);
                                } else {
                                  selectedItems.add(index);
                                }
                                setState(() {});
                              }
                            },
                            onLongPress: () {
                              if (!selectedItems.contains(index)) {
                                selectedItems.add(index);
                                setState(() {});
                              }
                            },
                            child: CustomTile(
                              selected: selectedItems.contains(index),
                              height: 50,
                              color: Colors.deepPurple.shade800,
                              leadingIcon: CupertinoIcons.cube_box_fill,
                              subTitle: ware.groupName,
                              type: "کالا",
                              title: ware.wareName,
                              topTrailing: wareProvider.showQuantity
                                  ? ("${ware.quantity}  ".toPersianDigit() +
                                      ware.unit)
                                  : "",
                              topTrailingLabel: wareProvider.showQuantity ? "موجودی:" : "",
                              trailing: addSeparator(ware.sale),
                              trailingLabel: "فروش:",
                              middle: wareProvider.showCostPrice ? addSeparator(ware.cost) : null,
                              middleLabel: wareProvider.showCostPrice ? "خرید:" : null,
                            ),
                          );
                        }
                        return const SizedBox();
                      }),
                ),

                ///selected items action bottom bar
                Opacity(
                  opacity: selectedItems.isNotEmpty ? 1 : 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black87))),
                    height: selectedItems.isNotEmpty ? 50 : 0,
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        ///delete icon
                        IconButton(
                            onPressed: () {
                              customAlert(
                                  context: context,
                                  title: "آیا از حذف موارد انتخاب شده مطمئن هستید؟",
                                  onYes: () {
                                    for (int item in selectedItems) {
                                      widget.wareList[item].delete();
                                    }
                                    showSnackBar(context,
                                        " ${selectedItems.length} کالا حذف شد!  ",
                                        type: SnackType.success);
                                    selectedItems.clear();
                                    Navigator.pop(context);
                                  },
                                  onNo: () {
                                    Navigator.pop(context);
                                  });
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              size: 35,
                              color: Colors.red,
                            )),
                        const VerticalDivider(),

                        ///print icon
                        IconButton(
                            onPressed: () async {
                              List<WareHive> selectedList = [];
                              for (int item in selectedItems) {
                                selectedList.add(widget.wareList[item]);
                              }
                              final file = await PdfWareListApi.generateTicketWareList(
                                  selectedList, context);
                              PdfApi.openFile(file);
                            },
                            icon: const Icon(
                              CupertinoIcons.printer_fill,
                              size: 30,
                              color: Colors.black87,
                            )),
                        const VerticalDivider(),

                        ///edit selected icon
                        IconButton(
                            onPressed: () {
                              List<WareHive> selectedList = [];
                              for (int item in selectedItems) {
                                selectedList.add(widget.wareList[item]);
                              }
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      SelectedWareActionPanel(wares: selectedList));
                            },
                            icon: const Icon(
                              FontAwesomeIcons.filePen,
                              size: 30,
                              color: Colors.black87,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
