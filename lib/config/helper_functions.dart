import 'package:apptesteapi/pages/auth/email_validated.dart';
import 'package:apptesteapi/pages/auth/login.dart';
import 'package:apptesteapi/pages/auth/new_password.dart';
import 'package:apptesteapi/pages/auth/register.dart';
import 'package:apptesteapi/pages/auth/reset_password.dart';
import 'package:apptesteapi/pages/auth/success.dart';
import 'package:apptesteapi/pages/history/history.dart';
import 'package:apptesteapi/pages/home/home.dart';
import 'package:apptesteapi/pages/ia_verify/ia_verify.dart';
import 'package:apptesteapi/pages/init_homePage.dart';
import 'package:apptesteapi/pages/init_page.dart';
import 'package:apptesteapi/pages/users/profile.dart';
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
    Navigator.pushReplacement(
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ResetPassword()),
    );
  }  
  
  // 02
  void goToEmailValidationPage(BuildContext context, emailController) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EmailValidation(email: emailController)),
    );
  } 
    
  // 03
  void goToNewPswdPage(BuildContext context, widgetEmail) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NewPassword(email: widgetEmail)),
    );
  } 

  // 03
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitHomePage(0, const Home())),
    );
  }

  void goToHistoryPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitHomePage(1, const HistoryPage())),
    );
  }

  void goToSettingsPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitHomePage(2, const ProfilePage())),
    );
  }  

  void goToProfilePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitHomePage(3, const ProfilePage())),
    );
  }

  void goToIAVerifyPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitHomePage(0, const IaVerify())),
    );
  }   
}

class ApiFuncs{

}