class LocationEntity {
  String? id;
  String name;
  double longitude;
  double latitude;
  double radius;
  bool isStoreChain;
  String storeChainId;

  LocationEntity({
    this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.radius,
    required this.isStoreChain,
    required this.storeChainId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'longitude': longitude,
      'latitude': latitude,
      'radius': radius,
      'isStoreChain': isStoreChain,
      'storeChainId': storeChainId,
    };
  }
}
