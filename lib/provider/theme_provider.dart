import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

 bool isDark = false;
 void valueChange({required bool value}){
   isDark = value;
   // save value in sharedPrefrences
  setThemeInPrefes(value);
   notifyListeners();
 }
 void setThemeInPrefes(bool value) async{
   var prefres = await SharedPreferences.getInstance();
   prefres.setBool("isBool", value);
 }
 //
 void updateThemeFirstTime()async{
   var prefres = await SharedPreferences.getInstance();
   var isDarkValue = prefres.getBool("isBool");

   if(isDarkValue != null){
     isDark = isDarkValue;
   }else{
     isDark = false;
   }
   notifyListeners();
 }
 // void updateThemeFirstTime () async{
 //   var prefes = await SharedPreferences.getInstance();
 //   var isDarkPrefes =  prefes.getBool("IsDark");
 //   if(isDarkPrefes != null){ // first time shared prefrences ki avlue null ho sakti h
 //
 //     isDark = isDarkPrefes  ;
 //   }
 //   else {
 //     isDark = false ;
 //   }
 //   notifyListeners();
 // }
//}
}