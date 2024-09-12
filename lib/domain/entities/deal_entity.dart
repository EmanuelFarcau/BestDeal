class DealEntity {
  final String productBarcode;
  final double price;
  final String locationId;
  final DateTime dateTime;

  DealEntity({
    required this.productBarcode,
    required this.price,
    required this.locationId,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'productBarcode': productBarcode,
      'price': price,
      'locationId': locationId,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
