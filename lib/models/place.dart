// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:latlong2/latlong.dart';

class Place {
  String name;
  LatLng coordinates;
  String description;
  Place({
    required this.name,
    required this.coordinates,
    required this.description,
  });

  @override
  String toString() {
    return 'Place{name: $name, coordinates: $coordinates}';
  }
}
