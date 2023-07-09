import 'package:flutter/material.dart';
import 'package:price_list/components/custom_alert_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/constants/utils.dart';
import 'package:price_list/ware_provider.dart';
import 'package:provider/provider.dart';

class CreateGroupPanel extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  CreateGroupPanel({super.key});
  final groupPanelTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WareProvider>(context, listen: false);
    return CustomAlertDialog(
      context: context,
      title: 'افزودن گروه جدید',
      height: 250,
      child: Container(
          padding: const EdgeInsetsDirectional.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CustomTextField(
                          label: "نام گروه",
                          controller: groupPanelTextFieldController,
                          validate: true,
                          maxLength: 20,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ]),
                ),
                CustomButton(
                    text: "افزودن",
                    width: MediaQuery.of(context).size.width,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        for (var element in provider.groupList) {
                          if (element == groupPanelTextFieldController.text) {
                            provider.updateSelectedGroup(element);
                            showSnackBar(context, "نام گروه انتخاب شده قبلا افزوده شده");
                          }
                        }
                        provider.addGroup(groupPanelTextFieldController.text);
                        provider.updateSelectedGroup(
                            groupPanelTextFieldController.text);
                        Navigator.pop(
                            context, groupPanelTextFieldController.text);
                        groupPanelTextFieldController.clear();
                      }
                    })
              ],
            ),
          ),
        ),

    );
  }
}
