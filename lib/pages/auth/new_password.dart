import 'package:aSensvy/config/email_utils.dart';
import 'package:aSensvy/config/helper_functions.dart';
import 'package:aSensvy/config/theme.dart';
import 'package:aSensvy/widgets/alerts.dart';
import 'package:aSensvy/widgets/buttons.dart';
import 'package:aSensvy/widgets/inputs.dart';
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
                        // Row(
                        //   children: [
                        //     IconButton(
                        //       onPressed: () =>
                        //           goToScreen.goToLoginPage(context),
                        //       icon: const Icon(
                        //         Icons.arrow_back_ios,
                        //         size: 20,
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const SizedBox(
                          height: 35,
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
                                        InputPassword(
                                          "",
                                          TextInputType.text,
                                          Icon(
                                            Icons.lock,
                                            color: Colors.grey[600],
                                          ),
                                          "Informe a nova senha",
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
                                        InputPassword(
                                          "",
                                          TextInputType.text,
                                          Icon(
                                            Icons.lock,
                                            color: Colors.grey[600],
                                          ),
                                          "Confirme a nova senha",
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
                            BtnDefaultLoading(
                              "Salvar nova senha",
                              _isEnabled,
                              _isLoading,
                              onPressed: () {
                                // Navigator.of(context).pop();
                                // goToScreen.goToLoginPage(context);
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
      bool deuCerto = await setNewPassword(
          context, widget.email, _confirmNewPasswordController.text);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        showSuccessAlert(context, "Sua senha foi atualizada!");
        // Aguarde um pouco antes de redirecionar para a próxima tela.
        Future.delayed(
          const Duration(seconds: 2),
          () {
            // Navigator.of(context).pop();
            // goToScreen.goToLoginPage(context);
          },
        );
      } else {
        showErrorAlert(context, 'Erro ao atualizar sua senha');
        _newPasswordController.clear();
        _confirmNewPasswordController.clear();
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

  Future<bool> setNewPassword(
      BuildContext context, String email, String password) async {
    final success = await emailUtils.doSetNewPassword(email, password);
    setState(
      () {
        _isLoading = false;
        _isEnabled = true;
      },
    );
    return success;
  }
}
