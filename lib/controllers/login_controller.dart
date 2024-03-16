import 'dart:convert';

import 'package:patient_management/models/user.dart';
import 'package:patient_management/routes.dart';
import 'package:patient_management/utils/base_url.dart';
import 'package:patient_management/utils/custom_snackbar.dart';
import 'package:patient_management/utils/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  late TextEditingController emailController, passwordController;

  bool loading = false;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    checkUserLogin();
  }

  checkUserLogin() async {
    var usr = await SharedPrefs().getUser();
    if (usr != null) {
      Get.offAllNamed(GetRoutes.allPatients);
    } else {
      Get.offAllNamed(GetRoutes.login);
    }
  }

  checkLogin() {
    if (emailController.text.isEmpty) {
      customSnackbar('*Email', 'Please enter your email.', 'error');
    } else if (GetUtils.isEmail(emailController.text) == false) {
      customSnackbar('*Email', 'Please enter valid email.', 'error');
    } else if (passwordController.text.isEmpty) {
      customSnackbar('*Password', 'Please enter your password.', 'error');
    } else {
      login();
      // Get.showOverlay(
      //     asyncFunction: () => login(), loadingWidget: const Loader());
    }
  }

  login() async {
    loading = true;
    update();
    var response = await http.post(Uri.parse('${baseUrl}auth/login'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
          'device': 'mobile'
        }));
    var res = await json.decode(response.body);
    if (res['success']) {
      User user = User.fromJson(res['data']);

      await SharedPrefs().storeUser(jsonEncode(user));
      Get.offAllNamed(GetRoutes.allPatients);
    } else {
      customSnackbar('Login up failed!', res['message'][0], 'error');
    }

    loading = false;
    update();
  }
}
