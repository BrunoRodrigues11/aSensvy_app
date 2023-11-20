import 'package:aSensvy/config/auth_service.dart';
import 'package:aSensvy/config/helper_functions.dart';
import 'package:aSensvy/config/theme.dart';
import 'package:aSensvy/pages/home/testPage.dart';
import 'package:aSensvy/widgets/alerts.dart';
import 'package:aSensvy/widgets/buttons.dart';
import 'package:aSensvy/widgets/information.dart';
import 'package:aSensvy/widgets/texts.dart';
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
  final authService = AuthService();

  String _fullName = "";
  String _fullNameLogged = "";

  @override
  void initState() {
    super.initState();
    _getFullName();
  }

  _getFullName() async {
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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showLogoutModal(context);
                                  },
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
                                topRight: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: TextTitle(texto: "Dicas"),
                              ),
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    children: [
                                      ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Use óculos de sol",
                                        subtitulo:
                                            "Proteção contra raios UV e luz intensa",
                                      ),
                                      ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Evite luzes brilhantes",
                                        subtitulo:
                                            "Luz solar, fluorescentes e de flashs",
                                      ),
                                      ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Ajuste a iluminação interna",
                                        subtitulo:
                                            "Use lâmpadas de menor intensidade",
                                      ),
                                      ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Use filtros de tela",
                                        subtitulo:
                                            "Reduz o brilho e a intesidade de luz",
                                      ),
                                      ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Evite exposição prolongada",
                                        subtitulo:
                                            "Em ambientes muito iluminados",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextTitle(texto: "O que vamos fazer hoje?"),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: SizedBox(
                                        height: 300,
                                        child: GridView.count(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 8,
                                          childAspectRatio: 1.30,
                                          children: [
                                            OptionsGrid(
                                              imagem: "assets/analise_ia.png",
                                              nome: "Analisar vídeo",
                                              onTap: () => goToScreen
                                                  .goToIAVerifyPage(context),
                                            ),
                                            OptionsGrid(
                                              imagem: "assets/historico.png",
                                              nome: "Histórico",
                                              onTap: () => goToScreen
                                                  .goToHistoryPage(context),
                                            ),
                                            OptionsGrid(
                                              imagem: "assets/player.png",
                                              nome: "Video Player",
                                              onTap: () => goToScreen
                                                  .goToHistoryPage(context),
                                            ),
                                            OptionsGrid(
                                              imagem: "assets/config.png",
                                              nome: "Ajustes",
                                              onTap: () => goToScreen
                                                  .goToSettingsPage(context),
                                            ),
                                            OptionsGrid(
                                              imagem: "assets/config.png",
                                              nome: "Tela teste",
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TestPage(),
                                                  ),
                                                );
                                              },
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sair(BuildContext context) async {
    bool saiu = await exit();
    if (saiu) {
      Navigator.pop(context);
      goToScreen.goToFirstPage(context);
    }
  }

  Future<bool> exit() async {
    final success = await authService.doLogout();
    return success;
  }

  _showLogoutModal(BuildContext context) {
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
                "Sair do App",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Você deseja realmente sair?",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BtnLogout(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    "Não",
                  ),
                  BtnLogout(
                    onPressed: () {
                      Navigator.pop(context);
                      sair(context);
                    },
                    "Sim",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
