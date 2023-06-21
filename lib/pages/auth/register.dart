import 'package:apptesteapi/pages/auth/login.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formkey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _snackBar = SnackBar(
    content: Text(
      "Preencha todos os campos",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );
  final _snackBarS = SnackBar(
    content: Text(
      "Cadastro realizado com sucesso!",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Color(0xff00a468),
  );

  var maskFormatter = new MaskTextInputFormatter(
    //+55 (15) 9 9708-6888
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
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
                          "Cadastrar-se",
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
                          "Crie a sua conta",
                          style: TextStyle(
                            fontSize: 15, 
                            color: Colors.grey[50],
                          ),
                        ),
                        SizedBox(
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
                                Text(
                                  "Já possui uma conta?",
                                  style: TextStyle(
                                    fontSize: 16
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _login(context, Login());
                                  },
                                  child: Text(
                                    " Faça login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff034694),
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

  _login(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  cadastrar() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await doSignUp();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        ScaffoldMessenger.of(context).showSnackBar(_snackBarS);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
      } else {
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      }
    }
  }

  Future<bool> doSignUp() async {
    try {
      var url = Uri.parse('https://asensvy-production.up.railway.app/users');
      var objeto = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text
      };

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 201) {
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
