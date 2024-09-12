part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsEvent {}

class CheckProduct extends ProductDetailsEvent {
  final String? barcode;

  CheckProduct(this.barcode);
}

class AddProductToDataBase extends ProductDetailsEvent {
  final ProductEntity product;

  AddProductToDataBase(this.product);
}

class AddDealToDataBase extends ProductDetailsEvent {}

class CheckBestDealsEvent extends ProductDetailsEvent {
  final String barcode;
  final double? price;
  final bool isInStore;

  CheckBestDealsEvent(
    this.barcode,
    this.price,
    this.isInStore,
  );
}
