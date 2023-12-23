

import 'package:camera/camera.dart';

class CameraService {
  late List<CameraDescription> _cameras;

  CameraDescription? frontFacingCamera;
  CameraDescription? backFacingCamera;

  Future<void> loadCameras() async {
    _cameras = await availableCameras();

    for (final camera in _cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        backFacingCamera = camera;
      } else if (camera.lensDirection == CameraLensDirection.front) {
        frontFacingCamera = camera;
      }
    }
  }



}