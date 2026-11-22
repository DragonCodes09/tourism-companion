import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_sarthi/services/database_service.dart';
import 'package:travel_sarthi/services/otp_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('OtpService Tests', () {
    final otpService = OtpService();

    test('generates 4-digit numeric OTP and verifies successfully', () {
      const email = 'traveler@example.com';
      final otp = otpService.generateOtp(email);

      expect(otp.length, 4);
      expect(int.tryParse(otp), isNotNull);

      // Verify correct OTP
      final isVerified = otpService.verifyOtp(email, otp);
      expect(isVerified, isTrue);

      // Second verification should fail (OTP consumed)
      final isReverified = otpService.verifyOtp(email, otp);
      expect(isReverified, isFalse);
    });

    test('fails verification on wrong OTP', () {
      const email = 'user2@example.com';
      otpService.generateOtp(email);

      final isVerified = otpService.verifyOtp(email, '0000');
      expect(isVerified, isFalse);
    });
  });

  group('DatabaseService Password Hashing & Auth Tests', () {
    final dbService = DatabaseService();

    test('hashes password using SHA-256 and salt', () {
      const password = 'Travel@123';
      const salt = 'randomSalt12345';

      final hash1 = dbService.hashPassword(password, salt);
      final hash2 = dbService.hashPassword(password, salt);

      expect(hash1, equals(hash2));
      expect(hash1.length, 64); // SHA-256 hex string is 64 characters

      // Verify correct password
      expect(dbService.verifyPassword(password, hash1, salt), isTrue);

      // Reject incorrect password
      expect(dbService.verifyPassword('WrongPass#99', hash1, salt), isFalse);
    });

    test('registers user and authenticates during login', () async {
      final user = await dbService.registerUser(
        name: 'Aarav Patel',
        email: 'aarav@travel.in',
        phone: '9876543210',
        password: 'Pass@123word',
        preferredLanguage: 'Gujarati',
      );

      expect(user.id, startsWith('USR_'));
      expect(user.email, equals('aarav@travel.in'));
      expect(user.passwordHash.length, equals(64)); // Verified hashed!

      // Successful login
      final loggedInUser = await dbService.loginUser('aarav@travel.in', 'Pass@123word');
      expect(loggedInUser, isNotNull);
      expect(loggedInUser!.name, equals('Aarav Patel'));
      expect(loggedInUser.preferredLanguage, equals('Gujarati'));

      // Failed login with wrong password
      final failedUser = await dbService.loginUser('aarav@travel.in', 'Incorrect@123');
      expect(failedUser, isNull);

      // Duplicate email registration should throw exception
      expect(
        () => dbService.registerUser(
          name: 'Another User',
          email: 'aarav@travel.in',
          phone: '9998887770',
          password: 'Pass@123word',
          preferredLanguage: 'Hindi',
        ),
        throwsException,
      );
    });
  });

  group('Password Security Requirement Validation Tests', () {
    bool validatePassword(String text) {
      final hasMin8 = text.length >= 8;
      final hasUpper = RegExp(r'[A-Z]').hasMatch(text);
      final hasLower = RegExp(r'[a-z]').hasMatch(text);
      final hasNumber = RegExp(r'[0-9]').hasMatch(text);
      final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-=+]').hasMatch(text);
      return hasMin8 && hasUpper && hasLower && hasNumber && hasSpecial;
    }

    test('validates 1 capital, small, number, special char, min 8 chars', () {
      expect(validatePassword('Travel@2026'), isTrue);
      expect(validatePassword('Sarthi#1a'), isTrue);

      // Failures
      expect(validatePassword('travel@123'), isFalse); // No capital
      expect(validatePassword('TRAVEL@123'), isFalse); // No small
      expect(validatePassword('Travel@@@@'), isFalse); // No number
      expect(validatePassword('Travel1234'), isFalse); // No special char
      expect(validatePassword('Tr@1'), isFalse); // Under 8 chars
    });
  });
}
