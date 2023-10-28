import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'https://asensvy-production.up.railway.app';

  // LOGIN
  Future<bool> doLogin(String email, String password) async {
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
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // CADASTRO
  Future<bool> doSignUp(String firstName, String lastName, String email,
      String phone, String password) async {
    try {
      final url = Uri.parse('$baseUrl/users');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password
      };

      final jsonBody = jsonEncode(body);
      final response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // SAIR
  Future<bool> doLogout() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}
