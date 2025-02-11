import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Widget/validation.dart';

class CancelShiprocketOrderConfirmationDialog extends StatelessWidget {
  const CancelShiprocketOrderConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(getTranslated(context, 'CANCEL_SHIPROCKET_ORDER')!),
      content: Text(getTranslated(
          context, 'ARE_YOU_SURE_YOU_WANT_TO_CANCEL_THIS_ORDER')!),
      actions: [
        CupertinoButton(
            child: Text(getTranslated(context, 'LOGOUTNO')!),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        CupertinoButton(
            child: Text(getTranslated(context, 'LOGOUTYES')!),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
      ],
    );
  }
}
