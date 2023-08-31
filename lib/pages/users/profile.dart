import 'dart:convert';
import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/information.dart';
import 'package:apptesteapi/widgets/inputs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();
  String firstName = "";
  String lastName = "";
  String email = "";
  String phone = "";
  bool _isLoading = true;
  bool _isEditing = false;

  final _formkey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
    //+55 (15) 9 9708-6888
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
@override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: _body(),
    );
  }

  _body() { 
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: AppColors.primaryColor, 
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => goToScreen.goToHomePage(context),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _isEditing ?
                        const Text(
                          "Editar Perfil",
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ):
                        const Text(
                          "Perfil",
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Revise as suas informações cadastrais",
                          style: TextStyle(
                            fontSize: 15, 
                            color: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)
                          ),
                        ),
                        child: _isLoading 
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,   
                            children: const [
                              CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                              Text(
                                'Carregando'
                              )
                            ],
                          )
                        :Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: _isEditing ? Form(
                                key: _formkey,
                                child: Column(
                                  children:<Widget>[
                                    Column(
                                      children: [
                                        InputDefault(
                                          "Nome",
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
                                          "Sobrenome",
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
                                          "Telefone",
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
                                          "Email",
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
                                        BtnDefault(
                                          "Cancelar",
                                          onPressed: () => {
                                            setState(() {
                                              _isEditing = false;
                                            })
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        BtnDefault(
                                          "Salvar",
                                          onPressed: () => {
                                            setState(() {
                                              _isEditing = false;
                                            })
                                          },
                                        ), 
                                      ],
                                    ),
                                  ],
                                ),
                              ):
                              Column(
                                children: [
                                  UserInformation(
                                    titulo: "Nome",
                                    texto: firstName,
                                  ),
                                  UserInformation(
                                    titulo: "Sobrenome",
                                    texto: lastName,
                                  ),
                                  UserInformation(
                                    titulo: "Telefone",
                                    texto: phone,
                                  ),
                                  UserInformation(
                                    titulo: "Email",
                                    texto: email,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BtnDefault(
                                    "Editar informações",
                                    onPressed: () => {
                                      setState(() {
                                        _isEditing = true;
                                        _firstNameController.text = firstName;
                                        _lastNameController.text = lastName;        
                                        _phoneController.text = phone;
                                        _emailController.text = email;                                                                         
                                      })
                                    },
                                  ),
                                ],
                              ),
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

  Future getUser() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse('https://asensvy-production.up.railway.app/myuser');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      setState(() {
        firstName = jsonData['user']['firstName'];
        lastName = jsonData['user']['lastName'];      
        email = jsonData['user']['email'];
        phone = jsonData['user']['phone'];
        _isLoading = false;
      });
    }else{
      print('Falha ao carregar os dados da API');
      _isLoading = false;
    }
  }

  Future setConfig(double newSensitivity) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url =
        Uri.parse('https://asensvy-production.up.railway.app/users/config');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };
    var body = jsonEncode({
      'sensitivity': newSensitivity.toInt()
    });

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200){
      getUser();
      print("Deu tudo CERTO $newSensitivity");
    }else{
      print("Deu tudo ERRADO");
    }
  }
}
