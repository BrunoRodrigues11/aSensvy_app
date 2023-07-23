import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/information.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();  
  String _fullName = "";  
  String _fullNameLogged = "";
  
@override
  void initState() {
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
      backgroundColor: AppColors.primaryColor,
      body: _body(),
      extendBody: true,
      extendBodyBehindAppBar: true,
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
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Olá, $_fullNameLogged",
                                style: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              IconButton(
                                onPressed: () => sair(), 
                                icon: const Icon(
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
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // deslocamento horizontal e vertical da sombra
                            ),
                          ],
                        ),
                        child: ListView(
                          children: [
                            const Padding(
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
                                padding: const EdgeInsets.only(left: 15, top: 15, bottom: 5),
                                child: Row(
                                  children: [
                                    ListInformation(
                                      color: AppColors.primaryColor, 
                                      tiulo: "Use óculos de sol", 
                                      subtitulo: "Proteção contra raios UV e luz intensa"
                                    ),
                                    ListInformation(
                                      color: AppColors.primaryColor, 
                                      tiulo: "Evite luzes brilhantes", 
                                      subtitulo: "Luz solar, fluorescentes e de flashs"
                                    ), 
                                    ListInformation(
                                      color: AppColors.primaryColor, 
                                      tiulo: "Ajuste a iluminação interna", 
                                      subtitulo: "Use lâmpadas de menor intensidade"
                                    ),
                                    ListInformation(
                                      color: AppColors.primaryColor, 
                                      tiulo: "Use filtros de tela", 
                                      subtitulo: "Reduz o brilho e a intesidade de luz"
                                    ),                                    
                                    ListInformation(
                                      color: AppColors.primaryColor, 
                                      tiulo: "Evite exposição prolongada", 
                                      subtitulo: "Em ambientes muito iluminados"
                                    ),                                                                                                      
                                  ],
                                )
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "O que vamos fazer hoje?",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: SizedBox(
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
                                            onTap: () => goToScreen.goToIAVerifyPage(context),
                                          ),
                                          OptionsGrid(
                                            imagem: "assets/historico.png", 
                                            nome: "Histórico",
                                            onTap: () => goToScreen.goToHistoryPage(context),
                                          ),   
                                          OptionsGrid(
                                            imagem: "assets/estatisticas.png", 
                                            nome: "Estatísticas",
                                            onTap: () => goToScreen.goToIAVerifyPage(context),
                                          ),
                                          OptionsGrid(
                                            imagem: "assets/config.png", 
                                            nome: "Ajustes",
                                            onTap: () => goToScreen.goToSettingsPage(context),
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
    
  sair() async {
    bool saiu = await doLogout();
    if (saiu) {
      goToScreen.goToFirstPage(context);
    }
  }

  Future<bool> doLogout() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.clear();
      return true;
    } catch (e) {
      print('Erro ao sair: $e');
    }
    throw Exception('BarException');
  }
}