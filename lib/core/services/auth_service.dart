import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../constants/app_constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        AppConstants.loginUrl,
        {
          'email': email,
          'password': password,
        },
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = responseData['token'];
        final user = UserModel.fromJson(responseData['user']);
        
        // Simpan ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.prefTokenKey, token);
        await prefs.setString(AppConstants.prefUserKey, json.encode(user.toJson()));
        
        return {'success': true, 'token': token, 'user': user};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Email atau password salah.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': AppConstants.errorGeneric};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _apiService.post(
        AppConstants.registerUrl,
        {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      final responseData = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = responseData['token'];
        final user = UserModel.fromJson(responseData['user']);
        
        // Simpan ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.prefTokenKey, token);
        await prefs.setString(AppConstants.prefUserKey, json.encode(user.toJson()));
        
        return {'success': true, 'token': token, 'user': user};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Pendaftaran gagal. Silakan coba data lain.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': AppConstants.errorGeneric};
    }
  }

  Future<void> logout(String token) async {
    try {
      await _apiService.post(AppConstants.logoutUrl, {}, token: token);
    } catch (_) {
      // Abaikan error jaringan saat logout, hapus session lokal saja
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.prefTokenKey);
      await prefs.remove(AppConstants.prefUserKey);
    }
  }
}
