import 'package:aSensvy/config/helper_functions.dart';
import 'package:aSensvy/config/theme.dart';
import 'package:aSensvy/widgets/graph.dart';
import 'package:aSensvy/widgets/texts.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailsPage extends StatefulWidget {
  String title;
  String score;
  String date;
  String risco;
  String file;

  DetailsPage(
      {super.key,
      required this.title,
      required this.score,
      required this.date,
      required this.risco,
      required this.file});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();
  late Uri fileUri;
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();

    // // Inicialize a variável fileUri usando o valor da propriedade 'file' do widget
    fileUri = Uri.parse(widget.file);

    // // Inicialize o FlickManager com a URI do arquivo
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.networkUrl(fileUri),
      autoPlay: false,
    );
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
    // color background #E4E9F7
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
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                goToScreen.goToHistoryPage(context);
                                flickManager.dispose();
                                super.dispose();
                              },
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
                          "Detalhes",
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      exibirVideo();
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 200,
                                          width: 400,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  AssetImage("assets/play.png"),
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                Colors.black45,
                                                BlendMode.darken,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Positioned(
                                          top: 50,
                                          left: 140,
                                          child: Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.secundaryBgCard,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Column(
                                        children: [
                                          TextTitle(texto: "Informações"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              TextSubtitle(texto: "Título: "),
                                              TextBody(texto: widget.title)
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              TextSubtitle(
                                                  texto: "Data de análise: "),
                                              TextBody(texto: widget.date)
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              TextSubtitle(texto: "Risco: "),
                                              TextBody(texto: widget.risco)
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          TextTitle(texto: "Estatísticas"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ScoreGraph(score: widget.score),
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
    );
  }

  void exibirVideo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.title),
          content: SizedBox(
            width: 300,
            height: 500,
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: FlickVideoPlayer(
                flickManager: flickManager,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                flickManager.flickVideoManager?.videoPlayerController!.pause();
                Navigator.of(context).pop();
              },
              child: const Text("Fechar"),
            )
          ],
        );
      },
    );
  }
}
