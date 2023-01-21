import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_record/config/api.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_request.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/data/model/user.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';

import '../../presentation/page/home_page.dart';

class SourceUser {
  static Future<bool> login(String email, String password) async {
    String url = '${Api.user}login.php';
    Map? responseBody = await AppRequest.post(url, {
      'email': email,
      'password': password,
    });

    if (responseBody?['success']) {
      var mapUser = responseBody?['data'];
      Session.saveUser(User.fromJson(mapUser));

      Fluttertoast.showToast(
          msg: "Login berhasil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColor.green,
          textColor: AppColor.white,
          fontSize: 16.0);
      Get.off(() => const HomePage());
    } else {
      Fluttertoast.showToast(
          msg: "Login gagal",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColor.red,
          textColor: AppColor.white,
          fontSize: 16.0);
    }

    return responseBody?['success'];
  }

  static Future<bool> register(
      String name, String email, String password) async {
    String url = '${Api.user}register.php';
    Map? responseBody = await AppRequest.post(url, {
      'name': name,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (responseBody == null) return false;

    if (responseBody['success']) {
      Fluttertoast.showToast(
          msg: "Register berhasil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColor.green,
          textColor: AppColor.white,
          fontSize: 16.0);
      Get.to(() => const LoginPage());
    } else {
      if (responseBody['message'] == 'email') {
        Fluttertoast.showToast(
            msg: "Email sudah terdaftar",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColor.chart,
            textColor: AppColor.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Register gagal",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: AppColor.red,
            textColor: AppColor.white,
            fontSize: 16.0);
      }
    }

    return responseBody['success'];
  }
}
