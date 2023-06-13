import 'package:apptesteapi/pages/auth/success.dart';
import 'package:apptesteapi/pages/home/home.dart';
import 'package:apptesteapi/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewPassword extends StatefulWidget {
  String email;
  NewPassword({super.key, required this.email});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formkey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  final _snackBar = SnackBar(
    content: Text(
      "As senhas não são iguais",
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Nova senha",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Informe uma nova senha de acesso",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                        Image.asset(
                          "assets/new-password.png",
                          width: 325,
                          height: 325,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            InputDefault(
                              "Nova senha",
                              true,
                              TextInputType.text,
                              "Informe a nova senha",
                              const [],
                              validator: (senha) {
                                if (senha == null || senha.isEmpty) {
                                  return "Por favor, informe sua senha";
                                } else if (senha.length < 6) {
                                  return "Por favor, informe uma senha maior que 6 caracteres";
                                }
                                return null;
                              },
                              controller: _newPasswordController,
                            ),
                            InputDefault(
                              "Confirmar nova senha",
                              true,
                              TextInputType.text,
                              "Confirme a nova senha",
                              const [],
                              validator: (senha) {
                                if (senha == null || senha.isEmpty) {
                                  return "Por favor, confirme sua senha";
                                } else if (senha.length < 6) {
                                  return "Por favor, confirme a senha";
                                } else if (_newPasswordController == _confirmNewPasswordController.text) {
                                  return "As senhas devem ser iguais";
                                }                                
                                return null;
                              },
                              controller: _confirmNewPasswordController,
                            ),
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
                            enviar();
                          },
                          color: Color(0xff0095FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Salvar nova senha",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  enviar() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await setNewPassword();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SuccessNewPassword()),
        );
      } else {
        _newPasswordController.clear();
        _confirmNewPasswordController.clear();        
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }
  }

  // ARRUMAR A ROTA
  Future<bool> setNewPassword() async {
    try {
      var url = Uri.parse('https://asensvy-production.up.railway.app/recoverPassword/newpassword');
      var objeto = {
        'email': widget.email,
        'password': _confirmNewPasswordController.text
      };

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        print("SENHA RESETADA");
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