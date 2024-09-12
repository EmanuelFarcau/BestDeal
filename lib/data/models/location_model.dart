import 'dart:math';

import 'package:deal_hunter/domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({
    super.id,
    required super.name,
    required super.longitude,
    required super.latitude,
    required super.radius,
    required super.isStoreChain,
    required super.storeChainId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      longitude: json['longitude'].toDouble(),
      latitude: json['latitude'].toDouble(),
      radius: json['radius'].toDouble(),
      isStoreChain: json['isStoreChain'],
      storeChainId: json['storeChainId'],
    );
  }

  Future<double> distanceTo(double x2, double y2) async {
    const double earthRadius = 6371000.0; // Earth's radius in meters

    // Convert degrees to radians
    final double x1Rad = longitude * pi / 180.0;
    final double y1Rad = latitude * pi / 180.0;
    final double x2Rad = x2 * pi / 180.0;
    final double y2Rad = y2 * pi / 180.0;

    // Haversine formula
    final double dX = x2Rad - x1Rad;
    final double dY = y2Rad - y1Rad;

    final double a = sin(dX / 2) * sin(dX / 2) +
        cos(x1Rad) * cos(x2Rad) * sin(dY / 2) * sin(dY / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final double distance = earthRadius * c;

    return distance;
  }
}
