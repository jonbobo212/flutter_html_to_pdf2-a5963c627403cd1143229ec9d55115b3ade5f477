import 'package:flutter/material.dart';
import '../Helper/Color.dart';

setSnackbar(
  String msg,
  context, {
  Color? backgroundColor,
  EdgeInsets? margin,
  SnackBarBehavior? action,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: margin,
      behavior: action,
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: black,
        ),
      ),
      duration: const Duration(
        seconds: 2,
      ),
      backgroundColor: backgroundColor ?? white,
      elevation: 1.0,
    ),
  );
}
