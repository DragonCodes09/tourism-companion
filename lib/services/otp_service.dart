import 'dart:math';

class OtpService {
  static final OtpService _instance = OtpService._internal();
  factory OtpService() => _instance;
  OtpService._internal();

  final Map<String, _OtpRecord> _otpStore = {};

  /// Generate a 4-digit OTP for the given email
  String generateOtp(String email) {
    final normalized = email.toLowerCase().trim();
    final random = Random();
    final code = (1000 + random.nextInt(9000)).toString(); // e.g. 4829
    _otpStore[normalized] = _OtpRecord(
      code: code,
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );
    return code;
  }

  /// Verify if the entered OTP matches and is not expired
  bool verifyOtp(String email, String enteredCode) {
    final normalized = email.toLowerCase().trim();
    final record = _otpStore[normalized];
    if (record == null) return false;

    if (DateTime.now().isAfter(record.expiresAt)) {
      _otpStore.remove(normalized);
      return false; // Expired
    }

    final isValid = record.code.trim() == enteredCode.trim();
    if (isValid) {
      _otpStore.remove(normalized); // Invalidate once used
    }
    return isValid;
  }

  /// Get current OTP for debugging or demo convenience
  String? peekOtp(String email) {
    final normalized = email.toLowerCase().trim();
    return _otpStore[normalized]?.code;
  }
}

class _OtpRecord {
  final String code;
  final DateTime expiresAt;

  _OtpRecord({required this.code, required this.expiresAt});
}
