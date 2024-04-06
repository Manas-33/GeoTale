import 'package:ai_app/connections/gemini.dart';
import 'package:ai_app/screens/home_screen.dart';
import 'package:ai_app/screens/settings.dart';
import 'package:ai_app/screens/voice_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(MaterialApp(home: SettingsPage()));
  });
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
    return Scaffold(
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VoiceDemo()));
                  },
                  child: Text("click"))
            ],
          ),
        ),
      ),
    );
  }
}
