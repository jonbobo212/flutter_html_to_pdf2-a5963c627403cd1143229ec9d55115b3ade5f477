import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/validation.dart';

class GetRowFields extends StatelessWidget {
  final String title;
  final String value;
  final bool simple;
  const GetRowFields({
    Key? key,
    required this.value,
    required this.title,
    required this.simple,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: title == "${getTranslated(context, 'Final Total')} : " ||
                    title == getTranslated(context, "Grand Final Total :")! ||
                    title == "${getTranslated(context, "ID_LBL")} - "
                ? Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: black,
                      fontWeight: FontWeight.w400,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize14,
                    )
                : Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: grey3,
                      fontWeight: FontWeight.w400,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize14,
                    ),
          ),
          Text(
            () {
              if (simple) {
                return value;
              } else {
                return DesignConfiguration.getPriceFormat(
                  context,
                  double.parse(value),
                )!;
              }
            }(),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: title ==
                              "${getTranslated(context, 'Final Total')} : " ||
                          title ==
                              getTranslated(context, "Grand Final Total :")! ||
                          title == "${getTranslated(context, "ID_LBL")} - "
                      ? black
                      : grey,
                  fontWeight: FontWeight.w400,
                  fontFamily: "PlusJakartaSans",
                  fontStyle: FontStyle.normal,
                  fontSize: textFontSize14,
                ),
          ),
        ],
      ),
    );
  }
}
