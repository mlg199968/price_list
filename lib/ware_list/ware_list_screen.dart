import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:price_list/add_ware/add_ware_screen.dart';
import 'package:price_list/components/custom_search_bar.dart';
import 'package:price_list/components/custom_tile.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/data/hive_boxes.dart';
import 'package:price_list/data/product_database.dart';
import 'package:price_list/model/product.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/parts/sidebar_panel.dart';
import 'package:price_list/ware_list/panels/info_panel.dart';
import 'package:price_list/ware_list/services/ware_tools.dart';
import 'package:price_list/ware_provider.dart';
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
  String selectedDropListGroup = "همه";
  final List<String> sortList = [
    'تاریخ ثبت',
    'حروف الفبا',
    'موجودی کالا',
  ];
  String sortItem = 'حروف الفبا';
  String? keyWord;
  void getStartupData() {
    //get ware group list
    Provider.of<WareProvider>(context, listen: false)
        .loadGroupList(HiveBoxes.getGroupWares());
  }
  void uploadToNewDatabase() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.getBool("isUploaded")==null){
      List<Product> oldList = await ProductsDatabase.instance.readAllProduct();
      oldList.forEach((element) {
        WareHive ware = WareHive()
          ..wareName = element.productName
          ..cost = stringToDouble(element.costPrice)
          ..sale = stringToDouble(element.salePrice)
          ..groupName = element.groupName
          ..unit = element.unit
          ..wareID = element.id;
        HiveBoxes.getWares().put(ware.wareID, ware);
      });
      prefs.setBool("isUploaded", true);
    }else{
    }
  }
  @override
  void initState() {
    uploadToNewDatabase();
    getStartupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add,size: 35,),
          onPressed: () {
        Navigator.pushNamed(context, AddWareScreen.id);
      }),
      drawer:const SideBarPanel(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    child: Image.asset('images/logo.png')),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(gradient: kGradiantColor1),
              ),
              title: Container(
                padding: const EdgeInsets.only(right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Price List"),

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
            content: Text('برای خروج دوباره ضربه بزنید'),),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(gradient: kGradiantColor1),
                  padding: const EdgeInsets.all(10),
                  child: CustomSearchBar(
                    controller: searchController,
                    hint: "جست و جو کالا",
                    onChange: (val) {
                      keyWord=val;
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
                      final waresList = box.values.toList().cast<WareHive>();
                      List filteredList=WareTools.filterList(waresList, keyWord, sortItem);
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
                        wareList: filteredList as List<WareHive>,
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListPart extends StatelessWidget {
  const ListPart({super.key, required this.wareList, required this.category});

  final List<WareHive> wareList;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: wareList.length,
          itemBuilder: (context, index) {
            WareHive ware = wareList[index];
            if (category == wareList[index].groupName) {
              return CustomTile(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (context) =>
                          InfoPanel(context: context, wareInfo: ware));
                },
                enable: false,
                height: 50,
                color: Colors.orange,
                type: ware.groupName,
                title: ware.wareName,
                topTrailing: ("${ware.quantity}  ".toPersianDigit() + ware.unit),
                trailing: addSeparator(ware.sale),
              );
            } else if (category == "همه") {
              return CustomTile(
                onTap:(){
                  showDialog(
                      context: context,
                      builder: (context) =>
                          InfoPanel(context: context, wareInfo: ware));
                } ,
                enable: false,
                height: 50,
                color: Colors.deepPurple,
                leadingIcon: CupertinoIcons.cube_box_fill,
                subTitle: ware.groupName,
                type: "کالا",
                title: ware.wareName,
                topTrailing: ("${ware.quantity}  ".toPersianDigit() + ware.unit),
                topTrailingLabel: "موجودی:",
                trailing: addSeparator(ware.sale),
              );
            }
            return const SizedBox();
          }),
    );
  }
}
