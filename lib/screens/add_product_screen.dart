import 'package:flutter/material.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/constants.dart';
import 'package:price_list/parts/create_group_panel.dart';
import 'package:price_list/parts/final_list.dart';
import 'package:provider/provider.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'dart:math';
import 'package:price_list/data/product.dart';
import 'package:price_list/data/product_database.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({this.oldProduct});
  final Product? oldProduct;
  static const String id = "addProductScreen";

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey=GlobalKey<FormState>();
  late FinalList provider;
  TextEditingController productNameController = TextEditingController();
  TextEditingController buyPriceController = TextEditingController();
  TextEditingController sellPriceController = TextEditingController();
  String unitItem = myUnitList[0];
  String? selectedGroup;

  int randomId() {
    var random = Random();
    int randNumber = 100000 + random.nextInt(999999);
    return randNumber;
  }

  updateUI() {
    setState(() {});
  }

  @override
  void initState() {
    dataForEdit();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    provider = Provider.of<FinalList>(context, listen: false);
    super.didChangeDependencies();
  }

  void dataForEdit() {
    if (widget.oldProduct != null) {
      productNameController.text = widget.oldProduct!.productName;
      sellPriceController.text = widget.oldProduct!.salePrice;
      buyPriceController.text = widget.oldProduct!.costPrice;
      unitItem = widget.oldProduct!.unit;
      selectedGroup=widget.oldProduct!.groupName;
    }
  }

  @override
  void dispose() {
    productNameController.dispose();
    buyPriceController.dispose();
    sellPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(gradient: kGradiantColor1),
        child: Container(
          decoration:  BoxDecoration(
            color: Colors.white.withOpacity(.95),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(70), topLeft: Radius.circular(70)),
          ),
          margin: const EdgeInsets.only(top: 100),
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      //TODO:group Product TextField
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomButton(
                                height: 40,
                                text:'گروه جدید',
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CreateGroupPanel();
                                      }).then((value) {
                                    provider.addToGroupList([value]);
                                        selectedGroup=value;
                                    setState(() {});
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              //TODO: Dropdown List Group Selection
                              DropListModel(
                                listItem: provider.groupList.isEmpty?["گروه 1",...provider.groupList] :provider.groupList,
                                onChanged: (value) {

                                  selectedGroup=value.toString();
                                  setState(() {});
                                },
                                selectedValue: provider.groupList.isEmpty? selectedGroup="گروه 1":(selectedGroup ?? provider.groupList.first),
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
                              CustomTextField(
                                validate: true,
                                width: double.maxFinite,
                                label: 'نام کالا',
                                controller: productNameController,
                                maxLength: 25,

                              ),
                            ]),
                      ),
                      //TODO:unit dropDownMenu
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              StatefulBuilder(
                                  builder: (context, StateSetter setState) {
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
                      ///Cost Price TextField
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextField(
                                width: double.maxFinite,
                                label: 'قیمت خرید',
                                controller: buyPriceController,
                                maxLength: 17,
                                textFormat: TextFormatter.price,

                              ),
                            ]),
                      ),
                      ///Sale Price TextField
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
                              CustomTextField(
                                width: double.maxFinite,
                                label: 'قیمت فروش',
                                controller: sellPriceController,
                                maxLength: 17,
                                textFormat: TextFormatter.price,

                              ),
                            ]),
                      ),
                      //TODO: add button section
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  width: double.maxFinite,
                  text:'افزودن به لیست' ,
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      Product product = Product(
                        productName: productNameController.text,
                        unit: unitItem,
                        costPrice: buyPriceController.text,
                        salePrice: sellPriceController.text,
                        groupName: selectedGroup!,
                        id: widget.oldProduct != null
                            ? widget.oldProduct!.id
                            : '${randomId()}',
                      );
                      if (widget.oldProduct != null) {
                        ProductsDatabase.instance.update(product);
                        Navigator.pop(context, false);
                      } else {
                        ProductsDatabase.instance.create(product, dataTable);
                      }
                      Navigator.pop(context, false);
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
