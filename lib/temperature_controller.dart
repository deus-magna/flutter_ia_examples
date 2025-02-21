import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TemperatureController extends StatefulWidget {
  @override
  _TemperatureControllerState createState() => _TemperatureControllerState();
}

class _TemperatureControllerState extends State<TemperatureController> {
  final TextEditingController _controller = TextEditingController();
  double? _fahrenheit;

  void _convertTemperature() async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyBUhhmdrsSSSI9MX0YR39hN2DQI4wgfmIo',
    );

    double? celsius = double.tryParse(_controller.text);
    if (celsius != null) {
      final prompt =
          'What is the result of this equation ($celsius * 9/5) + 32, give me only the number in double format';
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);
      print(response.text);
      _fahrenheit = double.tryParse(response.text!);
    } else {
      _fahrenheit = null;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Temperature Converter"),
        backgroundColor: Colors.blueGrey[900],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeInDown(
              child: Icon(
                Icons.thermostat,
                color: Colors.orangeAccent,
                size: 100,
              ),
            ),
            SizedBox(height: 16),
            FadeIn(
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter temperature in °C",
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertTemperature,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(50, 50),
              ),
              child: Text("Convert"),
            ),
            SizedBox(height: 16),
            if (_fahrenheit != null)
              BounceIn(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${_fahrenheit!.toStringAsFixed(2)} °F",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
