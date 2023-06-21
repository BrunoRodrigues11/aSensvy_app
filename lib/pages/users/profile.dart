import 'package:apptesteapi/pages/home/home.dart';
import 'package:apptesteapi/pages/init_page.dart';
import 'package:apptesteapi/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      backgroundColor: const Color(0xff034694),
      body: _body(),
    );
  }

  _body() { 
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: const Color(0xff034694), 
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _back(),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "Perfil",
                          style: TextStyle(
                            fontSize: 30, 
                            fontWeight: FontWeight.bold,
                            color: Colors.white
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
                              offset: const Offset(0, 3), // deslocamento horizontal e vertical da sombra
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

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
  
    
  _back() async {
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const Home()));
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
