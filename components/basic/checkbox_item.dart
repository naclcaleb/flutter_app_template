import 'dart:developer';

import 'package:flutter/material.dart';
import 'checkbox_list.dart';

class CheckboxItem extends StatelessWidget {

  final String text;
  final String value;
  final bool loading =  true;

  const CheckboxItem({super.key, required this.text, required this.value});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CheckboxList.of(context).notifyItemToggled(value);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: CheckboxList.of(context).values.contains(value), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary;
              }
              return Colors.transparent;
            }),
            onChanged: null,
          ),
          Flexible(child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onBackground),),
          )),
        ],
      ),
    );
  }
}