import 'package:apptesteapi/pages/auth/login.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:flutter/material.dart';

class SuccessNewPassword extends StatefulWidget {
  const SuccessNewPassword({super.key});

  @override
  State<SuccessNewPassword> createState() => _SuccessNewPasswordState();
}

class _SuccessNewPasswordState extends State<SuccessNewPassword> {
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
                          "Sucesso!",
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
                          "Redefinição de senha realizada com sucesso.",
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
                                    "assets/success.png",
                                    width: 300,
                                    height: 300,
                                  ),
                                ],
                              ),
                            ),
                            BtnDefault(
                              "Ir para o login",
                              onPressed: () => _login(),
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
  
  _login() {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Login()),);
  }
}