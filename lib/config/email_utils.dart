import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailUtils {
  final String baseUrl =
      'https://asensvy-production.up.railway.app/recoverPassword';

  // ENVIAR EMAIL COM CÓDIGO DE VERIFICAÇÃO
  Future<bool> doSendEmail(String email) async {
    var url = Uri.parse('$baseUrl/send');
    var objeto = {'email': email};

    var headers = {'Content-Type': 'application/json'};
    var jsonBody = jsonEncode(objeto);
    var response = await http.post(url, headers: headers, body: jsonBody);

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // VERIFICAR O CÓDIGO
  Future<bool> doVerifyCode(String email, String code) async {
    var url = Uri.parse('$baseUrl/verify');
    var objeto = {'email': email, 'code': code};

    var headers = {'Content-Type': 'application/json'};
    var jsonBody = jsonEncode(objeto);
    var response = await http.post(url, headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ALTERAR A SENHA
  Future<bool> doSetNewPassword(String email, String password) async {
    var url = Uri.parse('$baseUrl/newpassword');
    var objeto = {'email': email, 'password': password};

    var headers = {'Content-Type': 'application/json'};
    var jsonBody = jsonEncode(objeto);
    var response = await http.post(url, headers: headers, body: jsonBody);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
