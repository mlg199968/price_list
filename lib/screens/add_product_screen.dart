import 'package:flutter/material.dart';
import 'package:price_list/constants.dart';
import 'package:price_list/parts/create_group_panel.dart';
import 'package:price_list/parts/final_list.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    as formatter;
import 'package:price_list/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'dart:math';
import 'package:price_list/data/data_price_store.dart';
import 'package:price_list/data/notes_database.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen(this.infoPanelData);
  final List infoPanelData;
  static const String id = "addProductScreen";

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController buyPriceController = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  String unitItem = myUnitList[0];

  int randomId() {
    var random = Random();
    int randNumber = 100000 + random.nextInt(999999);
    return randNumber;
  }

  updateUI() {
    setState(() {
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.infoPanelData.length!=0)
    return dataForEdit();


  }
  late String editedItemId='nothing';
  void dataForEdit(){
    print(widget.infoPanelData.length);
    setState(() {
      productNameController.text=widget.infoPanelData[0];
      sellPriceController.text=widget.infoPanelData[2];
      buyPriceController.text=widget.infoPanelData[3];
      unitItem=widget.infoPanelData[1];
      Provider.of<FinalList>(context,listen: false).groupDropListValue=widget.infoPanelData[4];
      editedItemId=widget.infoPanelData[5];
    });
  }

@override
  void dispose() {
  productNameController;
  buyPriceController ;
  sellPriceController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final dataProduct = Provider.of<FinalList>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:

        Container(
          decoration: const BoxDecoration(gradient: kGradiantColor1),
          child: Container(


            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(70),topLeft: Radius.circular(70)),

            ),
            margin: const EdgeInsets.only(top: 100),
            padding: const EdgeInsets.all(20).copyWith(bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      //TODO:group Product TextField
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          TextButtonTheme(
                            data: kButtonStyle,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CreateGroupPanel(updateUI);
                                    });
                              },
                              child: const Text(
                                'گروه جدید',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          //TODO: Dropdown List Group Selection
                         DropListModel(
                              listItem: dataProduct.groupList,
                              onChanged: (value) {
                                setState(
                                  () => Provider.of<FinalList>(context, listen: false)
                                      .groupDropListValueUpdate(value.toString()),
                                );
                              },
                              selectedValue: dataProduct.groupDropListValue,
                            ),

                        ]),
                      ),
                      //TODO:Product Name TextField
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Text(
                                'نام محصول',
                                style: kHeaderStyle,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: productNameController,
                                maxLength: 25,
                                onChanged: (value){
                                  setState(() {
                                  });
                                },
                                textAlign: TextAlign.center,
                                decoration: kInputDecoration,
                              ),
                            ]),
                      ),
                      //TODO:unit dropDownMenu
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                          StatefulBuilder(builder: (context, StateSetter setState) {
                            return DropListModel(
                                listItem: myUnitList,
                                onChanged: (value) {
                                  setState(() => unitItem = value);
                                },
                                selectedValue: unitItem);
                          }),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            'واحد',
                            style: kHeaderStyle,
                          ),
                        ]),
                      ),
                      //TODO:Cost Price TextField
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Text(
                                'قیمت خرید',
                                style: kHeaderStyle,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: buyPriceController,
                                maxLength:17 ,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration:
                                    kInputDecoration.copyWith(hintText: 'قیمت خرید'),
                                inputFormatters: [
                                  formatter.CurrencyTextInputFormatter(
                                    symbol: "ريال",
                                    decimalDigits: 0,

                                  )
                                ],
                              ),
                            ]),
                      ),
                      //TODO:Sale Price TextField
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const Text(
                                'قیمت فروش',
                                style: kHeaderStyle,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: sellPriceController,
                                maxLength:17,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration:
                                    kInputDecoration.copyWith(hintText: 'قیمت فروش'),
                                inputFormatters: [
                                  formatter.CurrencyTextInputFormatter(
                                    symbol: "ريال",
                                    decimalDigits: 0,
                                  )
                                ],
                              ),
                            ]),
                      ),
                      //TODO: add button section
                      const SizedBox(height: 30,),

                    ],
                  ),
                ),
                TextButtonTheme(
                  data: kButtonStyle,
                  child: TextButton(
                    onPressed: productNameController.text == '' || dataProduct.groupDropListValue=='همه'
                        ? null
                        : () async{
                      Note insertAllUserData = Note(
                        productName: productNameController.text,
                        unit: unitItem,
                        costPrice: sellPriceController.text,
                        salePrice: buyPriceController.text,
                        groupName: dataProduct.groupDropListValue,
                        id: '${randomId()}',

                      );
                      NotesDatabase.instance
                          .create(insertAllUserData, dataTable);



                      productNameController.clear();
                      sellPriceController.clear();
                      buyPriceController.clear();
                      setState(() {
                      });

                      if (editedItemId!='nothing') {
                        NotesDatabase.instance.delete(editedItemId);
                        Navigator.pushNamed(context,MainScreen.id);
                      }
                    },
                    child: const Text(
                      'افزودن به لیست',
                      style: kHeaderStyle,
                    ),
                  ),
                ),
                const SizedBox(height: 15,)
              ],
            ),
          ),
        ),
    );
  }
}
