import 'package:apptesteapi/pages/auth/new_password.dart';
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
                          "Código de verificação",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Informe o código que foi enviado em seu email",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                        Image.asset(
                          "assets/email_send.png",
                          width: 325,
                          height: 325,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
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
                          ),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            _getCode();
                          },
                          color: Color(0xff0095FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Confirmar",
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
