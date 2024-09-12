import 'package:bloc/bloc.dart';
import 'package:deal_hunter/domain/entities/deal_entity.dart';
import 'package:deal_hunter/domain/entities/product_entity.dart';
import 'package:deal_hunter/domain/usecases/product_details_usecase.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'product_details_event.dart';

part 'product_details_state.dart';

@Singleton()
class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductDetailsUsecase _productDetailsUsecase;

  ProductDetailsBloc(this._productDetailsUsecase)
      : super(ProductDetailsInitial()) {
    on<CheckProduct>(
      (event, emit) async {
        if (event.barcode == null) {
          return;
        } else {
          emit(ProductDetailsLoadingState());
          final dataProduct =
              await _productDetailsUsecase.checkIfProductExists(event.barcode!);

          dataProduct.fold(
              (failure) => emit(ProductErrorState(failure.message)), (product) {
            if (product != null) {
              emit(ProductExistsState(product));
            } else {
              emit(ProductNotExistsState(event.barcode!));
            }
          });
        }
      },
    );

    on<AddProductToDataBase>((event, emit) async {
      final response =
          await _productDetailsUsecase.addProductToDatabase(event.product);


      response.fold((failure) => emit(ProductErrorState(failure.message)),
          (product) => emit(ProductAddedState(product)));
    });

    on<AddDealToDataBase>((event, emit) async {});

    on<CheckBestDealsEvent>(
      (event, emit) async {
        final response = await _productDetailsUsecase.getBestDeal(
            barcode:  event.barcode, price: event.price, isInStore: event.isInStore);

        response.fold(
          (failure) => emit(DealErrorState(failure.message)),
          (deal) {
            if(deal != null) {
              emit(BestDealFoundState(deal));
            } else {
              emit(NoDealFoundState(event.isInStore));
            }
          },
        );
      },
    );

    // salvam the deal in baza de date

    // dupa ce il salvam cautam sa vedem daca exista dealuri cu pretul mai mic decat cel introdus de user pe o distanta de 20 de km.

    // momentam afisam doar cel mai bun deal intr-un card. State: BestDealFound care trebuie sa contina: pret, nume unitmesure etc.

    //cu pretul iesit in evidenta. Si dedesupt sa ii afiisez locatia intr-un alt card.

    // un patrat cu harta de la google maps si locatia magazinului (marker). Detaliile magazinului si distanta pana acolo in km sau metri.
  }
}
