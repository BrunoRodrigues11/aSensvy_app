import 'package:apptesteapi/pages/init_page.dart';
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Sair",
                              style: TextStyle(
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
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Text(
                            "Olá, $_fullNameLogged",
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
