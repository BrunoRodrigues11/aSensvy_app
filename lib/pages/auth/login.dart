import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _snackBar = const SnackBar(
    content: Text(
      "Email ou senha inválidos",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
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
                    const SizedBox(
                      height: 45,
                    ),
                    Image.asset(
                      "assets/eye2.png",
                      width: 100,
                      height: 100,
                    ),
                    const Text(
                      "Bem-vindo de volta!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30, 
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Entre com sua conta",
                      style: TextStyle(
                        fontSize: 15, 
                        color: Colors.grey[50],
                      ),
                    ),
                  ],
                ),
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
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: <Widget>[
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      goToScreen.goToResetPswdPage(context);
                                    },
                                    child: const Text(
                                      "Esqueci minha senha",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      BtnDefault(
                        "Entrar",
                        onPressed: () => entrar(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Não possui uma conta?",
                            style: TextStyle(
                                fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              goToScreen.goToSignUpPage(context);
                            },
                            child: const Text(
                              " Cadastrar-se",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: AppColors.primaryColor,
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
      ),
    );
  }

  entrar() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await doLogin();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        goToScreen.goToHomePage(context);
      } else {
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }
  }

  Future<bool> doLogin() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var url = Uri.parse('https://asensvy-production.up.railway.app/auth');
      var objeto = {
        'password': _passwordController.text,
        'email': _emailController.text
      };

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        await sharedPreferences.setString('token', "Token ${jsonDecode(response.body)['token']}");
        await sharedPreferences.setString('fullName', "FullName ${jsonDecode(response.body)['user']['fullName']}");
        var token = sharedPreferences.getString('token');
        print("TOKEN $token");
        // print(jsonDecode(response.body)['user']['fullName']);
        return true;
      } else {
        print('Erro na requisição. Código de status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao enviar objeto: $e');
    }
    throw Exception('BarException');
  }
}