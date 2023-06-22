import 'package:apptesteapi/pages/auth/new_password.dart';
import 'package:apptesteapi/pages/auth/reset_password.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmailValidation extends StatefulWidget {
  String email;
  EmailValidation({super.key, required this.email});

  @override
  State<EmailValidation> createState() => _EmailValidationState();
}

class _EmailValidationState extends State<EmailValidation> {
  final _formkey = GlobalKey<FormState>();
  final _codController0 = TextEditingController();
  final _codController1 = TextEditingController();
  final _codController2 = TextEditingController();
  final _codController3 = TextEditingController();
  final _codController4 = TextEditingController();
  final _codController5 = TextEditingController();
  final _fullCode = [];
  String _code = "";
  final _snackBar = SnackBar(
    content: Text(
      "Código inválido",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          "Código de verificação",
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
                          "Informe o código que foi enviado em seu email",
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
                                    "assets/email_send.png",
                                    width: 300,
                                    height: 300,
                                  ),
                                  Form(
                                    key: _formkey,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InputCode(controller: _codController0),
                                        InputCode(controller: _codController1),
                                        InputCode(controller: _codController2),
                                        InputCode(controller: _codController3),
                                        InputCode(controller: _codController4),
                                        InputCode(controller: _codController5),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BtnDefault(
                              "Validar código",
                              onPressed: () => _getCode(),
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

  _getCode() {
    _fullCode.clear();
    _fullCode.add(_codController0.text);
    _fullCode.add(_codController1.text);
    _fullCode.add(_codController2.text);
    _fullCode.add(_codController3.text);
    _fullCode.add(_codController4.text);
    _fullCode.add(_codController5.text);
    _code = _fullCode.join();
    if (_code.length <6){
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }else{
      enviar();      
    }
  }

  enviar() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await verifyCode();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NewPassword(email: widget.email,)),
        );
      } else {
        _codController0.clear();
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }
  }

  // ARRUMAR A ROTA
  Future<bool> verifyCode() async {
    try {
      var url = Uri.parse('https://asensvy-production.up.railway.app/recoverPassword/verify');
      var objeto = {
        'email': widget.email,
        'code': _code
      };

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
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
