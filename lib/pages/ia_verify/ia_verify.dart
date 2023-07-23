import 'dart:io';
import 'package:apptesteapi/config/helper_functions.dart';
import 'package:apptesteapi/config/theme.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IaVerify extends StatefulWidget {
  const IaVerify({super.key});

  @override
  State<IaVerify> createState() => _IaVerifyState();
}

class _IaVerifyState extends State<IaVerify> {
  // INSTÂNCIA DA CLASSE DE ROTAS DE TELAS
  GoToScreen goToScreen = GoToScreen();  
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: _body(),
      extendBody: true,
      extendBodyBehindAppBar: true,
    );
  }

  _body() { // color background #E4E9F7
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
                          "Analisar vídeo",
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Para começar, selecione um vídeo",
                          style: TextStyle(
                            fontSize: 15, 
                            color: Colors.grey[50],
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
                                  Image.asset(
                                    "assets/select_video.png",
                                    width: 300,
                                    height: 300,
                                  ),
                                ],
                              ),
                            ),
                            BtnDefault(
                              "Selecionar video",
                              onPressed: _selectVideo,
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

  // SELECIONAR O VÍDEO 
  void _selectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File arquivoSelecionado = File(result.files.single.path!);
      _uploadVideo(arquivoSelecionado);
    } else {
      // Usuário cancelou a seleção do arquivo
    }
  }

  // UPLOAD DO VÍDEO
  Future<void> _uploadVideo(File file) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Aguarde'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              CircularProgressIndicator(),
              Text('Enviando vídeo...'),
            ],
          ),
        ),
      );

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString('token');
      var url = Uri.parse('https://asensvy-production.up.railway.app/ia/verify'); 
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('files[]', file.path));
      request.headers['Authorization'] = '$token';

      var response = await request.send(); 

      Navigator.of(context).pop(); // Fecha o diálogo de progresso

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Vídeo enviado com sucesso.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => goToScreen.goToHistoryPage(context),
              ),
            ],
          ),
        );    
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: Text('Falha ao enviar o vídeo. Código de status: ${response.statusCode}'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      
    }
  }
}