import 'dart:convert';
import 'package:apptesteapi/widgets/alerts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthService {
  final String baseUrl = 'https://asensvy-production.up.railway.app';

  // LOGIN
  Future<bool> doLogin(
      BuildContext context, String email, String password) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final url = Uri.parse('$baseUrl/auth');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'password': password, 'email': email});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = "Token ${responseBody['token']}";
        final fullName = "FullName ${responseBody['user']['fullName']}";

        await sharedPreferences.setString('token', token);
        await sharedPreferences.setString('fullName', fullName);

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

  // CADASTRO
  Future<bool> doSignUp(BuildContext context, String firstName, String lastName,
      String email, String phone, String password) async {
    try {
      final url = Uri.parse('$baseUrl/users');
      final headers = {'Content-Type': 'application/json'};
      final objeto = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password
      };

      final jsonBody = jsonEncode(objeto);
      final response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 201) {
        showSuccessAlert(context, "Cadastro realizado com sucesso!");
        return true;
      } else {
        showErrorAlert(
            context, 'Algo deu errado. Código: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      showErrorAlert(context, "Erro ao enviar objeto: $e");
      return false;
    }
  }

  // SAIR
  Future<bool> doLogout(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear();
      return true;
    } catch (e) {
      showErrorAlert(context, 'Algo deu errado.');
      return false;
    }
  }
}
