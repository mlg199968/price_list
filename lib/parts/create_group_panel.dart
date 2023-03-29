import 'package:flutter/material.dart';
import 'package:price_list/components/custom_button.dart';
import 'package:price_list/components/custom_textfield.dart';


// ignore: must_be_immutable
class CreateGroupPanel extends StatelessWidget {
  CreateGroupPanel();
  TextEditingController groupPanelTextfieldController=TextEditingController();

final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions:[
        Container(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CustomTextField(
                          validate: true,
                          width: double.maxFinite,
                          label: 'نام گروه',
                          controller: groupPanelTextfieldController,
                          maxLength: 30,

                        ),
                      ]),
                ),
              ),
              CustomButton(
                width: double.maxFinite,
                  text: 'افزودن گروه',
                  onPressed: () {
                    if(_formKey.currentState!.validate()) {
                      //Provider.of<FinalList>(context,listen: false).addToGroupList(groupPanelTextfieldController.text);
                      Navigator.pop(context, groupPanelTextfieldController.text);
                    }
                  })
            ],
          ),
        ),]
    );
  }
}
