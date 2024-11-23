

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/custom_button.dart';
import '../../../components/custom_dialog.dart';
import '../../../components/custom_textfield.dart';
import '../../../model/ware.dart';
import '../../../providers/ware_provider.dart';
import '../../../services/hive_boxes.dart';

class GroupManagePanel extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  GroupManagePanel({super.key, required this.wares});

  final List<Ware> wares;
 final TextEditingController groupTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    groupTextController.text=wares[0].groupName;
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
                            for (Ware ware in wares) {
                              ware.groupName=groupTextController.text;
                              HiveBoxes.getWares().put(ware.wareID, ware);
                            }
                            provider.loadGroupList();
                            Navigator.pop(context, false);
                            groupTextController.clear();
                          }
                        }),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}