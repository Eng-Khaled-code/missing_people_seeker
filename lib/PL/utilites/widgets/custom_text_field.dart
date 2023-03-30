import 'package:flutter/material.dart';
class CustomTextField extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final Function(String value)? onSave;
  final String? initialValue;
  final TextInputType? textInputType;
  CustomTextField({
    @required this.label,
    this.icon=Icons.library_books,
    @required this.onSave,
    this.initialValue="",
    this.textInputType=TextInputType.text
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool hidePass = true;

  IconData hidePassIcon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: TextFormField( onSaved: (value) {
            widget.onSave!(value!);
          },
            initialValue:widget.initialValue,
            maxLines:widget.label==""||widget.label=="العنوان"?3:1,
            keyboardType: widget.textInputType,
            obscureText: widget.label=="كلمة المرور"?hidePass:false,
            validator:(value){

              bool isNumber;
              bool isGreaterThan0;
              //checking is number or not
              try {
                int.parse(value!);
                isNumber = true;
              } catch (ex) {
                isNumber = false;
              }

              //checking is greater than zero or not
              if (isNumber) {
                if (int.parse(value!) > 0)
                  isGreaterThan0 = true;
                else
                  isGreaterThan0 = false;
              } else
                isGreaterThan0 = false;

              if (value!.isEmpty&&value!="الاسم بالكامل (إن أمكن)"&&value!="السن (إن أمكن)") {
                return "من فضلك إدخل "+widget.label!;
              } else if (widget.label == "الرقم القومي" && value.length != 14)
                return "الرقم القومي غير صحيح";
              else if (widget.label == "الرقم القومي" && isNumber == false)
                return "الرقم القومي غير صحيح";
              else if (widget.label == "السن" && isNumber == false)
                return "السن غير صحيح";
              else if (widget.label == "السن" && isGreaterThan0 == false)
                return "السن غير صحيح";
              else if (widget.label == "الإيميل") {
                Pattern pattern =
                    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$';

                RegExp regExp = RegExp(pattern.toString());
                if (!regExp.hasMatch(value)) return "تاكد من صحة الإيميل";
              } else if ((widget.label == "رقم الهاتف" && isNumber == false) ||
                  (widget.label == "رقم الهاتف" && value.length != 11) ||
                  (widget.label == "رقم الهاتف" && !value.startsWith("01")))
                return "رقم الهاتف غير صحيح";
              else if(widget.label=="كلمةالمرور"&&value.length<8)
              {
                return "كلمةالمرور يجب ان تكون أكبر من 8 حروف";
              }


            },
            decoration: InputDecoration(
              border:InputBorder.none,
              labelText: widget.label,
              icon: Icon(
                widget.icon,
              ),
              suffixIcon:
              widget.label=="كلمة المرور"
                  ?
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon:Icon(hidePassIcon),
                  onPressed: ()=>onPressHideShow(),
                ),
              )
                  :
              null,
            ),

          ),
        ));
  }

  onPressHideShow() {
    setState(() {
      if (hidePass) {
        hidePass = false;
        hidePassIcon = Icons.visibility;
      } else {
        hidePass = true;
        hidePassIcon = Icons.visibility_off;
      }
    });

  }
}
