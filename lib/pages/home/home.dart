import 'package:apptesteapi/model/history.dart';
import 'package:apptesteapi/pages/history/history.dart';
import 'package:apptesteapi/pages/ia_verify/ia_verify.dart';
import 'package:apptesteapi/pages/init_page.dart';
import 'package:apptesteapi/widgets/information.dart';
import 'package:apptesteapi/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _token = "";
  String _fullName = "";  
  String _fullNameLogged = "";
  
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFullName();
  }

  _getFullName() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _fullName = sharedPreferences.getString('fullName').toString();
    _fullNameLogged = _fullName.replaceAll('FullName ', '');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff034694),
      body: _body(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BtnIaVerify(),
      bottomNavigationBar: NavbarHome(),
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
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Olá, $_fullNameLogged",
                                style: TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              IconButton(
                                onPressed: () => sair(), 
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
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
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15, top: 30),
                              child: Text(
                                "Dicas",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                                child: Row(
                                  children: [
                                    ListInformation(
                                      color: Color(0xff034694), 
                                      tiulo: "Use óculos de sol", 
                                      subtitulo: "Proteção contra raios UV e luz intensa"
                                    ),
                                    ListInformation(
                                      color: Color(0xff034694), 
                                      tiulo: "Evite luzes brilhantes", 
                                      subtitulo: "Luz solar, fluorescentes e de flashs"
                                    ), 
                                    ListInformation(
                                      color: Color(0xff034694), 
                                      tiulo: "Ajuste a iluminação interna", 
                                      subtitulo: "Proteção contra raios UV e luz intensa"
                                    ),         
                                    ListInformation(
                                      color: Color(0xff034694), 
                                      tiulo: "Evite exposição prolongada", 
                                      subtitulo: "Proteção contra raios UV e luz intensa"
                                    ),                                                                                                      
                                  ],
                                )
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "O que vamos fazer hoje?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Container(
                                      height: 300,
                                      child: GridView.count(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 1.30,
                                        children: [
                                          OptionsGrid(
                                            imagem: "assets/analise_ia.png", 
                                            nome: "Analisar vídeo",
                                            onTap: () => _historyPage(context, IaVerify()),
                                          ),
                                          OptionsGrid(
                                            imagem: "assets/historico.png", 
                                            nome: "Histórico",
                                            onTap: () => _historyPage(context, HistoryPage()),
                                          ),   
                                          OptionsGrid(
                                            imagem: "assets/estatisticas.png", 
                                            nome: "Estatísticas",
                                            onTap: () => _historyPage(context, HistoryPage()),
                                          ),
                                          OptionsGrid(
                                            imagem: "assets/config.png", 
                                            nome: "Configurações",
                                            onTap: () => _historyPage(context, HistoryPage()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
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

  _historyPage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }

  _settingsPage(ctx, page) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: ((context) => page)));
  }  
    
  sair() async {
    bool saiu = await doLogout();
    if (saiu) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const FirstPage(),
        ),
      );
    }
  }

  Future<bool> doLogout() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var _token = sharedPreferences.getString('token');
      await sharedPreferences.clear();
      return true;
    } catch (e) {
      print('Erro ao sair: $e');
    }
    throw Exception('BarException');
  }
}
