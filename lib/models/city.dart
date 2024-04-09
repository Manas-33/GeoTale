// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ai_app/models/place.dart';

class City {
  String name;
  String description;
  List<Place> places;
  City({
    required this.name,
    required this.description,
    required this.places,
  });
  @override
  String toString() {
    return 'City name: $name, places: $places';
  }
}
