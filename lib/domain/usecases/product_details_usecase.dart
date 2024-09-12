import 'package:dartz/dartz.dart';
import 'package:deal_hunter/core/errors/failures.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/domain/entities/deal_entity.dart';
import 'package:deal_hunter/domain/entities/product_entity.dart';
import 'package:deal_hunter/domain/repositories_contract/deal_repository.dart';
import 'package:deal_hunter/domain/repositories_contract/location_repository.dart';
import 'package:deal_hunter/domain/repositories_contract/product_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@singleton
class ProductDetailsUsecase {
  final ProductDetailsRepository _productDetailsRepository;
  final LocationRepository _locationRepository;
  final DealRepository _dealRepository;

  ProductDetailsUsecase(this._productDetailsRepository,
      this._locationRepository, this._dealRepository);

  Future<Either<Failure, ProductEntity?>> checkIfProductExists(
      String barcode) async {
    //return _productDetailsRepository.doesProductExist(barcode);
    return _productDetailsRepository.doesProductExist2(barcode);
  }

  Future<Either<Failure, ProductEntity>> addProductToDatabase(
      ProductEntity product) async {
    //return _productDetailsRepository.addProductToDatabase(product);
    return _productDetailsRepository.addProductToDatabase2(product);
  }

  /// cautam locatia userului
  /// cautam sa vedem daca utilizatorul este in raza unui magazin.
  ///1.Daca nu exista magazin il creem noi, prin coordonatele utilizatorului si te folosesti de id-ul primit de la firebase.
  /// Adica pun la deallocationId
  ///2. Daca avem magazin pune direct locationId la deal.

  Future<Either<Failure, void>> _addDealToDataBase(
      {required String barcode, required double price}) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final locations = await _locationRepository.checkLocationsInRange(
        position.longitude, position.latitude, false);



    String? currentLocationId = await locations.fold(
      (failure) {
        return null;
      },
      (locationsResponse) async {
        if (locationsResponse.isEmpty) {
          final newLocationIdResponse =
              await _locationRepository.addCurrentLocationToDatabase();

          return newLocationIdResponse.fold((failure) {
            return null;
          }, (newLocationId) async {
            return newLocationId;
          });
        } else {
          return locationsResponse.first.id;
        }
      },
    );

    if (currentLocationId == null) {
      return const Left(HardFailure(AppString.currentLocationErrorText));
    }

    final newDeal = DealEntity(
      productBarcode: barcode,
      price: price,
      locationId: currentLocationId,
      dateTime: DateTime.now(),
    );

    return _dealRepository.addDealToDatabase(newDeal);
  }

  Future<Either<Failure, DealEntity?>> getBestDeal(
      {required String barcode,
      required double? price,
      required bool isInStore}) async {
    if (price != null && isInStore) {
      await _addDealToDataBase(barcode: barcode, price: price!);
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var areaLocations = await _locationRepository.checkLocationsInRange(
        position.longitude, position.latitude, true);

    return areaLocations.fold(
      (failure) {
        return Left(failure);
      },
      (areaLocationsResponse) async {
        final bestDealsResponse = await _dealRepository.checkBestDealInRange(
            barcode: barcode, areaLocations: areaLocationsResponse);

        return bestDealsResponse.fold(
          (failure) => Left(failure),
          (bestDeals) => Right(bestDeals.firstOrNull),
        );
      },
    );
  }
}
