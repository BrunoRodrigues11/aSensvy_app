import 'package:apptesteapi/pages/auth/login.dart';
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
      "Cadastro realizado",
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.greenAccent,
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
                          height: 88,
                          child: Container(
                            color: Colors.redAccent,
                          ),
                        ),
                        Text(
                          "Cadastrar-se",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Crie sua conta",
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
                            inputFile(
                              label: "Nome",
                              controller: _firstNameController,
                              keyboardType: TextInputType.text,
                              hint: 'Informe o seu nome',
                              validator: (firstName) {
                                if (firstName == null || firstName.isEmpty) {
                                  return "Por favor, informe seu nome";
                                }
                                return null;
                              },
                            ),
                            inputFile(
                              label: "Sobrenome",
                              controller: _lastNameController,
                              keyboardType: TextInputType.text,
                              hint: 'Informe o seu sobrenome',
                              validator: (lastName) {
                                if (lastName == null || lastName.isEmpty) {
                                  return "Por favor, informe seu sobrenome";
                                }
                                return null;
                              },
                            ),
                            inputFile(
                              label: "Telefone",
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [maskFormatter],
                              hint: 'Informe o seu telefone',
                              validator: (tel) {
                                if (tel == null || tel.isEmpty) {
                                  return "Por favor, informe seu telefone";
                                } else if (tel.length < 11) {
                                  return "Por favor, informe um telefone válido.";
                                }
                                return null;
                              },
                            ),
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
                            cadastrar();
                          },
                          color: Color(0xff0095FF),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Cadastrar-se",
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
                        Text("Já possui uma conta?"),
                        TextButton(
                          onPressed: () {
                            _login(context, Login());
                          },
                          child: Text(
                            " Faça login",
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
          ],
        ),
      ),
    );
  }

  _login(ctx, page) {
    Navigator.push(ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  cadastrar() async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    print("chamou função CADASTRAR");
    if (_formkey.currentState!.validate()) {
      bool deuCerto = await doSignUp();
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (deuCerto) {
        ScaffoldMessenger.of(context).showSnackBar(_snackBarS);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        print("CADASTRO OK");
      } else {
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(_snackBar);
        print("CADASTRO DEU RUIM");
      }
    }
  }

  Future<bool> doSignUp() async {
    try {
      var url = Uri.parse('http://127.0.0.1:3333/users/');
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

// we will be creating a widget for text field
Widget inputFile({
  label,
  obscureText = false,
  validator,
  controller,
  keyboardType,
  inputFormatters,
  hint,
}) {
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
        inputFormatters: inputFormatters,
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
