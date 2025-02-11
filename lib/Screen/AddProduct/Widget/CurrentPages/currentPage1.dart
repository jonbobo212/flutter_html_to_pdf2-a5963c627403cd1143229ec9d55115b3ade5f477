import 'package:flutter/cupertino.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/ProductDescription.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';
import '../getCommanInputTextFieldWidget.dart';
import '../getCommanWidget.dart';
import '../getIconSelectionDesingWidget.dart';
import 'currentPage3.dart';

currentPage1(
  BuildContext context,
  Function setState,
  Function updateCity,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      getPrimaryCommanText(getTranslated(context, "PRODUCTNAME_LBL")!, false),
      getCommanSizedBox(),
      getCommanInputTextField(
        getTranslated(context, "PRODUCTHINT_TXT")!,
        1,
        0.06,
        1,
        2,
        context,
      ),
      getCommanSizedBox(),
      Row(
        children: [
          getPrimaryCommanText(getTranslated(context, "Tags")!, false),
          const SizedBox(width: 10),
          Flexible(
            fit: FlexFit.loose,
            child: getSecondaryCommanText(
              getTranslated(context, "(These tags help you in search result)")!,
            ),
          ),
        ],
      ),
      getCommanSizedBox(),
      getCommanInputTextField(
        getTranslated(context,
            "Type in some tags for example AC, Cooler, Flagship Smartphones, Mobiles, Sport etc..")!,
        3,
        0.06,
        1,
        2,
        context,
      ),
      getCommanSizedBox(),
      getPrimaryCommanText("Product Type", false),
      getCommanSizedBox(),
      getIconSelectionDesing(getTranslated(context, "Select Tax")!, 15, context,
          setState, updateCity),
      getCommanSizedBox(),
      getPrimaryCommanText(getTranslated(context, "Select Tax")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(getTranslated(context, "Select Tax")!, 1, context,
          setState, updateCity),
      getCommanSizedBox(),
      addProvider!.currentSellectedProductIsPysical
          ? getPrimaryCommanText(
              getTranslated(context, "Select Indicator")!, false)
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getIconSelectionDesing(getTranslated(context, "Select Indicator")!,
              2, context, setState, updateCity)
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      getPrimaryCommanText(getTranslated(context, "Made In")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
          getTranslated(context, "Made In")!, 3, context, setState, updateCity),
      getCommanSizedBox(),
      addProvider!.currentSellectedProductIsPysical
          ? getPrimaryCommanText('HSN Code', false)
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanInputTextField(
              'HSN Code',
              16,
              0.06,
              1,
              2,
              context,
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      Row(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8),
            // flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, "ShortDescription")!, true),
          ),
        ],
      ),
      (addProvider!.sortDescription == "" ||
              addProvider!.sortDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (addProvider!.sortDescription == "" ||
              addProvider!.sortDescription == null)
          ? GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: grey1,
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  border: Border.all(
                    color: black.withOpacity(0.1),
                  ),
                ),
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, right: 8, bottom: 28),
                  child: Text(getTranslated(context, "Description")!),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                        addProvider!.sortDescription ?? "",
                        getTranslated(context, "Product Sort Description")!),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.setsortDescription(changed);
                  }
                  setState();
                  // addProvider!.sortDescription = changed;
                });
              })
          : GestureDetector(
              child: getDescription(2),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                        addProvider!.sortDescription ?? "",
                        getTranslated(context, "Product Sort Description")!),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.setsortDescription(changed);
                  }
                  setState();
                  // addProvider!.sortDescription = changed;
                });
              },
            )
    ],
  );
}
