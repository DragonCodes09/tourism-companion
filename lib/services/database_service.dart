import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String _usersKey = 'travel_sarthi_users';
  static const String _currentSessionKey = 'travel_sarthi_current_user_email';

  /// Generates a cryptographically secure random salt string
  String _generateSalt([int length = 16]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  /// Hashes a password with salt using SHA-256
  String hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt$password');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify input password against stored hash and salt
  bool verifyPassword(String inputPassword, String storedHash, String salt) {
    final computedHash = hashPassword(inputPassword, salt);
    return computedHash == storedHash;
  }

  /// Load all users from persistent database
  Future<List<UserModel>> _getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_usersKey) ?? [];
    return rawList.map((str) => UserModel.fromJson(str)).toList();
  }

  /// Save all users to persistent database
  Future<void> _saveAllUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = users.map((u) => u.toJson()).toList();
    await prefs.setStringList(_usersKey, rawList);
  }

  /// Check if an email is already registered
  Future<bool> isEmailRegistered(String email) async {
    final users = await _getAllUsers();
    final normalized = email.toLowerCase().trim();
    return users.any((u) => u.email == normalized);
  }

  /// Register a new user with hashed password & salt
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String preferredLanguage,
  }) async {
    final normalizedEmail = email.toLowerCase().trim();
    if (await isEmailRegistered(normalizedEmail)) {
      throw Exception('An account with this email already exists.');
    }

    final salt = _generateSalt();
    final passwordHash = hashPassword(password, salt);

    final newUser = UserModel(
      id: 'USR_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: normalizedEmail,
      phone: phone.trim(),
      passwordHash: passwordHash,
      salt: salt,
      preferredLanguage: preferredLanguage,
      createdAt: DateTime.now(),
    );

    final users = await _getAllUsers();
    users.add(newUser);
    await _saveAllUsers(users);

    // Save as currently active session
    await setSessionUser(newUser.email);

    return newUser;
  }

  /// Authenticate user credentials
  Future<UserModel?> loginUser(String email, String password) async {
    final users = await _getAllUsers();
    final normalized = email.toLowerCase().trim();

    final user = users.cast<UserModel?>().firstWhere(
          (u) => u?.email == normalized,
          orElse: () => null,
        );

    if (user == null) {
      return null; // User not found
    }

    final isValid = verifyPassword(password, user.passwordHash, user.salt);
    if (!isValid) {
      return null; // Incorrect password
    }

    // Save current session
    await setSessionUser(user.email);
    return user;
  }

  /// Set the active session email
  Future<void> setSessionUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentSessionKey, email.toLowerCase().trim());
  }

  /// Get the current logged in user (if any)
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_currentSessionKey);
    if (email == null) return null;

    final users = await _getAllUsers();
    return users.cast<UserModel?>().firstWhere(
          (u) => u?.email == email,
          orElse: () => null,
        );
  }

  /// Clear the active session (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentSessionKey);
  }
}
