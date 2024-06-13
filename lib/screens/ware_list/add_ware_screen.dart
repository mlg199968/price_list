import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:price_list/components/action_button.dart';
import 'package:price_list/components/counter_textfield.dart';
import 'package:price_list/components/custom_float_action_button.dart';
import 'package:price_list/components/custom_icon_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/components/drop_list_model.dart';
import 'package:price_list/components/hide_keyboard.dart';
import 'package:price_list/components/ware_suggestion_textfield.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/screens/ware_list/services/barcode_scanner.dart';
import '../../components/custom_text.dart';
import '../../components/price_textfield.dart';
import '../../constants/consts_class.dart';
import 'package:price_list/constants/enums.dart';
import 'package:price_list/constants/error_handler.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/screens/ware_list/widgets/item_image_holder.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/screens/ware_list/panels/create_group_panel.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddWareScreen extends StatefulWidget {
  static const String id = "/addWareScreen";
  const AddWareScreen({Key? key, this.oldWare}) : super(key: key);

  final Ware? oldWare;
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
  TextEditingController sale2PriceController = TextEditingController();
  TextEditingController sale3PriceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  String unitItem = kUnitList[0];
  String? imagePath;
  late List<Ware> wareList;
  bool repeatName = false;
  bool repeatSerial = false;

  int _saleIndex = 0;


  void saveWare({String? id}) async {
    Ware wareHive = Ware()
      ..wareName = wareNameController.text
      ..wareSerial = wareSerialController.text
      ..unit = unitItem
      ..groupName =
          Provider.of<WareProvider>(context, listen: false).selectedGroup
      ..cost = stringToDouble(costPriceController.text)
      ..sale = stringToDouble(salePriceController.text)
      ..sale2 = stringToDouble(sale2PriceController.text)
      ..sale3 = stringToDouble(sale3PriceController.text)
      ..discount = stringToDouble(discountController.text)
      ..saleIndex=_saleIndex
      ..quantity = quantityController.text.isEmpty
          ? 1000
          : stringToDouble(quantityController.text)
      ..description =
          descriptionController.text.isEmpty ? "" : descriptionController.text
      ..wareID = id ?? const Uuid().v1()
      ..date = id != null ? widget.oldWare!.date : DateTime.now()
      ..modifyDate = DateTime.now()
      ..imagePath = id == null ? null : widget.oldWare!.imagePath;
    // save image if exist
    if (imagePath != wareHive.imagePath) {
      final String newPath = await Address.waresImage();
      wareHive.imagePath =
          await saveImage(imagePath, wareHive.wareID!, newPath);
    }
    HiveBoxes.getWares().put(wareHive.wareID, wareHive);
    showSnackBar(context, "کالا با موفقیت ذخیره شد", type: SnackType.success);
  }

  void replaceOldWare() {
    try {
      wareNameController.text = widget.oldWare!.wareName;
      wareSerialController.text = widget.oldWare!.wareSerial!;
      costPriceController.text = addSeparator(widget.oldWare!.cost);
      salePriceController.text = addSeparator(widget.oldWare!.sale);
      sale2PriceController.text = widget.oldWare!.sale2 != null
          ? addSeparator(widget.oldWare!.sale2!)
          : "";
      sale3PriceController.text = widget.oldWare!.sale3 != null
          ? addSeparator(widget.oldWare!.sale3!)
          : "";
      discountController.text= widget.oldWare!.discount != null
          ? addSeparator(widget.oldWare!.discount!)
          : "";
      _saleIndex=widget.oldWare!.saleIndex ?? 0;
      quantityController.text = widget.oldWare!.quantity.toString();
      descriptionController.text = widget.oldWare!.description;
      Provider.of<WareProvider>(context, listen: false).selectedGroup =
          widget.oldWare!.groupName;
      unitItem = widget.oldWare!.unit;
      imagePath = widget.oldWare!.imagePath;
    } catch (e) {
      ErrorHandler.errorManger(context, e,
          title: "AddWareScreen replaceOldWare function error ");
    }
  }

  @override
  void initState() {
    Provider.of<WareProvider>(context, listen: false).loadGroupList();
    wareList = HiveBoxes.getWares().values.toList();
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
    sale2PriceController.dispose();
    sale3PriceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    discountController.dispose();
    super.dispose();
  }
  ///change Radio button function
  void _handleRadioChange(int? value) {
    _saleIndex = value ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String selectedPrice=_saleIndex==0
        ?salePriceController.text
        :(
        _saleIndex==1
        ?sale2PriceController.text
        :sale3PriceController.text
    );
    String finalPrice=selectedPrice==""
        ?"0"
        :addSeparator(stringToDouble(selectedPrice)-(stringToDouble(selectedPrice)*stringToDouble(discountController.text)/100));
    final bool isMobileSize = screenType(context) == ScreenType.mobile;
    return HideKeyboard(
      child: Scaffold(
        floatingActionButtonLocation:
            isMobileSize ? null : FloatingActionButtonLocation.centerFloat,
        floatingActionButton: CustomFloatActionButton(
            iconSize: 35,
            label: widget.oldWare != null ? "ذخیره تغییرات" : "افزودن به لیست",
            icon: Icons.save,
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  wareNameController.text.isNotEmpty) {
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
              } else {
                showSnackBar(context, "نام کالا وارد نشده است!",
                    type: SnackType.error);
              }
            }),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.oldWare == null ? "افزودن کالا" : "ویرایش کالا"),
        ),
        body: Consumer<WareProvider>(builder: (context, wareProvider, child) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: kMainGradiant,
            ),
            child: Container(
              width: 550,
              margin: isMobileSize
                  ? EdgeInsets.all(5).copyWith(top: 60)
                  : EdgeInsetsDirectional.symmetric(
                          horizontal: 10, vertical: 30)
                      .copyWith(top: 60),
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                gradient: kBlackWhiteGradiant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        ///image holder behind
                        Container(
                          margin: EdgeInsets.only(top: 150),
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: kMainGradiant,
                          ),
                        ),

                        ///
                        Padding(
                          padding: const EdgeInsets.all(20).copyWith(top: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ///photo part
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Container(
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
                              ),
                              const Gap(20),

                              ///select group dropdown list and add group
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ActionButton(
                                      height: 30,
                                      label: "افزودن گروه",
                                      borderRadius: 5,
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
                              const Gap(20),

                              ///ware name textfield
                              WareSuggestionTextField(
                                label: "نام کالا",
                                maxLength: 50,
                                //focus: wareNameFocus,
                                controller: wareNameController,
                                onSuggestionSelected: (val) {
                                  wareNameController.text = val.wareName;
                                  unitItem = val.unit;
                                  repeatName = wareList
                                      .map((e) => e.wareName)
                                      .contains(val.wareName);
                                  setState(() {});
                                },
                                onChange: (val) {
                                  print(val);
                                  repeatName = (widget.oldWare != null &&
                                              widget.oldWare!.wareName ==
                                                  val) ||
                                          val == ""
                                      ? false
                                      : wareList
                                          .map((e) => e.wareName)
                                          .contains(val);
                                  setState(() {});
                                },
                              ),
                              if (repeatName)
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CText(
                                    "کالایی با این نام قبلا ثبت شده است",
                                    color: Colors.red,
                                    fontSize: 10,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              const Gap(20),

                              ///serial
                              CustomTextField(
                                label: "شماره سریال کالا",
                                maxLength: 25,
                                controller: wareSerialController,
                                onChange: (val) {
                                  print(val);
                                  repeatSerial = (widget.oldWare != null &&
                                              widget.oldWare!.wareSerial ==
                                                  val) ||
                                          val == ""
                                      ? false
                                      : wareList
                                          .map((e) => e.wareSerial)
                                          .contains(val);
                                  setState(() {});
                                },
                                suffixIcon: Platform.isAndroid || Platform.isIOS
                                    ? CustomIconButton(
                                        icon: Icons.qr_code_scanner_rounded,
                                        iconSize: 25,
                                        onPress: () {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BarcodeScannerScreen()))
                                              .then((value) {
                                            wareSerialController.text = value;
                                            setState(() {});
                                          });
                                        },
                                      )
                                    : null,
                              ),
                              if (repeatSerial)
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: CText(
                                    "کالایی با این شماره سریال قبلا ثبت شده است",
                                    color: Colors.red,
                                    fontSize: 10,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              const Gap(20),

                              ///unit dropdown list selection
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: DropListModel(
                                      selectedValue: unitItem,
                                      listItem: kUnitList,
                                      onChanged: (val) {
                                        unitItem = val;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const Gap(20),
                                  CounterTextfield(
                                    label: "مقدار",
                                    maxNum: 99999999,
                                    controller: quantityController,
                                  ),
                                ],
                              ),
                              const Gap(20),
                              ///cost price
                              PriceTextField(
                                label: "قیمت خرید",
                                controller: costPriceController,
                                onChange: (val) {
                                  setState(() {});
                                },
                              ),
                              const Gap(20),
                              ///sale textfield
                              PriceTextField(
                                label: "قیمت فروش",
                                controller: salePriceController,
                                onChange: (val) {
                                  setState(() {});
                                },
                                prefixWidget: Radio(value: 0, groupValue: _saleIndex, onChanged: _handleRadioChange),
                              ),
                              const Gap(10),
                              ///sale2 textfield
                              PriceTextField(
                                label: "قیمت فروش 2",
                                controller: sale2PriceController,
                                onChange: (val) {
                                  setState(() {});
                                },
                                prefixWidget: Radio(value: 1, groupValue: _saleIndex, onChanged: _handleRadioChange),
                              ),
                              const Gap(10),
                              ///sale3 textfield
                              PriceTextField(
                                label: "قیمت فروش 3",
                                controller: sale3PriceController,
                                onChange: (val) {
                                  setState(() {});
                                },
                                prefixWidget: Radio(value: 2, groupValue: _saleIndex, onChanged: _handleRadioChange),
                              ),
                              const Gap(20),
                              ///unit dropdown list selection
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CounterTextfield(
                                    label: "درصد %",
                                    maxNum: 100,
                                    controller: discountController,
                                    onChange: (val){setState(() {});},
                                  ),
                                  const Gap(20),
                                  Flexible(
                                    child: CText("درصد تخفیف"),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(gradient: kMainGradiant),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CText(finalPrice,color: Colors.white,fontSize: 15,),
                                    CText("قیمت فروش نهایی: ",color: Colors.white54,textDirection: TextDirection.rtl,),
                                  ],
                                ),
                              ),
                              ///description textfield
                              CustomTextField(
                                label: "توضیحات",
                                maxLength: 200,
                                controller: descriptionController,
                                maxLine: 5,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
