import 'package:deal_hunter/domain/entities/deal_entity.dart';

class DealModel extends DealEntity {
  DealModel({
    required super.productBarcode,
    required super.price,
    required super.locationId,
    required super.dateTime,
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    return DealModel(
      productBarcode: json['productBarcode'],
      price: json['price'].toDouble(),
      locationId: json['locationId'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
