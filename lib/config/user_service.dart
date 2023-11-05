import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'https://asensvy-production.up.railway.app/myuser';

  Future<bool> updateUser(
      String firstName,
      String lastName,
      String email,
      String phone,
      String newPassword,
      String currentPassword,
      String token) async {
    var url = Uri.parse('https://asensvy-production.up.railway.app/myuser');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'password': newPassword,
      'oldPassword': currentPassword,
    });

    var response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
