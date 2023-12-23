import 'package:flutter/material.dart';
import '../../basic/basic_emoji_picker.dart';
import '../product_form_field.dart';

class BasicEmojiPickerFormField extends ProductFormField<String> {

  final void Function(String emoji)? onEmojiSelected;

  const BasicEmojiPickerFormField({super.key, super.initialValue, super.validator, super.label, super.enabled, this.onEmojiSelected});

  @override
  State<BasicEmojiPickerFormField> createState() => _BasicEmojiPickerFormFieldState();
}

class _BasicEmojiPickerFormFieldState extends ProductFormFieldState<String, BasicEmojiPickerFormField> {
  
  String? _value;
  bool active = false;

  void onTap() {
    setState(() {
      active = !active;
    });
  }

  @override
  void provideInititalState() {
    _value = widget.initialValue ?? '';
    fieldState?.setValue(_value);
  }

  void onEmojiSelected(String emoji) {
    fieldState?.didChange(emoji);
    setState(() {
      _value = emoji;
    });
    widget.onEmojiSelected?.call(emoji);
  }

  @override
  Widget buildChildWidget(BuildContext context) {
    return BasicEmojiPicker(
      selectedEmoji: _value,
      onEmojiSelected: onEmojiSelected,
      onTap: onTap,
      active: active,
    );
  }

}