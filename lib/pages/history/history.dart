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
          IconButton(
            onPressed: (){
              sair();
            }, 
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: _body(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BtnIaVerify(),
      bottomNavigationBar: NavbarHome(),
    );
  }
  
  _body() { // color background #E4E9F7
    return SafeArea(
      child: Container(
        color: Color(0xffE4E9F7),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // deslocamento horizontal e vertical da sombra
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
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
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: historico.score !>= 70 ? Color(0xffCD4F41) : Color(0xff2D8077),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3), // deslocamento horizontal e vertical da sombra
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          historico.name.toString(),
                                          style: TextStyle(
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
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                          color: historico.score !>= 70 ? Color(0xffCD4F41): Color(0xff2D8077),
                                                        ),
                                                      ),
                                                    ],                                
                                                  ),
                                                ),
                                                Text(
                                                  "Score",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.white
                                                  ),
                                                ),  
                                              ],
                                            ),
                                            Column(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat('dd/MM/yyyy').format(DateTime.parse(historico.date!)),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.white
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
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
              ),
            ),
          ),
        ),
      ),
    );
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