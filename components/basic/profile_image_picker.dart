import 'package:flutter/material.dart';
import 'product_image.dart';
import '../../model/services/media_service.dart';
import '../../service_locator.dart';

class ProfileImagePicker extends StatefulWidget {

  final String? url;
  final String baseBucketPath;
  final void Function(String url)? onImagePicked;

  const ProfileImagePicker({super.key, required this.baseBucketPath, this.url, this.onImagePicked});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {

  bool loading = false;

  final MediaService _mediaService = sl();
  double progress = 0.0;

  void _pickImage(BuildContext context) async {

    //Get an image from the user
    final imageFile = await _mediaService.getUserChosenImage(context);

    //If the user didn't pick an image, return
    if (imageFile == null) return;

    //Generate a new file name
    final fileName = _mediaService.uniqueFilename();

    //Reset the progress
    setState(() {
      loading = true;
      progress = 0.0;
    });

    //Upload the image
    final url = await _mediaService.uploadFile(imageFile, "${widget.baseBucketPath}/$fileName", (uploadState) {
      setState(() => progress = uploadState.bytesTransferred / uploadState.totalBytes);
    });

    setState(() => loading = false);

    //If the upload failed, return
    if (url == null) {
      return;
    }

    //Call the callback
    widget.onImagePicked?.call(url);

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: Center(
        child: ProductImage(
          url: loading ? null : widget.url,
          placeholderIcon: Icons.person,
          width: 100,
          height: 100,
          style: ImageDisplayFormat.circle,
          placeholderChild: CircularProgressIndicator(value: progress),
        )
      ),
    );
  }
}