import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Widget/validation.dart';

class CustomBottomSheet {
  static Future<dynamic> showBottomSheet(
      {required Widget child,
      required BuildContext context,
      bool? enableDrag}) async {
    final result = await showModalBottomSheet(
      enableDrag: enableDrag ?? false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (_) => child,
    );
    return result;
  }

  static Widget bottomSheetHandle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: lightBlack2,
        ),
        height: 5,
        width: MediaQuery.of(context).size.width * 0.2,
      ),
    );
  }

  static Widget bottomSheetLabel(BuildContext context, String labelName) =>
      Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 10),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            getTranslated(context, labelName)!,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ubuntu',
                ),
          ),
        ),
      );
  static Widget bottomSheetText(BuildContext context, String labelName) =>
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          getTranslated(context, labelName)!,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(),
        ),
      );
  static Widget bottomSheetTextbutton(BuildContext context, String labelName,
          bool selected, int selectedValue,
          {Function? onpressed}) =>
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getTranslated(context, labelName)!,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(),
              ),
            ),
            Radio<int>(
              value: 2,
              groupValue: selectedValue,
              hoverColor: Theme.of(context).colorScheme.primary,
              activeColor: Theme.of(context).colorScheme.primary,
              onChanged: (int? value) {},
            ),
          ],
        ),
      );
}
