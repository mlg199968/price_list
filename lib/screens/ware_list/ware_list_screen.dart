import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_alert.dart';
import 'package:price_list/components/custom_float_action_button.dart';
import 'package:price_list/components/custom_icon_button.dart';
import 'package:price_list/components/custom_search_bar.dart';
import 'package:price_list/components/custom_text.dart';
import 'package:price_list/components/custom_tile.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/empty_holder.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/notice_screen/notice_screen.dart';
import 'package:price_list/screens/notice_screen/services/notice_tools.dart';
import 'package:price_list/screens/side_bar/sidebar_panel.dart';
import 'package:price_list/screens/ware_list/panels/print_panel.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/screens/ware_list/add_ware_screen.dart';
import 'package:price_list/screens/ware_list/panels/info_panel.dart';
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
  bool showAlertNotice = true;

  @override
  void initState() {
    Provider.of<WareProvider>(context, listen: false).loadGroupList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: CustomFloatActionButton(onPressed: () async {
          Navigator.pushNamed(context, AddWareScreen.id);
        }),
        drawer: SideBarPanel(),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  ///dropDown list for Group Select
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

                  ///print Panel
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => PrintPanel(
                                  wares: waresList,
                                  subGroup: selectedDropListGroup,
                                ));
                      },
                      icon:  Icon(
                        CupertinoIcons.printer,
                        size: 25,
                        shadows: [kShadow]
                      )),
                  ///action panel
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => WareActionsPanel(
                                  wares: waresList,
                                  subGroup: selectedDropListGroup,
                                ));
                      },
                      icon:  Icon(
                        Icons.more_vert_rounded,
                        size: 25,
                        shadows: [kShadow]
                      )),
                ],
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
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
                    textBaseline: TextBaseline.alphabetic,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(Provider.of<WareProvider>(context, listen: false).isVip)
                      const Icon(
                        FontAwesomeIcons.crown,
                        color: Colors.orangeAccent,
                      ),
                      const Gap(5),
                       Flexible(child: Text("Price List",style: GoogleFonts.bebasNeue(fontSize: 25),)),
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
              decoration: BoxDecoration(gradient: kMainGradiant),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  children: <Widget>[
                    ///Notification Alert,if new notification exist this part will be shown
                    AnimatedSize(
                      curve: Curves.easeInOutExpo,
                      duration: Duration(milliseconds: 400),
                      child: (!NoticeTools.checkNewNotifications() ||
                              !showAlertNotice)
                          ? SizedBox()
                          : Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(color: Colors.red),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ActionButton(
                                    label: "مشاهده",
                                    icon: Icons.remove_red_eye_outlined,
                                    height: 30,
                                    onPress: () {
                                      Navigator.pushNamed(
                                              context, NoticeScreen.id)
                                          .then((value) {
                                        setState(() {});
                                      });
                                    },
                                  ),
                                  CText(
                                    "اطلاع رسانی جدید!",
                                    color: Colors.white,
                                    textDirection: TextDirection.rtl,
                                  )
                                      .animate()
                                      .fade(duration: Duration(seconds: 1)),
                                  Lottie.asset(
                                      "assets/animations/notification.json"),
                                  IconButton(
                                    color: Colors.white60,
                                      onPressed: () {
                                        showAlertNotice = false;
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.close_rounded))
                                ],
                              ),
                            ),
                    ),
                    ///search bar
                    Container(
                      alignment: Alignment.center,
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
                          final productList =
                              box.values.toList().cast<WareHive>();
                          waresList = productList;
                          List<WareHive> filteredList = WareTools.filterList(
                              productList, keyWord, sortItem,selectedDropListGroup);
                          if (filteredList.isEmpty) {
                            return Expanded(
                              child: const EmptyHolder(
                                text:" کالایی یافت نشد!" ,
                                color: Colors.white60,
                                icon: FontAwesomeIcons.boxOpen,
                              ),
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
    bool isMobile=screenType(context)==ScreenType.mobile;
    return WillPopScope(
      //if action bottom bar is shown,on will pop first close the action bar then on the second press close the screen
      onWillPop: selectedItems.isEmpty
          ? null
          : () async {
              selectedItems.clear();
              setState(() {});
              return false;
            },
      child: Consumer<WareProvider>(builder: (context, wareProvider, child) {
        return Expanded(
          child: LayoutBuilder(
            builder: (context,constraint) {
              return Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(!isMobile)
                          Flexible(
                            child: SizedBox(
                              width: 400,
                              child:selectedWare==null? null: InfoPanelDesktop(
                                  context: context,
                                  wareInfo: selectedWare!,
                                  onReload:(){
                                    selectedWare=null;
                                    setState(() {});}),
                            ),
                          ),
                        Flexible(
                          child: SizedBox(
                            width: 550,
                            child: Stack(
                              children: [
                                ListView.builder(
                                    itemCount: widget.wareList.length,
                                    itemBuilder: (context, index) {
                                      WareHive ware = widget.wareList[index];
                                        return InkWell(
                                          onLongPress: () {
                                            if (!selectedItems.contains(index)) {
                                              selectedItems.add(index);
                                              setState(() {});
                                            }
                                          },
                                          onTap: () {
                                            if (selectedItems.isEmpty) {
                                              if (widget.key != null) {
                                                Navigator.pop(context, ware);
                                              } else {
                                                selectedWare=ware;
                                                setState(() {});
                                                !isMobile?null:showDialog(
                                                    context: context,
                                                    builder: (context) => InfoPanel(
                                                        context: context,
                                                        wareInfo: ware));
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
                                          child:  CustomTile(
                                            selected: selectedItems.contains(index),
                                            height: 50,
                                            color: selectedWare?.wareID==widget.wareList[index].wareID?kSecondaryColor:kMainColor,
                                            surfaceColor: selectedWare?.wareID==widget.wareList[index].wareID?kSecondaryColor:null,
                                            leadingIcon: CupertinoIcons.cube_box_fill,
                                            subTitle: ware.groupName,
                                            type: "${index+1}".toPersianDigit(),
                                            title: ware.wareName,
                                            topTrailing: wareProvider.showQuantity
                                                ? ("${ware.quantity}  ".toPersianDigit() +
                                                ware.unit)
                                                : "",
                                            topTrailingLabel:
                                            wareProvider.showQuantity ? "موجودی:" : "",
                                            trailing: addSeparator(ware.sale),
                                            trailingLabel: "فروش:",
                                            middle: wareProvider.showCostPrice
                                                ? addSeparator(ware.cost)
                                                : null,
                                            middleLabel:
                                            wareProvider.showCostPrice ? "خرید:" : null,
                                          ),
                                        );
                                    }),
                                ///selected items action bottom bar
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: EdgeInsets.all(8),
                                    decoration:  BoxDecoration(
                                        border: Border.all(color: Colors.black87),
                                      borderRadius: BorderRadius.circular(20)
                                    ),
                                    height: selectedItems.isNotEmpty ? 50 : 0,
                                    width: double.maxFinite,
                                    child: BlurryContainer(
                                      padding: EdgeInsets.zero,
                                      child: Row(
                                        children: [
                                          ///close icon
                                          CustomIconButton(
                                            margin: EdgeInsets.symmetric(horizontal: 3),
                                            showShadow: true,
                                            onPress: () {
                                              selectedItems.clear();
                                              setState(() {});
                                            },
                                            icon:
                                            CupertinoIcons.multiply_circle,
                                            iconSize: 25,
                                            iconColor: Colors.black,
                                          ),
                                          Text(selectedItems.length.toString().toPersianDigit()),
                                          const VerticalDivider(),
                                          ///delete icon
                                          CustomIconButton(
                                            margin: EdgeInsets.symmetric(horizontal: 3),
                                            showShadow: true,
                                              onPress: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => CustomAlert(
                                                        title:
                                                            "آیا از حذف موارد انتخاب شده مطمئن هستید؟",
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
                                                        }));
                                              },
                                              icon:
                                                Icons.delete_forever,
                                                iconSize: 35,
                                                iconColor: Colors.red,
                                              ),
                                          ///print icon
                                          CustomIconButton(
                                            margin: EdgeInsets.symmetric(horizontal: 3),
                                            showShadow: true,
                                              onPress: () async {
                                                List<WareHive> selectedList = [];
                                                for (int item in selectedItems) {
                                                  selectedList.add(widget.wareList[item]);
                                                }
                                                    showDialog(context: context, builder: (context)=>PrintPanel(wares: selectedList, subGroup: "selected"));
                                              },
                                              icon:
                                                CupertinoIcons.printer_fill,
                                                iconSize: 29,
                                                iconColor: Colors.black87,
                                              ),


                                          ///edit selected icon
                                          CustomIconButton(
                                            margin: EdgeInsets.symmetric(horizontal: 3),
                                            icon: FontAwesomeIcons.filePen,
                                            iconSize: 25,
                                            iconColor: Colors.black87,
                                              onPress: () {
                                                List<WareHive> selectedList = [];
                                                for (int item in selectedItems) {
                                                  selectedList.add(widget.wareList[item]);
                                                }
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => WareActionsPanel(
                                                      subGroup: "selected",
                                                        wares: selectedList));
                                              },

                                              ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        );
      }),
    );

  }
}
