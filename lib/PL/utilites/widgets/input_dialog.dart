import 'package:flutter/material.dart';

import 'cancel_button.dart';
import 'custom_text_field.dart';

class InputDialog extends StatelessWidget {
  InputDialog({Key? key,this.title,this.initialValue="",this.onSave}) : super(key: key);
  final String? title;
  final String? initialValue;
  final Function? onSave;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title!),
      content: Form(
          key: formKey,
          child:CustomTextField(
            icon: Icons.description_outlined,
            onSave: (value)=>onSave!(value),
            label: "Name",
            initialValue: initialValue,
          )),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                //my operations will be on onSave method
              }
            },
            child: Text(title!)),
        CancelButton(),
      ],
    );  }
}
