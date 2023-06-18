import 'dart:convert';
import 'package:apptesteapi/model/history.dart';
import 'package:apptesteapi/pages/init_page.dart';
import 'package:apptesteapi/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Historico>> historico;
  String? termoPesquisa;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    historico = pegarHistorico();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Histórico",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Sair'),
                  content: Text('Você realmente deseja sair?'),
                  actions: [
                    TextButton(
                      child: Text('Não'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text('Sim'),
                      onPressed: () => sair(),
                    ),
                  ],
                ),
              );
              // sair();
            },
            child: Text("Sair"),
          ),
        ],
      ),
      body: _body(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavbarHome(),
    );
  }
  
  _body() { // color background #E4E9F7
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      // Chame uma função para atualizar o estado com o valor da caixa de pesquisa
                      atualizarTermoPesquisa(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Pesquisar',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
             FutureBuilder<List<Historico>>(
                future: historico,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) { 
                        Historico historico = snapshot.data![index];                                      
                        return ListTile(
                          title: Text(
                            historico.name.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy').format(DateTime.parse(historico.date!)),
                              ),
                              historico.score !>= 70 ? Text(
                                "Score: ${historico.score.toString()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red
                                ),
                              ): 
                              Text(
                                "Score: ${historico.score.toString()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("Nenhum dado disponível.");
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void atualizarTermoPesquisa(String value) {
    setState(() {
      termoPesquisa = value;
    });
  }

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
      throw Exception("Não foi possível carregar o histórico ${response.statusCode}");
    }
  }
    
  _homePage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }
  _historyPage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  _settingsPage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }  

  _profilePage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }
      
  sair() async {
    bool saiu = await doLogout();
    if (saiu) {
      Navigator.pushReplacement(  context,MaterialPageRoute(builder: (context) => const FirstPage()));
    }
  }

  Future<bool> doLogout() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var _token = sharedPreferences.getString('token');
      print(_token.toString());
      await sharedPreferences.clear();
      return true;
    } catch (e) {
      print('Erro ao sair: $e');
    }
    throw Exception('BarException');
  }
}