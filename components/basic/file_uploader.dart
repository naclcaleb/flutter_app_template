import 'dart:io';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'product_button.dart';
import '../system_alert.dart';
import '../../model/services/media_service.dart';
import '../../service_locator.dart';

class UploadedFile {
  final String fileName;
  final String url;

  const UploadedFile({required this.fileName, required this.url});
}

class FileUploader extends StatelessWidget {

  final List<UploadedFile> files;
  final bool loading;
  final double progress;
  final void Function(File file)? onFileSelected;
  final void Function(UploadedFile file)? onFileRemoved;

  FileUploader({super.key, this.files = const [], this.loading = false, this.progress = 0, this.onFileSelected, this.onFileRemoved});

  final MediaService _mediaService = sl();

  Future<void> _openImageSelector(BuildContext context) async {
    
    //Open the image picker
    final file = await _mediaService.getUserChosenImage(context);
    if (file == null) return;
    onFileSelected?.call(file);

  }


  List<Widget> _getFileWidgets(BuildContext context) {
    return files.asMap().entries.map((entry) {
      var file = entry.value;
      var index = entry.key;
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            if (index > 0) Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surface,
                ),
                height: 2,
              )
            ),
            Row(
              children: [
                Flexible(child: Text(file.fileName, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary), overflow: TextOverflow.ellipsis,)),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    onFileRemoved?.call(file);
                  },
                  icon: Icon(
                    FeatherIcons.trash2,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();  
  
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._getFileWidgets(context),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ProductButton(text: 'Upload File', style: ProductButtonStyle.thinPrimary, loading: loading, onTap: () => _openImageSelector(context),),
        ),
      ],
    );
  }
}