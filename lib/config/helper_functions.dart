import 'package:aSensvy/pages/auth/email_validated.dart';
import 'package:aSensvy/pages/auth/login.dart';
import 'package:aSensvy/pages/auth/new_password.dart';
import 'package:aSensvy/pages/auth/register.dart';
import 'package:aSensvy/pages/auth/reset_password.dart';
import 'package:aSensvy/pages/auth/success.dart';
import 'package:aSensvy/pages/history/history.dart';
import 'package:aSensvy/pages/home/home.dart';
import 'package:aSensvy/pages/ia_verify/ia_verify.dart';
import 'package:aSensvy/pages/init_homePage.dart';
import 'package:aSensvy/pages/init_page.dart';
import 'package:aSensvy/pages/settings/settings.dart';
import 'package:aSensvy/pages/users/profile.dart';
import 'package:flutter/material.dart';

class GoToScreen {
  // =====
  void goToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  void goToSignUpPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUp()),
    );
  }

  void goToFirstPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FirstPage()),
    );
  }

  // ===== RESET PASSWORD ROUTES =====
  // 01
  void goToResetPswdPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPassword()),
    );
  }

  // 02
  void goToEmailValidationPage(BuildContext context, emailController) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EmailValidation(email: emailController)),
    );
  }

  // 03
  void goToNewPswdPage(BuildContext context, widgetEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewPassword(email: widgetEmail)),
    );
  }

  // 04
  void goToSuccessNewPswdPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SuccessNewPassword()),
    );
  }
  // ===== THE END OF RESET PASSWORD ROUTES =====

  // ********************************************

  // ===== SCREEN ROUTES =====
  void goToHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InitHomePage(0, const Home())),
    );
  }

  void goToHistoryPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InitHomePage(1, const HistoryPage())),
    );
  }

  void goToSettingsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InitHomePage(2, const SettingsPage())),
    );
  }

  void goToProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InitHomePage(3, const ProfilePage())),
    );
  }

  void goToIAVerifyPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InitHomePage(0, const IaVerify())),
    );
  }
}
