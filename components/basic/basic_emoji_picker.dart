import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class BasicEmojiPicker extends StatelessWidget {
  final bool active;
  final String? selectedEmoji;
  final void Function()? onTap;
  final void Function(String emoji)? onEmojiSelected;

  const BasicEmojiPicker({super.key, this.active = false, this.selectedEmoji, this.onTap, this.onEmojiSelected});

  Widget _getEmoji(BuildContext context) {
    if (selectedEmoji != null && selectedEmoji!.isNotEmpty) {
      return Text(selectedEmoji!, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 50));
    } else {
      return Icon(FeatherIcons.smile, size: 40, color: Theme.of(context).colorScheme.onSurface,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  height: 100,
                  width: 100,
                  child: Center(
                    child: _getEmoji(context),
                  ),
                ),
              ),
              const Spacer()
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.background
          ),
          height: active ? 240:0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                onEmojiSelected?.call(emoji.emoji);
              },
              config: Config(
                bgColor: Theme.of(context).colorScheme.background,
                indicatorColor: Theme.of(context).colorScheme.primary,
                iconColor: Theme.of(context).colorScheme.onSurface,
                iconColorSelected: Theme.of(context).colorScheme.primary,
                noRecents: const Text("Pick an emoji!"),
                buttonMode: ButtonMode.CUPERTINO,
              )
            ),
          ),
        ),
      ],
    );
  }
}