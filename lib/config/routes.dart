import 'package:aSensvy/pages/auth/email_validated.dart';
import 'package:aSensvy/pages/auth/login.dart';
import 'package:aSensvy/pages/auth/register.dart';
import 'package:aSensvy/pages/auth/reset_password.dart';
import 'package:aSensvy/pages/auth/success.dart';
import 'package:aSensvy/pages/init_homePage.dart';
import 'package:aSensvy/pages/init_page.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  /* Rotas de autenticação */
  '/': (context) => const FirstPage(),
  '/login': (context) => const Login(),
  '/signUp': (context) => const SignUp(),

  /* Rotas de autenticação */
  '/resetPswd': (context) => const ResetPassword(),
  '/emailValidation': (context) {
    final emailController =
        ModalRoute.of(context)!.settings.arguments as String;
    return EmailValidation(email: emailController);
  },
  '/newPswd': (context) {
    final widgetEmail = ModalRoute.of(context)!.settings.arguments as String;
    return EmailValidation(email: widgetEmail);
  },
  '/successNewPswd': (context) => const SuccessNewPassword(),

  /* Rotas das telas */
  '/home': (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tab = arguments['tab'] as int;
    final screen = arguments['screen'] as Widget;
    return InitHomePage(tab, screen);
  },
  '/history': (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tab = arguments['tab'] as int;
    final screen = arguments['screen'] as Widget;
    return InitHomePage(tab, screen);
  },
  '/settings': (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tab = arguments['tab'] as int;
    final screen = arguments['screen'] as Widget;
    return InitHomePage(tab, screen);
  },
  '/profile': (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tab = arguments['tab'] as int;
    final screen = arguments['screen'] as Widget;
    return InitHomePage(tab, screen);
  },
  '/ia': (context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tab = arguments['tab'] as int;
    final screen = arguments['screen'] as Widget;
    return InitHomePage(tab, screen);
  },
};
