import 'package:flutter/material.dart';
import '../strings.dart';

class Helper{

 void goTo({BuildContext? context,Widget? to}){
  Navigator.push(
      context!,MaterialPageRoute(builder: (context) => to!));
}

String getDesignSize(BuildContext context){

  double screenWidth=MediaQuery.of(context).size.width;

  if(screenWidth<=700){
    return Strings.smallDesign;
  }
  return Strings.largeDesign;

}

 String errorTranslation(String englishError) {

   if(englishError=="We have blocked all requests from this device due to unusual activity. Try again later."){
     return "ادخلت كلمة مرور غير صحيحة عدة مرات لهذا الإيميل من فضلك سجل الدخول في وقت لاحق.";
   }
   else if(englishError=="The password is invalid or the user does not have a password."){
     return "كلمة مرور خاطئة";
   }
   else if(englishError=="There is no user record corresponding to this identifier. The user may have been deleted."){
     return "هذا الإيميل غير مسجل لدينا";
   }
   else if(englishError=="An internal error has occurred."){
     return "انت غير متصل بالإنترنت";
   }
   else if(englishError=="We have blocked all requests from this device due to unusual activity. Try again later."){
     return "ادخلت كلمة مرور غير صحيحة عدة مرات لهذا الإيميل من فضلك سجل  في وقت لاحق.";
   }

   else if(englishError=="error while addition"){
     return "لم تتم الإضافة";
   }
   else if(englishError=="error while update"){
     return "لم يتم التعديل";
   }
   else if(englishError=="error"){
     return "تاكد من اتصال الانترنت لديك";
   }
   else if(englishError.contains("Duplicate entry")){
     return "انت قمت بتقييم هذا الشخص من قبل";
   }
   else if(englishError.contains("Cannot delete or update a parent row")){
     return "لا يمكنك حذف هذا العنوان لانه مرتبط بطلب من قبل";
   }
   else {
     return englishError;
   }}
}

