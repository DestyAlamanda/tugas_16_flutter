import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tugas16_flutter/model/user_model.dart';
import 'package:tugas16_flutter/services/endpoint/endpoint.dart';

class AuthenticationAPI {
  static Future<UserModel> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final url = Uri.parse(Endpoint.register);
    final response = await http.post(
      url,
      body: {"name": name, "email": email, "password": password},
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  static Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(Endpoint.login);
    final response = await http.post(
      url,
      body: {"email": email, "password": password},
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Register gagal");
    }
  }

  // static Future<GetUserModel> updateUser({required String name}) async {
  //   final url = Uri.parse(Endpoint.profile);
  //   final token = await PreferenceHandler.getToken();

  //   final response = await http.post(
  //     url,
  //     body: {"name": name},
  //     headers: {"Accept": "application/json", "Authorization": token},
  //   );
  //   if (response.statusCode == 200) {
  //     return GetUserModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Register gagal");
  //   }
  // }

  // static Future<GetUserModel> getProfile() async {
  //   final url = Uri.parse(Endpoint.profile);
  //   final token = await PreferenceHandler.getToken();
  //   final response = await http.get(
  //     url,
  //     headers: {"Accept": "application/json", "Authorization": token},
  //   );
  //   if (response.statusCode == 200) {
  //     return GetUserModel.fromJson(json.decode(response.body));
  //   } else {
  //     final error = json.decode(response.body);
  //     throw Exception(error["message"] ?? "Register gagal");
  //   }
  // }
}
