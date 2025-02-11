import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Loader {
  static bool isLoaderShowing = false;
  static void showLoader(BuildContext context) async {
    if (isLoaderShowing == true) return;

    isLoaderShowing = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AnnotatedRegion(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.black.withOpacity(0),
            ),
            child: SafeArea(
              child: PopScope(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) {
                    return;
                  }
                },
              ),
            ),
          );
        });
  }

  static void hideLoder(BuildContext context) {
    if (!isLoaderShowing) return;
    isLoaderShowing = false;
    Navigator.of(context).pop();
  }
}
