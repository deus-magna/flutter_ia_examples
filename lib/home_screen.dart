import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyBUhhmdrsSSSI9MX0YR39hN2DQI4wgfmIo',
    );

    final prompt = 'Write a story about a magic backpack.';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    print(response.text);
    // setState(() {
    //   _counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('Flutter IA Examples'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chat con Gimini'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => context.go('/chat'),
          ),
          ListTile(
            leading: Icon(Icons.translate),
            title: Text('Traductor'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => context.go('/translator'),
          ),
          ListTile(
            leading: Icon(Icons.thermostat_auto),
            title: Text('Temperatura'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => context.go('/temp'),
          ),
          ListTile(
            leading: Icon(Icons.book_rounded),
            title: Text('Cuenta cuentos'),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => context.go('/story'),
          ),
        ],
      ),
    );
  }
}
