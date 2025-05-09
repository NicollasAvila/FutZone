import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:futzone/config/app_config.dart';

class UserService {
  static Future<Map<String, dynamic>> fetchUser(String email) async {
    final response =
        await http.get(Uri.parse('${AppConfig.backendUrl}/users?email=$email'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) return data.first;
      throw Exception('Usuário não encontrado');
    } else {
      throw Exception('Erro ao buscar usuário');
    }
  }

  static Future<void> updateUser(String id, Map<String, dynamic> update) async {
    print('Enviando dados para atualização do usuário: $update');
    print('Dados enviados para o backend: $update');
    final response = await http.put(
      Uri.parse('${AppConfig.backendUrl}/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(update),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar usuário');
    }
  }

  static Future<void> changePassword(String id, String currentPassword, String newPassword) async {
    final response = await http.put(
      Uri.parse('${AppConfig.backendUrl}/users/$id/password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao alterar senha: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchUserById(String userId) async {
    final response = await http.get(
      Uri.parse('${AppConfig.backendUrl}/users/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);

      // Garantir que os tipos estão corretos
      userData['phoneNumber'] = userData['phoneNumber']?.toString();

      return userData;
    } else {
      throw Exception('Erro ao buscar informações do usuário: ${response.body}');
    }
  }
}