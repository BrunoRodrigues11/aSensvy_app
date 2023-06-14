import 'dart:io';
import 'package:apptesteapi/pages/init_page.dart';
import 'package:file_picker/file_picker.dart';
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
  final _formkey = GlobalKey<FormState>();
  final _token = "";
  File _videoFile = File("");
  File? file;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Home Page",
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
              sair();
            },
            child: Text("Sair"),
          ),
        ],
      ),
      body: _body(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Color(0xff0095FF),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary), 
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: (){
                    // _settingsPage(context, page)
                  }, 
                ),

                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: (){
                    _homePage(context, Home());
                  }, 
                ),

                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: (){
                    // _profilePage(context, page);
                  }, 
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _body() {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[                  
                            // começa aqui
                            ElevatedButton(
                              onPressed: _selectVideo,
                              child: Text('Selecionar Vídeo'),
                            ),
                            SizedBox(height: 20),
                            // ElevatedButton(
                            //   onPressed: _uploadVideo(context),
                            //   child: Text('Enviar Vídeo'),
                            // ),
                            SizedBox(
                              height: 200.0,
                              width: 300.0,
                              child: _videoFile == null
                                  ? const Center(child: Text('Sorry nothing selected!!'))
                                  : Center(child: Text(_videoFile.path)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
      print("TOKEN: $token");
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
        print("DEU TUDO ERRADO AAAAAAAAAAAAAAA${response}");
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
    // var videoStream = http.ByteStream(_videoFile.openRead());
    // var videoLength = await _videoFile.length();
  }

  _homePage(ctx, page) {
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
      Navigator.pushReplacement(  
        context,
        MaterialPageRoute(
          builder: (context) => FirstPage(),
        ),
      );
    }
  }

  Future<bool> doLogout() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
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
