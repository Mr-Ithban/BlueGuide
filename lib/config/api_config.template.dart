/// API Configuration
///
/// IMPORTANT: This file contains sensitive API keys.
/// DO NOT commit this file with real keys to version control.
///
/// Instructions:
/// 1. Copy this file to create 'api_config.dart'
/// 2. Replace 'YOUR_GEMINI_API_KEY_HERE' with your actual Google Gemini API key
/// 3. Get your API key from: https://aistudio.google.com/app/apikey
/// 4. api_config.dart is already in .gitignore and won't be committed

class ApiConfig {
  // Google Gemini API Configuration
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  static const String geminiModel = 'gemini-2.0-flash-exp';
  static const String geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent';

  // Validation
  static bool get isConfigured =>
      geminiApiKey != 'YOUR_GEMINI_API_KEY_HERE' && geminiApiKey.isNotEmpty;
}
