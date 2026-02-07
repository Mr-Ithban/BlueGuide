import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class OnlineAIService {
  static Future<String> getResponse(String message) async {
    // Check if API key is configured
    if (!ApiConfig.isConfigured) {
      return """⚠️ API Key Not Configured

To use Online Mode, you need to add your Google Gemini API key:

1. Get a FREE API key at: https://aistudio.google.com/app/apikey
2. Open: lib/config/api_config.dart
3. Replace 'YOUR_GEMINI_API_KEY_HERE' with your actual key

Gemini API is FREE with generous limits! ✅

For now, switch to Offline Mode 🔴 to use the local database.""";
    }

    try {
      // Expert system prompt for coastal/fishermen domain
      final expertPrompt =
          """You are BlueGuide AI, an expert assistant for Indian coastal fishermen, particularly in Kerala.

Your expertise includes:
- Indian marine fish species (Mackerel, Sardine, Prawns, Pomfret, Tuna, etc.)
- Traditional and modern fishing techniques
- Safety protocols for fishing activities
- Weather patterns, monsoon seasons, and their impact on fishing
- Government schemes, subsidies, and welfare programs for fishermen
- Marine regulations and fishing laws in India
- Coastal ecosystem and conservation
- Fish market prices and economics
- Boat maintenance and equipment
- Navigation and GPS usage

Guidelines:
- Provide accurate, practical advice relevant to Indian fishermen
- Use simple, clear language (avoid overly technical jargon)
- Prioritize safety and sustainability
- Mention Kerala-specific information when relevant
- Be culturally sensitive and respectful
- If unsure, acknowledge limitations and suggest offline resources

User question: $message

Answer thoughtfully and comprehensively:""";

      final response = await http
          .post(
            Uri.parse(
                '${ApiConfig.geminiEndpoint}?key=${ApiConfig.geminiApiKey}'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': expertPrompt}
                  ]
                }
              ],
              'generationConfig': {
                'temperature': 0.7,
                'maxOutputTokens': 2000,
              }
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Extract response from Gemini's response structure
        if (jsonResponse['candidates'] != null &&
            jsonResponse['candidates'].isNotEmpty) {
          final aiMessage =
              jsonResponse['candidates'][0]['content']['parts'][0]['text'];

          // Clean markdown formatting (remove ** for bold, * for italic, etc.)
          final cleanedMessage = _stripMarkdown(aiMessage.trim());
          return cleanedMessage;
        } else {
          return "⚠️ Unexpected response format from Gemini API";
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return "❌ Invalid API Key\n\nYour Gemini API key is invalid.\nPlease check lib/config/api_config.dart\n\nGet a new key at: https://aistudio.google.com/app/apikey";
      } else if (response.statusCode == 429) {
        return "⏳ Rate Limit Exceeded\n\nToo many requests. Please wait a moment and try again.\n\n(This is rare with Gemini's free tier!)";
      } else {
        return "❌ API Error (${response.statusCode})\n\n${response.body}";
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        return "⏱️ Request Timeout\n\nThe server took too long to respond. Please try again.";
      }
      return "❌ Connection Error\n\nCouldn't reach Google servers.\n\nError: $e\n\nTry switching to Offline Mode 🔴";
    }
  }

  /// Strip common markdown formatting from Gemini responses
  static String _stripMarkdown(String text) {
    return text
        // Remove bold (**text** or __text__)
        .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (match) => match.group(1)!)
        .replaceAllMapped(RegExp(r'__(.+?)__'), (match) => match.group(1)!)
        // Remove italic (*text* or _text_)
        .replaceAllMapped(RegExp(r'\*(.+?)\*'), (match) => match.group(1)!)
        .replaceAllMapped(RegExp(r'_(.+?)_'), (match) => match.group(1)!)
        // Remove inline code (`text`)
        .replaceAllMapped(RegExp(r'`(.+?)`'), (match) => match.group(1)!);
  }
}
