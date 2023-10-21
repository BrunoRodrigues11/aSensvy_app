import 'package:apptesteapi/config/auth_service.dart';
import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/information.dart';
import 'package:apptesteapi/widgets/texts.dart';
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
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
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Use óculos de sol",
                                        subtitulo:
                                            "Proteção contra raios UV e luz intensa"),
                                    ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Evite luzes brilhantes",
                                        subtitulo:
                                            "Luz solar, fluorescentes e de flashs"),
                                    ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Ajuste a iluminação interna",
                                        subtitulo:
                                            "Use lâmpadas de menor intensidade"),
                                    ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Use filtros de tela",
                                        subtitulo:
                                            "Reduz o brilho e a intesidade de luz"),
                                    ListInformation(
                                        color: AppColors.primaryColor,
                                        tiulo: "Evite exposição prolongada",
                                        subtitulo:
                                            "Em ambientes muito iluminados"),
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
                                        ],
                                      ),
                                    ),
                                  )
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

  sair() async {
    bool saiu = await exit(context);
    if (saiu) {
      goToScreen.goToFirstPage(context);
    }
  }

  Future<bool> exit(BuildContext context) async {
    final success = await authService.doLogout(context);

    if (success) {
      return true;
    } else {
      return false;
    }
  }
}
