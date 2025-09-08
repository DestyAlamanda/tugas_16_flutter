import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tugas16_flutter/api/endpoint/endpoint.dart';
import 'package:tugas16_flutter/model/menu_model.dart';
import 'package:tugas16_flutter/model/register_model.dart';
import 'package:tugas16_flutter/model/reservasi_model.dart';
import 'package:tugas16_flutter/model/user_model.dart';
import 'package:tugas16_flutter/preference/shared_preference.dart';

class AuthenticationAPI {
  // register user
  static Future<RegisterUserModel> registerUser({
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
      return RegisterUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Request gagal");
    }
  }

  //  login user
  static Future<RegisterUserModel> loginUser({
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
      return RegisterUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Login gagal");
    }
  }

  // update profile
  static Future<GetUserModel> updateUser({required String name}) async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login ulang");
    }

    final response = await http.put(
      url,
      body: {"name": name},
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return GetUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Update profil gagal");
    }
  }

  //  get profile
  static Future<GetUserModel> getProfile() async {
    final url = Uri.parse(Endpoint.profile);
    final token = await PreferenceHandler.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login ulang");
    }

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return GetUserModel.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error["message"] ?? "Gagal mengambil profil");
    }
  }

  // get menus
  static Future<List<MenuModel>> getMenus() async {
    final url = Uri.parse(Endpoint.menus);
    final token = await PreferenceHandler.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login ulang");
    }

    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print("DEBUG STATUS: ${response.statusCode}");
    print("DEBUG BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List).map((e) => MenuModel.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Unauthenticated");
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  // add menu
  static Future<String> addMenu(
    String name,
    String description,
    String price,
    File? image,
  ) async {
    final url = Uri.parse(Endpoint.menus);
    final token = await PreferenceHandler.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login ulang");
    }

    String? imageBase64;
    if (image != null) {
      final bytes = await image.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }

    final body = {"name": name, "description": description, "price": price};

    if (imageBase64 != null) {
      body["image"] = imageBase64;
    }

    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: body,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return "success";
    } else {
      throw Exception(data['message'] ?? "Gagal menambahkan menu");
    }
  }

  static Future<String> updateMenu(
    int id,
    String name,
    String description,
    String price,
    File? image,
  ) async {
    final token = await PreferenceHandler.getToken();

    if (token == null) {
      throw Exception("Token tidak ditemukan, silakan login ulang");
    }

    String? imageBase64;
    if (image != null) {
      final bytes = await image.readAsBytes();
      imageBase64 = base64Encode(bytes);
    }

    final url = Uri.parse("${Endpoint.menus}/$id");
    final res = await http.put(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "name": name,
        "description": description,
        "price": price,
        if (imageBase64 != null) "image": imageBase64,
      },
    );

    final data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      return data['message'] ?? "Menu berhasil diperbarui";
    } else {
      throw Exception(data['message'] ?? "Gagal update menu");
    }
  }

  // Hapus menu
  static Future<String> deleteMenu(int id) async {
    final token = await PreferenceHandler.getToken();
    if (token == null) throw Exception("Token tidak ditemukan");

    final url = Uri.parse("${Endpoint.menus}/$id");
    final response = await http.delete(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) return "success";
    throw Exception(data['message'] ?? "Gagal menghapus menu");
  }

  static Future<String> createReservation({
    required String reservedAt,
    required int guestCount,
    required String notes,
  }) async {
    final token = await PreferenceHandler.getToken();
    if (token == null)
      throw Exception("Token tidak ditemukan, silakan login ulang");

    final url = Uri.parse(Endpoint.reservations); // pakai Endpoint.reservations
    final response = await http.post(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "reserved_at": reservedAt,
        "guest_count": guestCount.toString(),
        "notes": notes,
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return "success";
    } else {
      throw Exception(data['message'] ?? "Gagal membuat reservasi");
    }
  }

  static Future<List<ReservationModel>> getReservations() async {
    final token = await PreferenceHandler.getToken();
    if (token == null)
      throw Exception("Token tidak ditemukan, silakan login ulang");

    final url = Uri.parse(Endpoint.reservations);
    final response = await http.get(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return (data['data'] as List)
          .map((e) => ReservationModel.fromJson(e))
          .toList();
    } else {
      throw Exception(data['message'] ?? "Gagal mengambil reservasi");
    }
  }

  static Future<String> cancelReservation(int id) async {
    final token = await PreferenceHandler.getToken();
    if (token == null)
      throw Exception("Token tidak ditemukan, silakan login ulang");

    final url = Uri.parse('${Endpoint.reservations}/$id');
    final response = await http.delete(
      url,
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return "success";
    } else {
      throw Exception(data['message'] ?? "Gagal membatalkan reservasi");
    }
  }
}
