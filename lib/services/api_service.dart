import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'database_service.dart';
import 'otp_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final DatabaseService _localDb = DatabaseService();
  final OtpService _localOtp = OtpService();

  /// Determine host based on environment (Android Emulator vs Desktop/Web)
  String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api/auth';
    }
    try {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:5000/api/auth';
      }
    } catch (_) {}
    return 'http://localhost:5000/api/auth';
  }

  /// Check if the backend server is reachable
  Future<bool> isBackendOnline() async {
    try {
      final healthUrl = baseUrl.replaceAll('/api/auth', '/api/health');
      final res = await http.get(Uri.parse(healthUrl)).timeout(
            const Duration(seconds: 2),
          );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Check if email is registered (Backend with local fallback)
  Future<bool> isEmailRegistered(String email) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/check-email'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': email}),
          )
          .timeout(const Duration(seconds: 3));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data['exists'] == true;
      }
    } catch (e) {
      debugPrint('[ApiService] Backend offline, checking local DB: $e');
    }
    return _localDb.isEmailRegistered(email);
  }

  /// Request OTP for email verification (Backend with local fallback)
  Future<String> sendOtp(String email) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/send-otp'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': email}),
          )
          .timeout(const Duration(seconds: 3));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return data['otp']?.toString() ?? '1234';
      } else {
        final data = json.decode(res.body);
        throw Exception(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      debugPrint('[ApiService] Backend offline, generating local OTP: $e');
    }
    return _localOtp.generateOtp(email);
  }

  /// Verify OTP code (Backend with local fallback)
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/verify-otp'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': email, 'otp': otp}),
          )
          .timeout(const Duration(seconds: 3));

      if (res.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('[ApiService] Backend offline, validating via local OTP: $e');
    }
    return _localOtp.verifyOtp(email, otp);
  }

  /// Register user with hashed password & salt (Backend with local fallback)
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String preferredLanguage,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': name,
              'email': email,
              'phone': phone,
              'password': password,
              'preferredLanguage': preferredLanguage,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 201) {
        final data = json.decode(res.body);
        final userData = data['user'] as Map<String, dynamic>;

        // Also sync to local session
        final user = UserModel(
          id: userData['id'] ?? 'USR_${DateTime.now().millisecondsSinceEpoch}',
          name: userData['name'],
          email: userData['email'],
          phone: userData['phone'],
          passwordHash: '[Stored Securely on Server Database]',
          salt: '[Encrypted Salt]',
          preferredLanguage: userData['preferredLanguage'] ?? 'English',
          createdAt: DateTime.tryParse(userData['createdAt'] ?? '') ??
              DateTime.now(),
        );
        await _localDb.setSessionUser(user.email);
        return user;
      } else {
        final data = json.decode(res.body);
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      debugPrint('[ApiService] Backend offline, registering in local DB: $e');
    }

    // Local DB fallback
    return _localDb.registerUser(
      name: name,
      email: email,
      phone: phone,
      password: password,
      preferredLanguage: preferredLanguage,
    );
  }

  /// Authenticate login credentials (Backend with local fallback)
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final userData = data['user'] as Map<String, dynamic>;

        final user = UserModel(
          id: userData['id'] ?? 'USR_${DateTime.now().millisecondsSinceEpoch}',
          name: userData['name'],
          email: userData['email'],
          phone: userData['phone'],
          passwordHash: '[Stored Securely on Server Database]',
          salt: '[Encrypted Salt]',
          preferredLanguage: userData['preferredLanguage'] ?? 'English',
          createdAt: DateTime.tryParse(userData['createdAt'] ?? '') ??
              DateTime.now(),
        );
        await _localDb.setSessionUser(user.email);
        return user;
      } else if (res.statusCode == 401 || res.statusCode == 404) {
        return null;
      }
    } catch (e) {
      debugPrint('[ApiService] Backend offline, logging in via local DB: $e');
    }

    return _localDb.loginUser(email, password);
  }
}
