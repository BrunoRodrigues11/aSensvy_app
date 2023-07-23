import 'dart:convert';
import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/model/history.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();
  late Future<List<Historico>> historico;
  
  @override
  void initState() {
    super.initState();
    historico = pegarHistorico();
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
                  "Histórico",
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,                
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder<List<Historico>>(
                        future: historico,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,   
                              children: const [
                                CircularProgressIndicator(
                                  color: Color(0xff0095FF),
                                ),
                                Text(
                                  'Carregando'
                                )
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  Historico historico = snapshot.data![index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _getBackgroundColor(historico.score),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [ 
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0,3), // deslocamento horizontal e vertical da sombra
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            historico.name.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    width: 45,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(50),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          historico.score.toString(),
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 18,
                                                              color:Colors.black
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Score",
                                                    style: TextStyle(
                                                        fontWeight:FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    DateFormat('dd/MM/yyyy').format(DateTime.parse(historico.date!)),
                                                    style: const TextStyle(
                                                        fontWeight:FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.white
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Column(
                              children: const [
                                Text(
                                  "Nenhum dado disponível.",
                                  style: TextStyle(
                                    color: Colors.black
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // COLORS DO HISTÓRICO
  Color _getBackgroundColor(int? score) {
    if (score! >= 75) {
      return const Color(0xffc40234); // muito alto -> 75% a 100%
    } else if (score >= 50) {
      return const Color(0xffffd300); // alto -> 50% a 75%
    } else if (score >= 25) {
      return const Color(0xff0188bf); // moderado -> 25% a 50%
    } else {
      // return Color(0xff123456);
      return const Color(0xff00a468); // baixo -> 25% ou menos
    }
  }

  // FUTURE FUNCTION PARA DAR UM GET NO HISTÓRICO DO USUÁRIO
  Future<List<Historico>> pegarHistorico() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var url = Uri.parse('https://asensvy-production.up.railway.app/ia/history');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var historicoList = jsonData['history'] as List<dynamic>;

      List<Historico> historicos = historicoList.map((json) => Historico.fromJson(json)).toList();
      return historicos;
    } else {
      throw Exception(
        "Não foi possível carregar o histórico ${response.statusCode}"
      );
    }
  }
}