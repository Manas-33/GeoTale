import 'package:ai_app/models/place.dart';

class City {
  String name;
  List<Place> places;
  City({
    required this.name,
    required this.places,
  });
  @override
  String toString() {
    return 'City name: $name, places: $places';
  }
}
