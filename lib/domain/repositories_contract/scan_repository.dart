import 'package:permission_handler/permission_handler.dart';

abstract class ScanRepository {

  Future<bool> checkPermission(Permission permission);

  Future<void> initializeCamera();
}