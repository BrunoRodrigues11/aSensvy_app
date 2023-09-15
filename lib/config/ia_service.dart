import 'dart:convert';
import 'package:apptesteapi/model/history.dart';
import 'package:apptesteapi/widgets/alerts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class IaService {
  final String baseUrl = 'https://asensvy-production.up.railway.app/ia';

  Future<List<Historico>> doGetHistory(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var token = sharedPreferences.getString('token');
      var url = Uri.parse('$baseUrl/history');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      };

      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var historicoList = jsonData['history'] as List<dynamic>;

        List<Historico> historicos =
            historicoList.map((json) => Historico.fromJson(json)).toList();
        return historicos;
      } else {
        showErrorAlert(context,
            'Erro ao carregar histórico. Código: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      showErrorAlert(context, "Erro ao buscar histórico: $e");
      return [];
    }
  }
}
