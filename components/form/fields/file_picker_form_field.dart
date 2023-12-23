import 'dart:io';

import 'package:flutter/material.dart';
import '../product_form_field.dart';

import '../../basic/file_uploader.dart';

class FilePickerFormField extends ProductFormField<List<UploadedFile>> {

  final Future<UploadedFile?> Function(File file) uploadFile;
  final void Function(UploadedFile file)? onFileRemoved;

  const FilePickerFormField({super.key, required this.uploadFile, this.onFileRemoved, super.initialValue, super.validator, super.label, super.enabled});

  @override
  State<FilePickerFormField> createState() => _FilePickerFormFieldState();
}

class _FilePickerFormFieldState extends ProductFormFieldState<List<UploadedFile>, FilePickerFormField> {
  
  List<UploadedFile>? _value;
  bool loading = false;

  @override
  void provideInititalState() {
    _value = widget.initialValue ?? [];
    fieldState?.setValue(_value);
  }

  void onFileSelected(File file) async {

    setState(() {
      loading = true;
    });

    try {

      final uploadedFile = await widget.uploadFile(file);

      setState(() {
        if (uploadedFile != null) _value?.add(uploadedFile);
        loading = false;
      });

      fieldState?.didChange(_value);
    } catch(err) {
      setState(() {
        loading = false;
      });
    }

  }

  void onFileRemoved(UploadedFile file) async {

      widget.onFileRemoved?.call(file);
      
      setState(() {
        _value?.removeWhere((element) => element == file);
      });
  
      fieldState?.didChange(_value);

  }


  @override
  Widget buildChildWidget(BuildContext context) {
    return FileUploader(
      files: _value ?? [],
      onFileSelected: onFileSelected,
      onFileRemoved: onFileRemoved,
      loading: loading,
    );
  }

}