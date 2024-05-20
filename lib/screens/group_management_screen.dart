import 'package:flutter/material.dart';
import 'package:price_list/components/custom_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/constants/constants.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/services/hive_boxes.dart';
import 'package:price_list/model/ware.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';

class GroupManagementScreen extends StatefulWidget {
  static const String id = "/groupManagementScreen";

  const GroupManagementScreen({Key? key}) : super(key: key);

  @override
  State<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  late WareProvider wareProvider;

  @override
  void initState() {
    wareProvider = Provider.of<WareProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: kMainGradiant),
        child: Container(
          width: 350,
          margin: EdgeInsets.only(top: 50,bottom: 20),
          alignment: Alignment.center,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(child: Text("مدیریت گروه ها",style: TextStyle(fontSize: 20,color: Colors.white),)),
                Divider(),
                Flexible(
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20)),
                    child: ListView.builder(
                        itemCount: wareProvider.groupList.length,
                        itemBuilder: (context, index) {
                          List groups = wareProvider.groupList;
                          return SizedBox(
                            height: 50,
                            child: MaterialButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => GroupManagePanel(
                                        oldName: groups[index])).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Card(
                                elevation: 5,
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(groups[index],style: TextStyle(color: Colors.black54),),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GroupManagePanel extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  GroupManagePanel({super.key, required this.oldName});

  final String oldName;
  final groupTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'ویرایش گروه',
      child: Consumer<WareProvider>(

        builder: (context,provider,child) {
          return Container(
            padding: const EdgeInsetsDirectional.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("نام فعلی گروه : $oldName"),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CustomTextField(
                      label: "نام جدید",
                      controller: groupTextController,
                      validate: true,
                      maxLength: 30,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  CustomButton(
                      text: "تغییر",
                      width: MediaQuery.of(context).size.width,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          for (var element in provider.groupList) {
                            if (element == groupTextController.text) {
                              provider.updateSelectedGroup(element);
                              showSnackBar(
                                  context, "نام گروه انتخاب شده قبلا افزوده شده");
                            }
                          }
                          List<Ware> wares =
                              HiveBoxes.getWares().values.toList();
                          for (Ware ware in wares) {
                            if (oldName == ware.groupName) {
                              ware.groupName = groupTextController.text;
                            }
                            HiveBoxes.getWares().put(ware.wareID, ware);
                          }
                          provider.addGroup(groupTextController.text);
                          provider.groupList.remove(oldName);
                          provider.updateSelectedGroup(groupTextController.text);
                          Navigator.pop(context, false);
                          groupTextController.clear();
                        }
                      })
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
