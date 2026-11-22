class AppLanguage {
  final String code;
  final String englishName;
  final String nativeName;
  final String greeting;
  final String region;

  const AppLanguage({
    required this.code,
    required this.englishName,
    required this.nativeName,
    required this.greeting,
    required this.region,
  });
}

const List<AppLanguage> kSupportedLanguages = [
  AppLanguage(
    code: 'en',
    englishName: 'English',
    nativeName: 'English',
    greeting: 'Welcome',
    region: 'Global / All India',
  ),
  AppLanguage(
    code: 'hi',
    englishName: 'Hindi',
    nativeName: 'हिन्दी',
    greeting: 'नमस्ते',
    region: 'North & Central India',
  ),
  AppLanguage(
    code: 'bn',
    englishName: 'Bengali',
    nativeName: 'বাংলা',
    greeting: 'নমস্কার',
    region: 'West Bengal & East India',
  ),
  AppLanguage(
    code: 'te',
    englishName: 'Telugu',
    nativeName: 'తెలుగు',
    greeting: 'నమస్కారం',
    region: 'Andhra Pradesh & Telangana',
  ),
  AppLanguage(
    code: 'mr',
    englishName: 'Marathi',
    nativeName: 'मराठी',
    greeting: 'नमस्कार',
    region: 'Maharashtra',
  ),
  AppLanguage(
    code: 'ta',
    englishName: 'Tamil',
    nativeName: 'தமிழ்',
    greeting: 'வணக்கம்',
    region: 'Tamil Nadu & Puducherry',
  ),
  AppLanguage(
    code: 'gu',
    englishName: 'Gujarati',
    nativeName: 'ગુજરાતી',
    greeting: 'નમસ્તે',
    region: 'Gujarat',
  ),
  AppLanguage(
    code: 'kn',
    englishName: 'Kannada',
    nativeName: 'ಕನ್ನಡ',
    greeting: 'ನಮಸ್ಕಾರ',
    region: 'Karnataka',
  ),
  AppLanguage(
    code: 'ml',
    englishName: 'Malayalam',
    nativeName: 'മലയാളം',
    greeting: 'നമസ്കാരം',
    region: 'Kerala',
  ),
  AppLanguage(
    code: 'pa',
    englishName: 'Punjabi',
    nativeName: 'ਪੰਜਾਬੀ',
    greeting: 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ',
    region: 'Punjab',
  ),
  AppLanguage(
    code: 'or',
    englishName: 'Odia',
    nativeName: 'ଓଡ଼ିଆ',
    greeting: 'ନମସ୍କାର',
    region: 'Odisha',
  ),
  AppLanguage(
    code: 'as',
    englishName: 'Assamese',
    nativeName: 'অসমীয়া',
    greeting: 'নমস্কাৰ',
    region: 'Assam & North East',
  ),
];
