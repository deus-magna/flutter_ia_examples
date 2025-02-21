import 'package:flutter/material.dart';
import 'package:flutter_ia_translator/main.dart' show yourAPIKey;
import 'package:google_generative_ai/google_generative_ai.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: yourAPIKey,
  );

  final TextEditingController _controller = TextEditingController();
  String _enTranslation = "";
  String _esTranslation = "";

  Future<String?> _detectLanguage(String text) async {
    final systemPrompt =
        "You are a professional translator with expertise in both English and Spanish languages. Your task is to accurately detect the language of the provided text and respond with either 'en' for English or 'es' for Spanish. If the text is in any other language, respond with 'null'. Ensure your response is concise and only includes the language code or 'null'.";

    final prompt =
        "Detect the language of this text: $text. Reply with only en for English or only es for Spanish. Reply only usign the language's symbol as two letters. If the text is not in English neither in Spanish, reply with the original text.";

    final content = [Content.text(systemPrompt), Content.text(prompt)];
    final language = await model.generateContent(content);
    if (language.text != null) {
      return language.text!.trim() == 'es' || language.text!.trim() == 'en'
          ? language.text!.trim()
          : null;
    }
    return null;
  }

  Future<String> _translateText(String text, String from, String to) async {
    final prompt =
        "Translate the following text from ${from == 'es' ? 'Spanish' : 'English'} to ${to == 'en' ? 'English' : 'Spanish'}: $text.";

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? '';
  }

  Future<void> _translateContent(String text) async {
    if (text == '') {
      return;
    }
    final detectedLanguage = await _detectLanguage(text);

    switch (detectedLanguage) {
      case 'es':
        _enTranslation = await _translateText(text, 'es', 'en');
        _esTranslation = text;
        break;
      case 'en':
        _esTranslation = await _translateText(text, 'en', 'es');
        _enTranslation = text;
        break;
      default:
        _enTranslation = text;
        _esTranslation = text;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Translator"),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 5,
              minLines: 3,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter text...",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('English'),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _enTranslation,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text('Español'),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _esTranslation,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _translateContent(_controller.text.trim()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(50, 55),
              ),
              child: Text("Translate"),
            ),
          ],
        ),
      ),
    );
  }
}
