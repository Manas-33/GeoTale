import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Gemini {
  final _apiKey = dotenv.env['API_KEY']!;

  getCoordinates(String cityName) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    final prompt = """
return a list of coordinates of some poi's of the given city : $cityName
exclude any other details. the format should be in json in this format only 
IMPORTNANT RULE : 	dont add "```json"or "json" or "```" :

{
  "locations":[
    {
      "name": "Name of POI",
      "coordinates":[
        {
        "latitude" : latitude,
        "longitude" : longitude
        }
      ]
    }
    ....
  ]
}

""";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content,
        generationConfig: GenerationConfig(maxOutputTokens: 8192));
    print(response.text!);
    var jsondata = jsonDecode(response.text!);
    final locations = jsondata['locations'] as List<dynamic>;
    locations.forEach((location) {
      print(location['name']);
    });
    return response.text!;
  }

  getStory(String cityName)async{
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    final prompt = """
Create an description of this given city: $cityName, in 100 words in simple language
""";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content,
        generationConfig: GenerationConfig(maxOutputTokens: 8192));
    print(response.text!);
    return response.text!;
  }
}
