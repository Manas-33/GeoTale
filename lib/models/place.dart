import 'package:latlong2/latlong.dart';

class Place {
  String name;
  LatLng coordinates;

  Place({
    required this.name,
    required this.coordinates,
  });

  @override
  String toString() {
    return 'Place{name: $name, coordinates: $coordinates}';
  }
}
