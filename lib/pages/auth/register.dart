import 'package:apptesteapi/config/auth_service.dart';
import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:quickalert/quickalert.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();
  final authService = AuthService();

  final _formkey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var maskFormatter = MaskTextInputFormatter(
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

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
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => goToScreen.goToLoginPage(context),
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
                          "Cadastrar-se",
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Crie a sua conta",
                          style: TextStyle(
                            fontSize: 15, 
                            color: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                            topRight: Radius.circular(30)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // deslocamento horizontal e vertical da sombra
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: <Widget>[
                                    InputDefault(
                                      "",
                                      false,
                                      TextInputType.text,
                                      Icon(
                                        Icons.person,
                                        color: Colors.grey[600],
                                      ),
                                      "Informe o seu nome",
                                      const [],
                                      validator: (firstName) {
                                        if (firstName == null || firstName.isEmpty) {
                                          return "Por favor, informe seu nome";
                                        }
                                        return null;
                                      },
                                      controller: _firstNameController,
                                    ),
                                    InputDefault(
                                      "",
                                      false,
                                      TextInputType.text,
                                      Icon(
                                        Icons.person,
                                        color: Colors.grey[600],
                                      ),
                                      "Informe o seu sobrenome",
                                      const [],
                                      validator: (lastName) {
                                        if (lastName == null || lastName.isEmpty) {
                                          return "Por favor, informe seu sobrenome";
                                        }
                                        return null;
                                      },
                                      controller: _lastNameController,
                                    ),
                                    InputDefault(
                                      "",
                                      false,
                                      TextInputType.text,
                                      Icon(
                                        Icons.phone,
                                        color: Colors.grey[600],
                                      ),
                                      "Informe o seu telefone",
                                      [maskFormatter],
                                      validator: (tel) {
                                        if (tel == null || tel.isEmpty) {
                                          return "Por favor, informe seu telefone";
                                        } else if (tel.length < 16) {
                                          return "Por favor, informe um telefone válido.";
                                        }
                                        return null;
                                      },
                                      controller: _phoneController,
                                    ),
                                    InputDefault(
                                      "",
                                      false,
                                      TextInputType.emailAddress,
                                      Icon(
                                        Icons.email,
                                        color: Colors.grey[600],
                                      ),
                                      "Informe o seu email",
                                      const [],
                                      validator: (email) {
                                        if (email == null || email.isEmpty) {
                                          return "Por favor, informe seu email";
                                        } else if (!RegExp(r'@')
                                            .hasMatch(_emailController.text)) {
                                          return 'Por favor, informe um e-mail válido!';
                                        }
                                        return null;
                                      },
                                      controller: _emailController,
                                    ),
                                    InputDefault(
                                      "",
                                      true,
                                      TextInputType.text,
                                      Icon(
                                        Icons.lock,
                                        color: Colors.grey[600],
                                      ),
                                      "Informe a sua senha",
                                      const [],
                                      validator: (senha) {
                                        if (senha == null || senha.isEmpty) {
                                          return "Por favor, informe sua senha";
                                        } else if (senha.length < 6) {
                                          return "Por favor, informe uma senha maior que 6 caracteres.";
                                        }
                                        return null;
                                      },
                                      controller: _passwordController,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            BtnDefault(
                              "Cadastrar",
                              onPressed: () => cadastrar(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Já possui uma conta?",
                                  style: TextStyle(
                                    fontSize: 16
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    goToScreen.goToLoginPage(context);
                                  },
                                  child: const Text(
                                    " Faça login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
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

  cadastrar() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await signUp(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        goToScreen.goToLoginPage(context);
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: "Aviso",
        text: "Preencha todos os campos"
      );
    }
  }

  Future<bool> signUp(BuildContext context) async {
    final success = await authService.doSignUp(
      context,
      _firstNameController.text,
      _lastNameController.text,
      _emailController.text,
      _phoneController.text,
      _passwordController.text,
    );

    if (success) {
      return true;
    } else {
      return false;
    }
  }
}