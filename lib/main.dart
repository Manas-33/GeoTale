import 'package:ai_app/connections/gemini.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data = '';
  final apiKey = dotenv.env['API_KEY'];
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Demo"),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            // height: double.infinity,
            child: Column(
              children: [
                Text("Output is:"),
                ElevatedButton(
                  onPressed: () async {
                    var response = await Gemini().getStory("pune");

                    setState(() {
                      data = response;
                      completed = true;
                    });
                  },
                  child: Text("Generate"),
                ),
                if (completed)
                  Builder(
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
