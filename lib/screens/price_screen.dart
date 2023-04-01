import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:price_list/components/custom_search_bar.dart';
import 'package:price_list/components/custom_tile.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/ware_tools.dart';
import 'package:price_list/data/product.dart';
import 'package:price_list/parts/final_list.dart';
import 'package:price_list/parts/info_panel.dart';
import 'package:price_list/screens/add_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:price_list/data/product_database.dart';
import 'package:price_list/parts/sidebar_panel.dart';

class PriceScreen extends StatefulWidget {
  static const String id = "priceScreen";

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  TextEditingController searchController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedDropListGroup = "همه";
  final List<String> sortList = [
    // 'تاریخ ثبت',
    'حروف الفبا',
    // 'موجودی کالا',
  ];
  String sortItem = 'حروف الفبا';
  String? keyWord;
  late FinalList provider;
  List groupList = [];
  String? selectedGroup='همه';
  @override
  void initState() {
    getGroupList();
    super.initState();
  }

  void getGroupList() async {
    groupList.clear();
    groupList = await ProductsDatabase.instance.readAllGroupList();
    provider.groupList.clear();
    provider.addToGroupList(groupList);
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<FinalList>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          child: Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AddProductScreen.id).then((value) {
              getGroupList();
              setState(() {});
            });
          }),
      drawer: const SideBarPanel(),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: Padding(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Price List"),

                    ///dropDown list for Group Select
                    DropListModel(
                      listItem: ["همه", ...provider.groupList],
                      onChanged: (value) {
                        selectedGroup = value.toString();
                        setState(() {});
                      },
                      selectedValue: selectedGroup ?? "همه",
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
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(gradient: kGradiantColor1),
                      child: CustomSearchBar(
                          controller: searchController,
                          hint: "جست و جو کالا ",
                          onChange: (val) {
                            keyWord=val;
                            setState(() {});
                          },
                          selectedSort: sortItem,
                          sortList: sortList,
                          onSort: (val) {
                            sortItem = val;
                            setState(() {});
                          })),
                  Expanded(
                    child: FutureBuilder<List<Product>>(
                        future: ProductsDatabase.instance.readAllProduct(),
                        builder: (context, snap) {
                          getGroupList();
                          if (snap.connectionState == ConnectionState.done) {
                            List<Product> products = snap.data!;

                            List<Product> filteredList =
                                WareTools.filterList(products, keyWord, sortItem);
                            int length = filteredList.length;
                            if(length==0){
                              return Align(alignment:Alignment.center,child: Text("کالایی یافت نشد"),);
                            }
                            return ListView.builder(
                              itemCount: length,
                              itemBuilder: (context, index) {
                                Product product = filteredList[index];
                                if (selectedGroup == "همه") {
                                  return CustomTile(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                InfoPanel(product)).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      title: product.productName,
                                      topTrailing: product.unit,
                                      trailing: product.salePrice);
                                } else if (product.groupName == selectedGroup) {
                                  return CustomTile(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                InfoPanel(product)).then((value) {
                                          setState(() {});
                                        });
                                      },
                                      title: product.productName,
                                      topTrailing: product.unit,
                                      trailing: product.salePrice);
                                } else {
                                  return SizedBox();
                                }
                              },
                            );
                          } else if (snap.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Align(
                              child: Text("no data"),
                              alignment: Alignment.center,
                            );
                          }
                        }),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

// Column(
// children: <Widget>[
// PriceListBuilder(),
// ],
// ),
