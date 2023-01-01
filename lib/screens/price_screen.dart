import 'package:flutter/material.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/constants.dart';
import 'package:price_list/parts/final_list.dart';
import 'package:provider/provider.dart';
import 'package:price_list/parts/price_list_builder.dart';
import 'package:price_list/data/notes_database.dart';
import 'package:price_list/parts/sidebar_panel.dart';




class PriceScreen extends StatefulWidget {
  static const String id = "priceScreen";


  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  GlobalKey<ScaffoldState> scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStorageData();
    getGroupList();
  }
  priceScreenUpdateUI() {
    setState(() {});
  }


  void getStorageData() async {
    Provider.of<FinalList>(context, listen: false).dataList =
        await NotesDatabase.instance.readAllNote();
    setState(() {});
  }

  void getGroupList() async {
    Provider.of<FinalList>(context, listen: false).groupList =
        await NotesDatabase.instance.readAllGroupList();
    Provider.of<FinalList>(context, listen: false).groupList.insert(0, 'همه');
  }

  bool isOpenSidebar=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer:const SideBarPanel(),


      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){

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
                    //TODO:dropDown list for Group Select
                    Consumer<FinalList>(
                      builder: (context, dataProduct, child) {
                        return DropListModel(
                          listItem: dataProduct.groupList,
                          onChanged: (value) {
                            setState(() {
                              dataProduct.selectedGroup = value.toString();
                            });
                          },
                          selectedValue: dataProduct.selectedGroup,
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
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            children: <Widget>[
              //TODO:Price List Header
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(gradient: kGradiantColor1),
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    Text(
                      'قیمت فروش',
                      style: kHeaderStyle.copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Text(
                      'واحد',
                      style: kHeaderStyle.copyWith(color: Colors.white),
                    ),
                    const SizedBox(
                      width: 90,
                    ),
                    Text(
                      'نام محصول',
                      style: kHeaderStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              PriceListBuilder(),
            ],
          ),
        ),
      ),
    );
  }
}



