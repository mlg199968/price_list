import 'package:flutter/material.dart';
import 'package:price_list/constants.dart';
import 'package:provider/provider.dart';
import 'final_list.dart';


// ignore: must_be_immutable
class CreateGroupPanel extends StatelessWidget {
  CreateGroupPanel(this.updateUINotifier);
  TextEditingController groupPanelTextfieldController=TextEditingController();
Function updateUINotifier;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ساخت گروه جدید'),
      actions: [
        Container(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextField(
                        controller: groupPanelTextfieldController,
                        maxLength: 20,
                        textAlign: TextAlign.center,
                        decoration: kInputDecoration.copyWith(hintText: 'نام گروه'),
                      ),
                    ]),
              ),
              TextButtonTheme(
                data: kButtonStyle,
                child: TextButton(
                  onPressed: () {
                    Provider.of<FinalList>(context,listen: false).addToGroupList(groupPanelTextfieldController.text);
                    Provider.of<FinalList>(context,listen: false).groupDropListValue=groupPanelTextfieldController.text;
                    updateUINotifier();
                    groupPanelTextfieldController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'افزودن گروه',
                    style: kHeaderStyle,
                  ),
                ),
              ),



            ],
          ),
        ),
      ],
    );
  }
}
