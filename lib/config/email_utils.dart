import 'dart:convert';
import 'package:apptesteapi/widgets/alerts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EmailUtils {
  final String baseUrl = 'https://asensvy-production.up.railway.app/recoverPassword';

  Future<bool> doSendEmail(BuildContext context, String email) async {
    try {
      var url = Uri.parse('$baseUrl/send');
      var objeto = {'email': email};

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 201) {
        return true;
      } else {
        showErrorAlert(context, 'Algo deu errado. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      showErrorAlert(context, "Erro ao enviar objeto: $e");
      return false; 
    }
  }

  Future<bool> doVerifyCode(BuildContext context, String email, String code) async {
    try {
      var url = Uri.parse('$baseUrl/verify');
      var objeto = {
        'email': email,
        'code': code
      };

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        return true;
      } else {
        showErrorAlert(context, 'Algo deu errado. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      showErrorAlert(context, "Erro ao enviar objeto: $e");
      return false; 
    }
  }

  Future<bool> doSetNewPassword(BuildContext context, String email, String password) async {
    try {
      var url = Uri.parse('$baseUrl/newpassword');
      var objeto = {
        'email': email,
        'password': password
      };

      var headers = {'Content-Type': 'application/json'};
      var jsonBody = jsonEncode(objeto);
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 200) {
        return true;
      } else {
        showErrorAlert(context, 'Algo deu errado. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      showErrorAlert(context, "Erro ao enviar objeto: $e");
      return false; 
    }
  }
}
