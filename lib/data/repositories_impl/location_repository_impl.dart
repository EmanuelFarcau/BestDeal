import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:deal_hunter/core/errors/failures.dart';
import 'package:deal_hunter/core/utils/constants.dart';
import 'package:deal_hunter/data/models/location_model.dart';
import 'package:deal_hunter/domain/entities/location_entity.dart';
import 'package:deal_hunter/domain/repositories_contract/location_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: LocationRepository)
class LocationRepositoryImpl extends LocationRepository {
  final CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');

  @override
  Future<Either<dynamic, List<LocationModel>>> checkLocationsInRange(
      double x, double y, bool areaLocations) async {
    try {

      QuerySnapshot locationSnapshot = await locationsCollection.get();

      List<LocationModel> locationsWithIDs = [];

      for (QueryDocumentSnapshot doc in locationSnapshot.docs) {
        Map<String, dynamic> locationData = doc.data() as Map<String, dynamic>;
        locationData['id'] = doc.id;
        final LocationModel location = LocationModel.fromJson(locationData);


        double distance = await location.distanceTo(x, y);

        //TODO: replace area location boolean with specific range

        if(areaLocations){
          if(distance <= 20000){
            locationsWithIDs.add(location);
          }
        } else if (distance <= location.radius) {
          locationsWithIDs.add(location);
        }
      }

      return Right(locationsWithIDs);
    } catch (e) {
      return Left(FirebaseFailure("Error from firebase: $e"));
    }
  }

  @override
  Future<Either<Failure, String>> addCurrentLocationToDatabase() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LocationEntity location = LocationEntity(
      name: "",
      longitude: position.longitude,
      latitude: position.latitude,
      radius: AppNumbers.radius,
      isStoreChain: false,
      storeChainId: "",
    );

    return addLocationToDatabase(location);
  }


  @override
  Future<Either<Failure, String>> addLocationToDatabase(
      LocationEntity location) async {
    try {
      final Map<String, dynamic> locationData = location.toJson();

      return Right((await locationsCollection.add(locationData)).id);
    } catch (e) {
      // Handle any errors that occur during the database operation
      return Left(FirebaseFailure('Error adding location: $e'));
    }
  }
}
