import 'package:flutter/material.dart';
import 'package:price_list/add_ware/panels/create_group_panel.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/data/hive_boxes.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/ware_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddWareScreen extends StatefulWidget {
  static const String id = "/addWareScreen";
  const AddWareScreen({Key? key, this.oldWare}) : super(key: key);

  final WareHive? oldWare;
  @override
  State<AddWareScreen> createState() => _AddWareScreenState();
}

class _AddWareScreenState extends State<AddWareScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController wareNameController = TextEditingController();
  TextEditingController wareSerialController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String unitItem = kUnitList[0];

  void addWare() {
    WareHive wareHive = WareHive()
      ..wareName = wareNameController.text
      ..unit = unitItem
      ..groupName =
          Provider.of<WareProvider>(context, listen: false).selectedGroup
      ..cost = costPriceController.text.isEmpty
          ? 0
          : stringToDouble(costPriceController.text)
      ..sale = salePriceController.text.isEmpty
          ? 0
          : stringToDouble(salePriceController.text)
      ..quantity = quantityController.text.isEmpty
          ? 1000
          : stringToDouble(quantityController.text)
      ..description =
          descriptionController.text.isEmpty ? "" : descriptionController.text
      ..wareID = const Uuid().v1()
      ..date = DateTime.now()
      ..modifyDate = DateTime.now();
    //Debuger.maxWare(wareHive, 50);
    HiveBoxes.getWares().put(wareHive.wareID,wareHive);
  }
  void updateWare() {
    WareHive wareHive = WareHive()
      ..wareName = wareNameController.text
      ..unit = unitItem
      ..groupName =
          Provider.of<WareProvider>(context, listen: false).selectedGroup
      ..cost = costPriceController.text.isEmpty
          ? 0
          : stringToDouble(costPriceController.text)
      ..sale = salePriceController.text.isEmpty
          ? 0
          : stringToDouble(salePriceController.text)
      ..quantity = quantityController.text.isEmpty
          ? 1000
          : stringToDouble(quantityController.text)
      ..description =
          descriptionController.text.isEmpty ? "" : descriptionController.text
      ..wareID =widget.oldWare!.wareID
      ..date = widget.oldWare!.modifyDate ?? DateTime.now()
      ..modifyDate = DateTime.now();
    HiveBoxes.getWares().put(widget.oldWare!.wareID,wareHive);
  }

  void replaceOldWare() {
    wareNameController.text = widget.oldWare!.wareName;
    costPriceController.text = addSeparator(widget.oldWare!.cost);
    salePriceController.text = addSeparator(widget.oldWare!.sale);
    quantityController.text = widget.oldWare!.quantity.toString();
    descriptionController.text = widget.oldWare!.description;
    Provider.of<WareProvider>(context, listen: false).selectedGroup=widget.oldWare!.groupName;
    unitItem=widget.oldWare!.unit;
  }
  @override
  void initState() {
    if(widget.oldWare!=null){
      replaceOldWare();
    }
    super.initState();

  }

  @override
  void dispose() {
    wareNameController.dispose();
    wareSerialController.dispose();
    costPriceController.dispose();
    salePriceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void updateUINotifier(value) {
    Provider.of<WareProvider>(context, listen: false).selectedGroup = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final wareProvider = Provider.of<WareProvider>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kGradiantColor1),
        ),
        title: const Text("افزودن کالا"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //TODO:select group dropdown list and add group
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton(
                          height: 40,
                            text: "افزودن گروه",
                            onPressed: () {
                              showDialog(
                                      context: context,
                                      builder: (context) => CreateGroupPanel())
                                  .then((value) {
                                if (value != null) {
                                  updateUINotifier(value);
                                }
                              });
                            }),
                        DropListModel(
                          selectedValue: wareProvider.selectedGroup,
                          listItem: wareProvider.groupList,
                          onChanged: (value) {
                            wareProvider.updateSelectedGroup(value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: kSpaceBetween,
                    ),
                    CustomTextField(
                      label: "نام کالا",
                      maxLength: 50,
                      controller: wareNameController,
                      validate: true,
                    ),
                    const SizedBox(
                      height: kSpaceBetween,
                    ),
                    CustomTextField(
                      label: "شماره سریال کالا",
                      maxLength: 25,
                      controller: wareSerialController,
                    ),
                    const SizedBox(
                      height: kSpaceBetween,
                    ),
                    //TODO:unit dropdown list selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropListModel(
                          selectedValue: unitItem,
                          listItem: kUnitList,
                          onChanged: (val) {
                            unitItem = val;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          width: kSpaceBetween,
                        ),
                        CustomTextField(
                          label: "مقدار",
                          maxLength: 15,
                          controller: quantityController,
                          textFormat: TextFormatter.number,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: kSpaceBetween,
                    ),
                    CustomTextField(
                      label: "قیمت خرید",
                      maxLength: 17,
                      controller: costPriceController,
                      textFormat: TextFormatter.price,
                    ),
                    const SizedBox(
                      height: kSpaceBetween,
                    ),
                    CustomTextField(
                      label: "قیمت فروش",
                      maxLength: 17,
                      controller: salePriceController,
                      textFormat: TextFormatter.price,
                    ),
                    const SizedBox(
                      height: kSpaceBetween,
                    ),
                    CustomTextField(
                      label: "توضیحات",
                      maxLength:200,
                      controller: descriptionController,
                      maxLine: 5,
                    ),
                  ],
                ),
              ),
              CustomButton(
                  text: "افزودن به لیست",
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if(widget.oldWare!=null){
                        updateWare();
                      }
                      else {
                        addWare();
                      }
                      Navigator.pop(context);
                    }

                    setState(() {});
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
