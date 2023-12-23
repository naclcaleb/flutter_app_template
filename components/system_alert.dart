import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'basic/product_button.dart';
import 'basic/page_section.dart';
import 'basic/radio_item.dart';
import 'form/fields/radio_list_form_field.dart';
import 'form/product_form.dart';

enum AlertActionType {
  normal, 
  destructive
}

class AlertAction<ExpectedType> {
  final String buttonText;
  final ExpectedType returnValue;
  final AlertActionType type;

  const AlertAction({required this.buttonText, required this.returnValue, required this.type});
}

class SystemAlert {

  static Future<String?> showPlatformActionSheet(BuildContext context, String title, String message, List<AlertAction<String>> actions) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(context: context, builder: (context) => CupertinoActionSheet(
        title: Text(title),
        message: Text(message),
        actions: actions.map((action) => CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(action.returnValue);
          },
          isDestructiveAction: action.type == AlertActionType.destructive, 
          child: Text(action.buttonText),
        )).toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          isDestructiveAction: true, 
          child: const Text('Cancel'),
        ),
      ));
    } else {
      final formKey = GlobalKey<FormState>();
      return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        showDragHandle: true,
        builder: (context) {
          return PageSection(
            child: ProductForm(formKey: formKey, child: Column(
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground)),
                const SizedBox(height: 20,),
                Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground)),
                RadioListFormField(
                  onSubmit: (value) {
                    Navigator.of(context).pop(value);
                  },
                  child: Column(
                    children: actions.map((AlertAction<String> action) {
                      return RadioItem(text: action.buttonText, value: action.returnValue);
                    }).toList(),
                  )
                ),
                const SizedBox(height: 20,),
                ProductButton(text: 'Submit', style: ProductButtonStyle.secondary, size: ProductButtonSize.small, onTap: () {
                  formKey.currentState?.save();
                },)
              ],
            )),
          );
        }
      );
    }
  }

  static Future<ExpectedType?> showPlatformDialog<ExpectedType>(BuildContext context, String title, String message, List<AlertAction<ExpectedType>> actions) async {
    if (Platform.isIOS) {
      return showCupertinoDialog(context: context, barrierDismissible: true, builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ...actions.map((action) => CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(action.returnValue);
            },
            isDestructiveAction: action.type == AlertActionType.destructive,
            child: Text(action.buttonText),
          ))
        ]
      ));
    }

    else if (Platform.isAndroid) {
      return showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ...actions.map((action) => TextButton(
            onPressed: () {
              Navigator.of(context).pop(action.returnValue);
            },
            child: Text(action.buttonText),
          ))
        ]
      ));
    }

    return null;
  }

}