import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? lable;
  final Color? color;
  final IconData? icon;
  final TextEditingController? controller;

  CustomTextField({
    @required this.lable,
    @required this.icon,
    @required this.controller,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: TextFormField(
          controller: controller,
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * .04),
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: lable,
            labelStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * .035,
            ),
            icon: Icon(
              icon,
            ),
          ),
          validator: (value) {
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

            if (value!.isEmpty) {
              if (lable == "الإيميل")
                return "من فضلك إدخل الإيميل";
              else if (lable == "الاسم الاول")
                return "من فضلك إدخل الاسم الاول";
              else if (lable == "اسم العائلة")
                return "من فضلك إدخل الاسم العائلة";
              else if (lable == "الرقم القومي")
                return "من فضلك إدخل الرقم القومي";
              else if (lable == "العنوان")
                return "من فضلك إدخل العنوان";
              else if (lable == "السن")
                return "من فضلك إدخل السن";
              else if (lable == "الاسم بالكامل")
                return "من فضلك إدخل الاسم بالكامل";
              else if (lable == "اخر مكان وجد به")
                return "من فضلك إدخل اخر مكان وجد به";
              else if (lable == "الحالة الصحية")
                return "من فضلك إدخل الحالة الصحية";
              else if (lable == "لون البشرة")
                return "من فضلك إدخل لون البشرة";
              else if (lable == "لون الشعر")
                return "من فضلك إدخل السن";
              else if (lable == "لون العين") return "من فضلك إدخل لون العين";
            } else if (lable == "الرقم القومي" && value.length != 14)
              return "الرقم القومي غير صحيح";
            else if (lable == "الرقم القومي" && isNumber == false)
              return "الرقم القومي غير صحيح";
            else if (lable == "السن" && isNumber == false)
              return "السن غير صحيح";
            else if (lable == "السن" && isGreaterThan0 == false)
              return "السن غير صحيح";
            else if (lable == "الإيميل") {
              Pattern pattern =
                  r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$';

              RegExp regExp = RegExp(pattern.toString());
              if (!regExp.hasMatch(value)) return "تاكد من صحة الإيميل";
            } else if ((lable == "رقم الهاتف" && isNumber == false) ||
                (lable == "رقم الهاتف" && value.length != 11) ||
                (lable == "رقم الهاتف" && !value.startsWith("01")))
              return "رقم الهاتف غير صحيح";
          },
        ),
      ),
    );
  }
}
