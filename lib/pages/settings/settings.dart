import 'dart:convert';
import 'dart:ffi';
import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();
  int userSensitivity = 0;  
  double _currentValue = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getConfig();
  _currentValue = userSensitivity.toDouble();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: _body(),  
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }
  
  _body() {
    return SafeArea(
      child: Container(
        color: AppColors.primaryColor, 
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                const Text(
                  "Ajustes",
                  style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                    
                        children: [
                          Text(
                            "Sensibilidade: $userSensitivity",
                            style: const TextStyle(
                              fontSize: 18
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _showSensitivityModal();
                            },
                            icon: Icon(
                              Icons.edit
                            )
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              )
            )
          ],
        ),
      )
    );
  }

  Future getConfig() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse('https://asensvy-production.up.railway.app/users/config');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      setState(() {
        userSensitivity = jsonData['config']['sensitivity'];
        _isLoading = false;
      });
      print(jsonData['config']['sensitivity']);
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
      getConfig();
      print("Deu tudo CERTO $newSensitivity");
    }else{
      print("Deu tudo ERRADO");
    }
  }

  _showSensitivityModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Selecione a Sensibilidade",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: userSensitivity.toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: _currentValue.toInt().toString(),
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        _currentValue = value;
                        userSensitivity = _currentValue.toInt();
                        print("Sensibilidade: $userSensitivity");
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  BtnDefault(
                    onPressed: () {
                      setState(() {
                        userSensitivity = _currentValue.toInt();
                      });
                      setConfig(userSensitivity.toDouble());                      
                      Navigator.pop(context);                      
                    },
                    "Salvar",                
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}