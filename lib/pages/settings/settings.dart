import 'dart:convert';
import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/loading.dart';
import 'package:apptesteapi/widgets/texts.dart';
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
  bool _isLoading = true;
  double userSensitivity = 0;
  double newSensitivity = 0;

  @override
  void initState() {
    super.initState();
    getConfig();
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
                    color: Colors.white),
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
                    topRight: Radius.circular(30)),
              ),
              child: _isLoading
                  ? const LoadingIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextTitle(texto: "Sensibilidade"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userSensitivity.round().toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _showSensitivityModal(userSensitivity);
                                    },
                                    icon: const Icon(Icons.edit),
                                  )
                                ],
                              ),
                              TextTitle(texto: "Segurança"),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Alterar senha",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [TextTitle(texto: "Permissões")],
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
    ));
  }

  Future getConfig() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url =
        Uri.parse('https://asensvy-production.up.railway.app/user/config');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        userSensitivity = jsonData['config']['sensitivity'].toDouble();
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
  }

  Future setConfig(double newSensitivity) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url =
        Uri.parse('https://asensvy-production.up.railway.app/user/config');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };
    var body = jsonEncode({'sensitivity': newSensitivity.toInt()});

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      getConfig();
      print("Deu tudo CERTO $newSensitivity");
    } else {
      print("Deu tudo ERRADO");
    }
  }

  _showSensitivityModal(double newSensitivity) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
              const Text(
                "Selecione a Sensibilidade",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              StatefulBuilder(
                builder: (context, state) {
                  return Slider(
                    value: newSensitivity,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: newSensitivity.round().toString(),
                    activeColor: AppColors.primaryColor,
                    onChanged: (value) {
                      newSensitivity = value;
                      state(
                        () {},
                      );
                      setState(
                        () {},
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              BtnDefault(
                onPressed: () {
                  setConfig(newSensitivity);
                  Navigator.pop(context);
                },
                "Salvar",
              ),
            ],
          ),
        );
      },
    );
  }
}
