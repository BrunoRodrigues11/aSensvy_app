import 'package:apptesteapi/pages/auth/email_validated.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _snackBar = SnackBar(
    content: Text(
      "Email inválido",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff034694),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Color(0xff034694), 
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
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Redefinir Senha",
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Primeiramente, informe o seu email",
                          style: TextStyle(
                            fontSize: 15, 
                            color: Colors.grey[50],
                          ),
                        ),
                        SizedBox(
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
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // deslocamento horizontal e vertical da sombra
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
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
                                          controller: _emailController
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BtnDefault(
                              "Receber código",
                              onPressed: () => validar(),
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

  validar() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await sendEmail();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmailValidation(email:_emailController.text)),
        );
      } else {
        _emailController.clear();
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }
  }

  // ARRUMAR A ROTA
  Future<bool> sendEmail() async {
    try {
      var url = Uri.parse('https://asensvy-production.up.railway.app/recoverPassword/send');
      var objeto = {'email': _emailController.text};

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 201) {
        print("OK");
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

