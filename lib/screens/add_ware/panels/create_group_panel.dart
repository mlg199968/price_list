import 'package:flutter/material.dart';
import 'package:price_list/components/custom_alert_dialog.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';
import 'package:price_list/providers/ware_provider.dart';
import 'package:provider/provider.dart';

class CreateGroupPanel extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  CreateGroupPanel({super.key});
  final groupPanelTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'افزودن گروه جدید',
      child: Consumer<WareProvider>(
        builder: (context,wareProvider,child) {
          return Container(
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
                              extraValidate: (val){
                                for (var element in wareProvider.groupList) {
                                  if (element == groupPanelTextFieldController.text) {
                                    return "نام انتخاب شده تکراری می باشد";
                                  }
                                }
                              },
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
                            wareProvider.addGroup(groupPanelTextFieldController.text);
                            wareProvider.updateSelectedGroup(
                                groupPanelTextFieldController.text);
                            Navigator.pop(context);
                            groupPanelTextFieldController.clear();
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
