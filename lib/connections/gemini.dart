import 'dart:convert';

import 'package:ai_app/models/city.dart';
import 'package:ai_app/models/place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:latlong2/latlong.dart';

class Gemini {
  final _apiKey = dotenv.env['API_KEY']!;

  Future<City> getCoordinates(String cityName,String sName  ) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    final prompt = """
return a list of coordinates of some poi's of the given city : ${cityName}, ${sName}
exclude any other details. the format should be in json in this format only 
IMPORTNANT RULE : 	dont add "```json"or "json" or "```" : and the poi's should be less than or equal to 5

{
  "description":"A brief 20-25 word description about the city",
  "locations":[
    {
      "name": "Name of POI",
      "description": "A description about the place in about 20 words",
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
    String cityDescription = jsondata['description'];
    List<Place> places = [];
    locations.forEach((location) {
      String name = location['name'];
      String description = location['description'];
      var coordinates = location['coordinates'][0];
      double latitude = double.parse(coordinates['latitude'].toString());
      double longitude = double.parse(coordinates['longitude'].toString());
      LatLng latLng = LatLng(latitude, longitude);
      places.add(
          Place(name: name, coordinates: latLng, description: description));
    });

    return City(name: cityName, description: cityDescription, places: places);
  }

  Future<String> getStory(String cityName, String descriptions) async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    final prompt = """
Create an $descriptions description of this given city(story like not too much): $cityName, in 100 words in simple language
""";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content,
        generationConfig: GenerationConfig(maxOutputTokens: 8192));
    // print(response.text!);
    return response.text!;
  }
}
