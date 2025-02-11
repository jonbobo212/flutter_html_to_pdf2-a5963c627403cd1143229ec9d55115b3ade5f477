// upload button :-
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/snackbar.dart';
import '../../../Widget/validation.dart';
import '../../MediaUpload/Media.dart';
import '../EditProduct.dart';

getCommonButton(
  String title,
  int index,
  Function setState,
  BuildContext context,
) {
  return InkWell(
    onTap: () {
      if (index == 1) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const Media(
              from: "main",
              type: "edit",
              pos: 0,
            ),
          ),
        ).then(
          (value) => setState(),
        );
      } else if (index == 2) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const Media(
              from: "other",
              pos: 0,
              type: "edit",
            ),
          ),
        ).then(
          (value) => setState(),
        );
      } else if (index == 4) {
        if (editProvider!.simpleProductPriceController.text.isEmpty) {
          setSnackbar(
            getTranslated(context, "Please enter product price")!,
            context,
          );
        } else if (editProvider!
            .simpleProductSpecialPriceController.text.isEmpty) {
          editProvider!.simpleProductSaveSettings = true;
          setSnackbar(
            getTranslated(context, "Setting saved successfully")!,
            context,
          );
          setState(() {});
        } else if (double.parse(editProvider!.simpleproductPrice!) <
            double.parse(editProvider!.simpleproductSpecialPrice!)) {
          setSnackbar(
            getTranslated(
                context, "Special price must be less than original price")!,
            context,
          );
        } else {
          editProvider!.simpleProductSaveSettings = true;
          setSnackbar(
            getTranslated(context, "Setting saved successfully")!,
            context,
          );
          setState();
        }
      } else if (index == 5) {
        if (editProvider!.isStockSelected != null &&
            editProvider!.isStockSelected == true &&
            (editProvider!.variountProductTotalStock.text.isEmpty ||
                editProvider!.stockStatus.isEmpty)) {
          setSnackbar(
            getTranslated(context, "Please enter all details")!,
            context,
          );
        } else {
          editProvider!.variantProductProductLevelSaveSettings = true;
          setSnackbar(
              getTranslated(context, "Setting saved successfully")!, context);
          setState();
        }
      } else if (index == 6) {
        editProvider!.variantProductVariableLevelSaveSettings = true;
        setSnackbar(
          getTranslated(context, "Setting saved successfully")!,
          context,
        );
        setState();
      }
    },
    child: index == 4 || index == 5 || index == 6
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(circularBorderRadius5),
              color: primary,
            ),
            height: 40,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: textFontSize16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : Container(
            // margin: EdgeInsetsDirectional.only(top: 15),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(
                  color: black.withOpacity(0.3),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(DesignConfiguration.setNewSvgPath('Capa')),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: Text(
                    'Enter Your $title Here',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: lightBlack, fontSize: 11),
                  ),
                ),
              ],
            )),
  );
}
