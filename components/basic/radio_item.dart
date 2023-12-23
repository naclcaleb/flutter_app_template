import 'dart:developer';

import 'package:flutter/material.dart';
import 'radio_list.dart';

class RadioItem extends StatelessWidget {

  final String text;
  final String value;
  final void Function(String? value)? onChanged;

  const RadioItem({super.key, required this.text, required this.value, this.onChanged});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RadioList.of(context).notifyItemSelected(value);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(children: [
        Radio(
          value: value, 
          groupValue: RadioList.of(context).groupValue,
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.primary;
            }
            return Theme.of(context).colorScheme.onSurface;
          }),
          onChanged: null
        ),
        Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onBackground),),
      ],),
    );
  }
}