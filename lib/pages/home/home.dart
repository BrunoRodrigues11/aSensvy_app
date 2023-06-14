import 'dart:convert';
import 'dart:io';
import 'package:apptesteapi/model/history.dart';
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
          Column(
            children: <Widget>[
              SizedBox(
                height: 35,
              ),
              Text(
                "Bem-vindo ao aSensvy",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Para começar, selecione um vídeo",
                style:
                    TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),
              SizedBox(
                height: 20,
              ),              
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              padding: EdgeInsets.only(top: 3, left: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border(
                  bottom: BorderSide(color: Colors.black),
                  top: BorderSide(color: Colors.black),
                  left: BorderSide(color: Colors.black),
                  right: BorderSide(color: Colors.black),
                )
              ),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: 
                  _selectVideo,
                
                color: Color(0xff0095FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Selecionar video",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text(
                "Histórico",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<Historico>>(
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
                          "Arquivo: ${historico.name.toString()}" ,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        subtitle: Text(
                          "Score: ${historico.score.toString()}"
                        ),
                      );
                    },
                  );
                } else {
                  return Text("Nenhum dado disponível.");
                }
              },
            ),
          ),
        ],
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
        pegarHistorico();
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
