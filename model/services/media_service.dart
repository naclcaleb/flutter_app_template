import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../auth/auth_controller.dart';
import '../error_handlers/info_exception.dart';
import '../../service_locator.dart';
import 'package:uuid/uuid.dart';
import '../../components/system_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'error_service.dart';

class MediaService {

  final FirebaseStorage _storage = sl();
  final AuthController _authController = sl();
  final ErrorService _errorService = sl();

  final Uuid uuid = const Uuid();

  Future<XFile?> getUserChosenVideo(BuildContext context) async {

    //Get the image picker
    final ImagePicker picker = ImagePicker();

    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    return video;

  }

  Future<File?> getUserChosenImage(BuildContext context) async {

    //Open the image picker
    final ImagePicker picker = ImagePicker();
    
    bool? usingCamera = await SophiaAlert.showPlatformDialog(context, 'Choose a file source', 'Would you like to select from your photo gallery or take a new picture?', [
      const AlertAction(buttonText: 'Camera', returnValue: true, type: AlertActionType.normal),
      const AlertAction(buttonText: 'Gallery', returnValue: false, type: AlertActionType.normal),
    ]);

    if (usingCamera == null) return null;

    final XFile? image = await picker.pickImage(source: usingCamera ? ImageSource.camera : ImageSource.gallery);

    if (image == null) return null;

    final file = File(image.path);
    
    return file;

  }

  Future<String?> uploadFile(File mediaFile, String path, [void Function(TaskSnapshot taskSnapshot)? streamListener, String contentType = 'image/jpeg']) async {
    final itemRef = _storage.ref().child(path);
    final uploadTask = itemRef.putFile(mediaFile, SettableMetadata(
      contentType: contentType
    ));

    //Allow for monitoring upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {

      if (snapshot.state == TaskState.error) {
        _errorService.receiveError(const InfoException('Error uploading file'));
      }

      streamListener?.call(snapshot);

    });

    final snapshot = await uploadTask.whenComplete(() => null);

    if (snapshot.state == TaskState.error) {
      return null;
    }

    final url = await snapshot.ref.getDownloadURL();

    return url;

  }

  String uniqueFilename() {
    return uuid.v4();
  }

  String getUserStoragePath() {
    return 'users/${_authController.getCurrentUserId()}';
  }

}