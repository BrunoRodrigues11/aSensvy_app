import 'package:apptesteapi/pages/auth/success.dart';
import 'package:apptesteapi/widgets/buttons.dart';
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
                          "Nova senha",
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
                          "Informe uma nova senha de acesso",
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
                                          "",
                                          true,
                                          TextInputType.text,
                                          Icon(
                                            Icons.lock,
                                            color: Colors.grey[600],
                                          ),
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
                                ],
                              ),
                            ),
                            BtnDefault(
                              "Salvar nova senha",
                              onPressed: () => enviar(),
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