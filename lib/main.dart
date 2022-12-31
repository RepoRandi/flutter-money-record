import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:money_record/config/app_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light().copyWith(
          primary: AppColor.primary,
          secondary: AppColor.secondary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.white,
        ),
      ),
      home:const Scaffold(),
    );
  }
}
