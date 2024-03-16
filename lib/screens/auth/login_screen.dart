import 'package:patient_management/utils/colors.dart';
import 'package:patient_management/widgets/custom_button.dart';
import 'package:patient_management/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_management/controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: GetBuilder<LoginController>(builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Patient Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 349,
                  child: Text(
                    'Take care of patient’s data sam as you take care of the patient',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 150),
                Text(
                  'Log into your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hint: 'Email',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                  enabled: !controller.loading,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hint: 'Password',
                  controller: controller.passwordController,
                  obscureText: true,
                  icon: Icons.key_sharp,
                  enabled: !controller.loading,
                ),
                const SizedBox(height: 25),
                CustomButton(
                    loading: controller.loading,
                    label: "Login",
                    onPressed: () => controller.checkLogin()),
              ],
            );
          }),
        ),
      )),
    );
  }
}
