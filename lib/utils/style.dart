import 'package:flutter/material.dart';

class Style {
  //  Style to Text using in TextFormFiled
  static const TextStyle styleTextFormFiled =
      TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);

  // Style to Border UnderLine using in TextFormFiled
  static const InputBorder borderTextFormFiled =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));

  //-------------- SignUp Screen ---------------//
  // Style to SubText using in TextFormFiled
  static const TextStyle styleTextSubTitleSignUp = TextStyle(
    color: Colors.white,
    fontSize: 14,
  );

  //-------------- Search Location Screen ---------------//
  // Style to Text Title using in ListTile
  static const TextStyle styleTitleSearchLocation =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold);

  // Style to Text SubTitle using in ListTile
  static const TextStyle styleSubTitleSearchLocation = TextStyle(fontSize: 11);

//-------------- Create Post Screen ---------------//
  static const TextStyle styleTextCreatePost =
      TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400);
  static const TextStyle styleTextSubTitleCreatePost =
      TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w400);
  static const  TextStyle chooseStyleCreatePost = TextStyle(color: Colors.white,fontWeight: FontWeight.bold);
  static const  TextStyle defaultValueStyleCreatePost= TextStyle(color: Colors.black,fontWeight: FontWeight.bold);

}

class CColors {
  CColors._();

  // black Color For BackGround
  static const colorBackground = Color(0xff2a2f39);

  // white Color For Text
  static const white = Colors.white;

//-------------- Create Post Screen ---------------//
  static const Color chooseColorCreatePost = Colors.black;
  static const Color defaultValueColorCraetePost = Colors.white70;
}
