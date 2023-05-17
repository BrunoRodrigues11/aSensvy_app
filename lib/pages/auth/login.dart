import 'package:apptesteapi/pages/auth/register.dart';
import 'package:apptesteapi/pages/auth/reset_password.dart';
import 'package:apptesteapi/pages/home/home.dart';
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/eye.png",
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "Bem-vindo de volta!",
                        style:
                            TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Entre com sua conta",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          inputFile(
                            label: "Email",
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hint: 'Informe o seu email',
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return "Por favor, informe seu email";
                              } else if (!RegExp(r'@')
                                  .hasMatch(_emailController.text)) {
                                return 'Por favor, informe um e-mail válido!';
                              }
                              return null;
                            },
                          ),
                          inputFile(
                            label: "Senha",
                            obscureText: true,
                            controller: _passwordController,
                            keyboardType: TextInputType.text,
                            hint: 'Informe a sua senha',
                            validator: (senha) {
                              if (senha == null || senha.isEmpty) {
                                return "Por favor, informe sua senha";
                              } else if (senha.length < 6) {
                                return "Por favor, informe uma senha maior que 6 caracteres";
                              }
                              return null;
                            },
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
          ],
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
    print("Chamou função login");
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var url = Uri.parse('http://127.0.0.1:3333/auth');
      var objeto = {
        'password': _passwordController.text,
        'email': _emailController.text
      };

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        //guarda o token dentro do shared preference
        await sharedPreferences.setString(
            'token', "Token ${jsonDecode(response.body)['token']}");
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

// we will be creating a widget for text field
Widget inputFile(
    {label, obscureText = false, validator, controller, keyboardType, hint}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
