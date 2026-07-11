import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class ApiService {
  final String _baseUrl = AppConstants.baseUrl;

  Map<String, String> _getHeaders(String? token, {bool isMultipart = false}) {
    final Map<String, String> headers = {};
    if (!isMultipart) {
      headers['Content-Type'] = 'application/json';
      headers['Accept'] = 'application/json';
    } else {
      headers['Accept'] = 'application/json';
    }
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.get(url, headers: _getHeaders(token));
      return response;
    } catch (e) {
      throw Exception(AppConstants.errorNetwork);
    }
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body, {String? token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(token),
        body: json.encode(body),
      );
      return response;
    } catch (e) {
      throw Exception(AppConstants.errorNetwork);
    }
  }

  Future<http.Response> postMultipart(
    String endpoint, 
    Map<String, String> fields, 
    String? filePath, 
    String fileField, 
    {String? token}
  ) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll(_getHeaders(token, isMultipart: true));
      
      request.fields.addAll(fields);
      
      if (filePath != null && filePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath(fileField, filePath));
      }
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      throw Exception(AppConstants.errorNetwork);
    }
  }

  Future<http.Response> delete(String endpoint, {String? token}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await http.delete(url, headers: _getHeaders(token));
      return response;
    } catch (e) {
      throw Exception(AppConstants.errorNetwork);
    }
  }
}
