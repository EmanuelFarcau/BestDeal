part of 'scan_bloc.dart';

@immutable
abstract class ScanEvent {}

class InitializeCameraEvent extends ScanEvent {}

class CheckPermissionEvent extends ScanEvent {}