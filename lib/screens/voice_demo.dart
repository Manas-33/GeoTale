import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class VoiceDemo extends StatefulWidget {
  const VoiceDemo({super.key});

  @override
  State<VoiceDemo> createState() => _VoiceDemoState();
}

class _VoiceDemoState extends State<VoiceDemo> {
  late stt.SpeechToText _speechToText;
  bool _isListening = false;
  String _text = "";
  double _confidence = 1.0;
  bool completed = false;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    initSpeech();
  }

  void initSpeech() async {
    _isListening = await _speechToText.initialize();
    setState(() {});
  }

  voiceToText() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _speechToText.listen(
            onResult: (result) {
              _text = result.recognizedWords;
              if (result.hasConfidenceRating && result.confidence > 0) {
                _confidence = result.confidence;
              }
            },
          );
        });
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speechToText.stop();
      if (_text.isNotEmpty) {
        completed = true;
      }
    }
  }

  textToVoice(String content) async {
    final url =
        Uri.parse("https://api.deepgram.com/v1/speak?model=aura-asteria-en");
    String voiceApiKey = dotenv.env['DEEPGRAM_API_KEY']!;
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $voiceApiKey"
        },
        body: jsonEncode({"text": content}));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/textToSpeech.wav');
      await file.writeAsBytes(bytes);
      final player = AudioPlayer();
      await player.play(DeviceFileSource(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await textToVoice("Hello");
              },
              child: Text("Start Text to speech"))
        ],
      ),
    );
  }
}
