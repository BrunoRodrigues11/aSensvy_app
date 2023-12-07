import 'package:aSensvy/config/email_utils.dart';
import 'package:aSensvy/config/helper_functions.dart';
import 'package:aSensvy/config/theme.dart';
import 'package:aSensvy/widgets/alerts.dart';
import 'package:aSensvy/widgets/buttons.dart';
import 'package:aSensvy/widgets/inputs.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();
  final emailUtils = EmailUtils();

  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: AppColors.primaryColor,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Redefinir Senha",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Primeiramente, informe o seu email",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0,
                                  3), // deslocamento horizontal e vertical da sombra
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/reset_password.png",
                                    width: 300,
                                    height: 300,
                                  ),
                                  Form(
                                    key: _formkey,
                                    child: Column(
                                      children: <Widget>[
                                        InputDefault(
                                            "",
                                            TextInputType.emailAddress,
                                            Icon(
                                              Icons.email,
                                              color: Colors.grey[600],
                                            ),
                                            "Informe o seu email",
                                            const [],
                                            true, validator: (email) {
                                          if (email == null || email.isEmpty) {
                                            return "Por favor, informe seu email";
                                          } else if (!RegExp(r'@').hasMatch(
                                              _emailController.text)) {
                                            return 'Por favor, informe um e-mail válido!';
                                          }
                                          return null;
                                        }, controller: _emailController),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BtnDefaultLoading(
                              "Receber código",
                              _isEnabled,
                              _isLoading,
                              onPressed: () {
                                validar(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validar(BuildContext context) async {
    setState(
      () {
        _isLoading = true;
        _isEnabled = false;
      },
    );

    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await sendEmail(context, _emailController.text);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        Navigator.pop(context);
        goToScreen.goToEmailValidationPage(context, _emailController.text);
      } else {
        showErrorAlert(context, 'Erro ao enviar e-mail');
        setState(
          () {
            _isLoading = false;
            _isEnabled = true;
          },
        );
        _emailController.clear();
      }
    } else {
      setState(
        () {
          _isLoading = false;
          _isEnabled = true;
        },
      );
    }
  }

  Future<bool> sendEmail(BuildContext context, String email) async {
    final success = await emailUtils.doSendEmail(email);
    setState(
      () {
        _isLoading = false;
        _isEnabled = true;
      },
    );
    return success;
  }
}
