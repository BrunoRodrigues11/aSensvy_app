import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apptesteapi/widgets/alerts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserService {
  final String baseUrl = 'https://asensvy-production.up.railway.app/myuser';

  // EDITAR PERFIL
  Future<bool> doEdit(
      BuildContext context,
      String nome,
      String sobrenome,
      String telefone,
      String email,
      String senhaAtual,
      String senhaNova) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final url = Uri.parse(baseUrl);
      final headers = {
        'Content-Type': 'application/json',
        // 'Authorization': '$token',
      };
      final body = jsonEncode({
        'firstName': nome,
        'lastName': sobrenome,
        'email': telefone,
        'phone': telefone,
        'password': senhaNova,
        "oldPassword": senhaAtual,
      });
      var response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return true;
      } else {
        showErrorAlert(context, 'Email ou senha incorreta.');
        return false;
      }
    } catch (e) {
      showErrorAlert(context, "Erro ao enviar objeto: $e");
      return false;
    }
  }
}
