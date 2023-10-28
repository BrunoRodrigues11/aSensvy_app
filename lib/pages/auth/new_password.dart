import 'package:apptesteapi/config/email_utils.dart';
import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/alerts.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/inputs.dart';
import 'package:flutter/material.dart';

class NewPassword extends StatefulWidget {
  String email;
  NewPassword({super.key, required this.email});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();
  final emailUtils = EmailUtils();

  final _formkey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

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
                              onPressed: () =>
                                  goToScreen.goToLoginPage(context),
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
                          "Nova senha",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Informe uma nova senha de acesso",
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
                                    "assets/new-password.png",
                                    width: 300,
                                    height: 300,
                                  ),
                                  Form(
                                    key: _formkey,
                                    child: Column(
                                      children: <Widget>[
                                        InputDefault(
                                          "",
                                          true,
                                          TextInputType.text,
                                          Icon(
                                            Icons.lock,
                                            color: Colors.grey[600],
                                          ),
                                          "Informe a nova senha",
                                          const [],
                                          true,
                                          validator: (senha) {
                                            if (senha == null ||
                                                senha.isEmpty) {
                                              return "Por favor, informe sua senha";
                                            } else if (senha.length < 6) {
                                              return "Por favor, informe uma senha maior que 6 caracteres";
                                            }
                                            return null;
                                          },
                                          controller: _newPasswordController,
                                        ),
                                        InputDefault(
                                          "",
                                          true,
                                          TextInputType.text,
                                          Icon(
                                            Icons.lock,
                                            color: Colors.grey[600],
                                          ),
                                          "Confirme a nova senha",
                                          const [],
                                          true,
                                          validator: (senha) {
                                            if (senha == null ||
                                                senha.isEmpty) {
                                              return "Por favor, confirme sua senha";
                                            } else if (senha.length < 6) {
                                              return "Por favor, confirme a senha";
                                            } else if (_newPasswordController ==
                                                _confirmNewPasswordController
                                                    .text) {
                                              return "As senhas devem ser iguais";
                                            }
                                            return null;
                                          },
                                          controller:
                                              _confirmNewPasswordController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BtnDefault(
                              "Salvar nova senha",
                              onPressed: () => validar(context),
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
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await setNewPassword(
          context, widget.email, _confirmNewPasswordController.text);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        showSuccessAlertBtn(
          context,
          "Sua senha foi atualizada!",
          () {
            goToScreen.goToLoginPage(context);
          },
        );
      } else {
        _newPasswordController.clear();
        _confirmNewPasswordController.clear();
      }
    }
  }

  Future<bool> setNewPassword(
      BuildContext context, String email, String password) async {
    final success = await emailUtils.doSetNewPassword(email, password);
    return success;
  }
}
