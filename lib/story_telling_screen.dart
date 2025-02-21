import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';

import 'main.dart';

class StoryTellingScreen extends StatefulWidget {
  const StoryTellingScreen({super.key});

  @override
  State<StoryTellingScreen> createState() => _StoryTellingScreenState();
}

class _StoryTellingScreenState extends State<StoryTellingScreen> {
  List<String> selectedItems = [];
  bool showStory = false;
  String story = '';

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

    print('no prompt');

    final prompt =
        'Crea una historia, donde ${selectedItems.first} sea el personaje principal, ${selectedItems[1]} te ayude a darle sentido a la historia y ${selectedItems.last} sea el antagonista, agregale una intro, luego un nudo y por ultimo un desenlace, es una historia para niños';
    print('no funciona');
    final content = [Content.text(prompt)];
    print('no content');
    final response = await model.generateContent(content);

    print('no funciona');

    setState(() {
      story = response.text ?? '';
    });
    // return "Había una vez un ${selectedItems.join(', ')} en una gran aventura.";
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
}
