part of 'product_details_bloc.dart';

@immutable
abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductExistsState extends ProductReceivedState {

  ProductExistsState(super.product);
}

class ProductNotExistsState extends ProductDetailsState {
  final String barcode;

  ProductNotExistsState(this.barcode);
}

class ProductErrorState extends ProductDetailsState {
  final String errorMessage;

  ProductErrorState(this.errorMessage);
}

class ProductDetailsLoadingState extends ProductDetailsState {}

class ProductAddedState extends ProductReceivedState {

  ProductAddedState(super.product);
}

class ProductReceivedState extends ProductDetailsState {
  final ProductEntity product;

  ProductReceivedState(this.product);
}

class DealErrorState extends ProductDetailsState {
  final String errorMessage;

  DealErrorState(this.errorMessage);
}

class BestDealLoadingState extends ProductDetailsState {}

class BestDealFoundState extends ProductDetailsState {
  final DealEntity deal;

  BestDealFoundState(this.deal);
}

class NoDealFoundState extends ProductDetailsState {
  final bool isInStore;

  NoDealFoundState(this.isInStore);
}




