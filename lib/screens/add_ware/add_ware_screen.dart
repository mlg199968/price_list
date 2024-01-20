import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/custom_float_action_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/consts_class.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/add_ware/widgets/item_image_holder.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:price_list/model/ware_hive.dart';
import 'package:price_list/screens/add_ware/panels/create_group_panel.dart';
import 'package:price_list/providers/ware_provider.dart';
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
  FocusNode wareNameFocus = FocusNode();
  TextEditingController wareNameController = TextEditingController();
  TextEditingController wareSerialController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String unitItem = kUnitList[0];
  String? imagePath;

  void saveWare({String? id}) async {
    WareHive wareHive = WareHive()
      ..wareName = wareNameController.text
      ..wareSerial = wareSerialController.text
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
      ..wareID = id ?? const Uuid().v1()
      ..date = id!=null ?widget.oldWare!.date:DateTime.now()
      ..modifyDate = DateTime.now()
      ..imagePath = id == null ? null : widget.oldWare!.imagePath;
    // save image if exist
    if (imagePath != wareHive.imagePath) {
      final String newPath = await Address.waresImage();
      wareHive.imagePath =
          await saveImage(imagePath, wareHive.wareID!, newPath);
    }

    //Debuger.maxWare(wareHive, 50);
    HiveBoxes.getWares().put(wareHive.wareID, wareHive);
    showSnackBar(context, "کالا با موفقیت ذخیره شد", type: SnackType.success);
  }

  void replaceOldWare() {
    try {
      wareNameController.text = widget.oldWare!.wareName;
      wareSerialController.text = widget.oldWare!.wareSerial!;
      costPriceController.text = addSeparator(widget.oldWare!.cost);
      salePriceController.text = addSeparator(widget.oldWare!.sale);
      quantityController.text = widget.oldWare!.quantity.toString();
      descriptionController.text = widget.oldWare!.description;
      Provider
          .of<WareProvider>(context, listen: false)
          .selectedGroup =
          widget.oldWare!.groupName;
      unitItem = widget.oldWare!.unit;
      imagePath = widget.oldWare!.imagePath;
    }catch(e){
      ErrorHandler.errorManger(context, e,title: "AddWareScreen replaceOldWare function error ");
    }
  }

  @override
  void initState() {
    Provider.of<WareProvider>(context,listen: false).loadGroupList();
    if (widget.oldWare != null) {
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
    return HideKeyboard(
      child: Scaffold(
        floatingActionButton: CustomFloatActionButton(
            label: widget.oldWare != null ? "ذخیره تغییرات" : "افزودن به لیست",
            icon: Icons.save,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.oldWare != null) {
                  saveWare(id: widget.oldWare!.wareID);
                  Navigator.pop(context, false);
                } else {
                  saveWare();
                  wareNameController.clear();
                  wareSerialController.clear();
                  costPriceController.clear();
                  salePriceController.clear();
                  quantityController.clear();
                  descriptionController.clear();
                  setState(() {});
                }
              }
            }),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.oldWare == null ? "افزودن کالا" : "ویرایش کالا"),
        ),
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(gradient: kBlackWhiteGradiant),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  ///top rounded part
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        gradient: kMainGradiant,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                  ),
                  ///
                  Padding(
                    padding: const EdgeInsets.all(20).copyWith(top: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: AnimateList(
                        interval: 50.ms,
                        effects: [FadeEffect(duration: 300.ms)],
                        children: [
                          ///photo part
                          Container(
                            height: 150,
                            margin: const EdgeInsets.all(5),
                            child: ItemImageHolder(
                              imagePath: imagePath,
                              onSet: (path) {
                                imagePath = path;
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          ///select group dropdown list and add group
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ActionButton(
                                  height: 40,
                                  label: "افزودن گروه",
                                  icon: Icons.category,
                                  onPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            CreateGroupPanel());
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
                            //focus: wareNameFocus,
                            controller: wareNameController,
                            validate: true,
                            extraValidate: (val) {
                              final wareList = HiveBoxes.getWares()
                                  .values
                                  .map((e) => e.wareName)
                                  .toList();
                              if (wareList.contains(val) &&
                                  widget.oldWare == null) {
                                return "کالایی با این نام قبلا ثبت شده است";
                              }
                            },
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

                          ///unit dropdown list selection
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
                            maxLength: 200,
                            controller: descriptionController,
                            maxLine: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
