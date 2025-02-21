import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:shimmer/shimmer.dart';

import 'main.dart';

class StoryTellingScreen extends StatefulWidget {
  const StoryTellingScreen({super.key});

  @override
  State<StoryTellingScreen> createState() => _StoryTellingScreenState();
}

class _StoryTellingScreenState extends State<StoryTellingScreen> {
  List<String> selectedItems = [];
  bool showStory = false;
  bool _speachIsReady = false;
  late Uint8List audioBytes;
  String story = '';
  final AudioPlayer audioPlayer = AudioPlayer();
  bool playing = false;

  final List<Map<String, dynamic>> icons = [
    {'icon': Icons.shield, 'name': 'caballero'},
    {'icon': Icons.favorite, 'name': 'princesa'},
    {'icon': Icons.castle, 'name': 'castillo'},
    {'icon': Icons.whatshot, 'name': 'dragon'},
    {'icon': Icons.edit, 'name': 'espada'},
    {'icon': Icons.pets, 'name': 'lobo'},
    {'icon': Icons.elderly_woman_outlined, 'name': 'mago'},
    {'icon': Icons.star, 'name': 'estrella'},
    {'icon': Icons.book, 'name': 'libro'},
    {'icon': Icons.nature_people, 'name': 'elfo'},
  ];

  void generateStory() {
    setState(() {
      showStory = true;
    });
    createStory();
  }

  Future<void> createStory() async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: yourAPIKey,
    );

    final prompt =
        'Crea una historia, donde ${selectedItems.first} sea el personaje principal, ${selectedItems[1]} te ayude a darle sentido a la historia y ${selectedItems.last} sea el antagonista, agregale una intro, luego un nudo y por ultimo un desenlace, es una historia para niños. Si creas personajes colocales un nombre propio.';

    final content = [Content.text(prompt)];

    final response = await model.generateContent(content);

    setState(() {
      story = response.text ?? '';
    });
    speakWithElevenLabs(story);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crea tu historia')),
      body: Column(
        children: [
          Expanded(
            child:
                showStory
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/story_animation.json',
                            width: MediaQuery.of(context).size.width,
                          ),
                          _speachIsReady
                              ? ElevatedButton(
                                onPressed:
                                    story != ''
                                        ? () {
                                          if (playing) {
                                            audioPlayer.stop();
                                            setState(() {
                                              playing = false;
                                            });
                                          } else {
                                            audioPlayer.play(
                                              BytesSource(audioBytes),
                                            );
                                            setState(() {
                                              playing = true;
                                            });
                                          }
                                        }
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.yellow,
                                  highlightColor: Colors.pink,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        playing
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                      Text(playing ? 'Pausa' : 'Reproducir'),
                                    ],
                                  ),
                                ),
                              )
                              : CircularProgressIndicator(),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                story,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) {
                        return DragTarget<String>(
                          onAcceptWithDetails: (details) {
                            setState(() {
                              if (!selectedItems.contains(details.data) &&
                                  selectedItems.length < 3) {
                                selectedItems.add(details.data);
                              }
                            });
                          },
                          builder: (context, candidateData, rejectedData) {
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    selectedItems.length > index
                                        ? Colors.blue.shade100
                                        : Colors.white,
                              ),
                              child:
                                  selectedItems.length > index
                                      ? Icon(
                                        icons.firstWhere(
                                          (item) =>
                                              item['name'] ==
                                              selectedItems[index],
                                        )['icon'],
                                        size: 40,
                                      )
                                      : null,
                            );
                          },
                        );
                      }),
                    ),
          ),

          if (!showStory)
            ElevatedButton(
              onPressed: selectedItems.length == 3 ? generateStory : null,
              child: Text('Crear Historia'),
            ),
          SizedBox(height: 20),
          if (!showStory)
            Wrap(
              spacing: 10,
              children:
                  icons.map((item) {
                    return Draggable<String>(
                      data: item['name'],
                      feedback: Icon(
                        item['icon'],
                        size: 50,
                        color: Colors.blue,
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: Icon(item['icon'], size: 40),
                      ),
                      child: Tooltip(
                        child: Icon(item['icon'], size: 40),
                        message: item['name'],
                      ),
                    );
                  }).toList(),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> speakWithElevenLabs(String text) async {
    const String apiKey = ""; // Reemplaza con tu clave real
    const String voiceId =
        "EXAVITQu4vr4xnSDxMaL"; // ID de voz (elige una desde la web)

    final url = Uri.parse(
      "https://api.elevenlabs.io/v1/text-to-speech/$voiceId",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "xi-api-key": apiKey},
      body: jsonEncode({
        "text": text,
        "language_code": 'es',
        "model_id": "eleven_flash_v2_5", // Modelo de voz
        "voice_settings": {
          "stability": 0.5, // Ajusta estabilidad de la voz
          "similarity_boost": 0.8, // Ajusta naturalidad
        },
      }),
    );

    if (response.statusCode == 200) {
      audioBytes = response.bodyBytes;
      _speachIsReady = true;
      setState(() {});
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  }
}
