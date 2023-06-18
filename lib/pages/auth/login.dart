import 'package:apptesteapi/pages/auth/register.dart';
import 'package:apptesteapi/pages/auth/reset_password.dart';
import 'package:apptesteapi/pages/home/home.dart';
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
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _snackBar = SnackBar(
    content: Text(
      "Email ou senha inválidos",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: Container(
        color: Color(0xffE4E9F7),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Color(0xffE4E9F7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                            ),
                            Image.asset(
                              "assets/eye.png",
                              width: 100,
                              height: 100,
                            ),
                            Text(
                              "Bem-vindo de volta!",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Entre com sua conta",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey[700]),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: <Widget>[
                                InputDefault(
                                  "Email",
                                  false,
                                  TextInputType.emailAddress,
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
                                  "Senha",
                                  true,
                                  TextInputType.text,
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
                                TextButton(
                                  onPressed: () {
                                    _resetPassword(context, ResetPassword());
                                  },
                                  child: Text(
                                    "Esqueci minha senha",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
                            padding: EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 60,
                              onPressed: () {
                                entrar();
                              },
                              color: Color(0xff0095FF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "Entrar",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Não possui uma conta?"),
                            TextButton(
                              onPressed: () {
                                _signUp(context, SignUp());
                              },
                              child: Text(
                                " Cadastrar-se",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _signUp(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  _resetPassword(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  entrar() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await doLogin();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }
  }

  Future<bool> doLogin() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var url = Uri.parse('https://asensvy-production.up.railway.app/auth');
      var objeto = {
        'password': _passwordController.text,
        'email': _emailController.text
      };

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        //guarda o token dentro do shared preference
        await sharedPreferences.setString('token', "Token ${jsonDecode(response.body)['token']}");
        await sharedPreferences.setString('fullName', "FullName ${jsonDecode(response.body)['user']['fullName']}");
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
