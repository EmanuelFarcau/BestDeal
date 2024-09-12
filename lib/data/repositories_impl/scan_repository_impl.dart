import 'package:camera/camera.dart';
import 'package:deal_hunter/domain/repositories_contract/scan_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';


@Singleton(as: ScanRepository)
class ScanRepositoryImpl extends ScanRepository {

  @override
  Future<bool> checkPermission (Permission permission) async{
    final status = await permission.request();
    return status.isGranted;
  }

  @override
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

      CameraController(
        firstCamera,
        ResolutionPreset.veryHigh,
      );
  }
}