import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
