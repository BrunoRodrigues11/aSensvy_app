import 'dart:io';
import 'package:apptesteapi/pages/init_page.dart';
import 'package:apptesteapi/widgets/buttons.dart';
import 'package:apptesteapi/widgets/navbar.dart';
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
  final _formkey = GlobalKey<FormState>();
  final _token = "";
  String _fullName = "";  
  String _fullNameLogged = "";
  File _videoFile = File("");
  File? file;

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

  _body() { // color background #E4E9F7
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
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Analisar vídeo",
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Para começar, selecione um vídeo",
                          style: TextStyle(
                            fontSize: 15, 
                            color: Colors.grey[50],
                          ),
                        ),
                        SizedBox(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
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

  void _selectVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File arquivoSelecionado = File(result.files.single.path!);

      // Agora você pode enviar o arquivo para o servidor ou fazer o que for necessário com ele
      _uploadVideo(arquivoSelecionado);
    } else {
      // Usuário cancelou a seleção do arquivo
    }
  }

  Future<void> _uploadVideo(File file) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var token = sharedPreferences.getString('token');

      var url = Uri.parse('https://asensvy-production.up.railway.app/ia/verify'); 
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('files[]', file.path));
      request.headers['Authorization'] = '$token';

      var response = await request.send(); 

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Sucesso'),
            content: Text('Vídeo enviado com sucesso.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Erro'),
            content: Text('Falha ao enviar o vídeo. Código de status: ${response.statusCode}'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      
    }
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