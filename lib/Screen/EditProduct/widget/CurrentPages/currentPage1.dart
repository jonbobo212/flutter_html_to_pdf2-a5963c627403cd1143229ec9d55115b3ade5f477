import 'package:flutter/cupertino.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/CurrentPages/currentPage3.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getCommannWidget.dart';
import 'package:sellermultivendor/Screen/EditProduct/widget/getIconSelectionDesingWidget.dart';
import 'package:sellermultivendor/Widget/ProductDescription.dart';
import '../../../../Widget/validation.dart';
import '../../EditProduct.dart';

currentPage1(
  BuildContext context,
  Function update,
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
      getIconSelectionDesing(
          getTranslated(context, "Select Tax")!, 15, context, update),
      getCommanSizedBox(),
      getPrimaryCommanText(getTranslated(context, "Select Tax")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        getTranslated(context, "Select Tax")!,
        1,
        context,
        update,
      ),
      getCommanSizedBox(),
      editProvider!.currentSellectedProductIsPysical
          ? getPrimaryCommanText(
              getTranslated(context, "Select Indicator")!, false)
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getIconSelectionDesing(
              getTranslated(context, "Select Indicator")!,
              2,
              context,
              update,
            )
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      getPrimaryCommanText(getTranslated(context, "Made In")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        getTranslated(context, "Made In")!,
        3,
        context,
        update,
      ),
      getCommanSizedBox(),
      editProvider!.currentSellectedProductIsPysical
          ? getPrimaryCommanText('HSN Code', false)
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanInputTextField(
              getTranslated(context, 'HSN Code')!,
              16,
              0.06,
              1,
              2,
              context,
            )
          : Container(),
      editProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, "ShortDescription")!, true),
          ),
        ],
      ),
      (editProvider!.sortDescription == "" ||
              editProvider!.sortDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (editProvider!.sortDescription == "" ||
              editProvider!.sortDescription == null)
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
                        editProvider!.sortDescription ?? "",
                        getTranslated(context, "Product Sort Description")!),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    editProvider!.sortDescription = changed;
                  }
                  update();
                });
              })
          : GestureDetector(
              child: getDescription(2),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                        editProvider!.sortDescription ?? "",
                        getTranslated(context, "Product Sort Description")!),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    editProvider!.sortDescription = changed;
                  }
                  update();
                });
              },
            )
    ],
  );
}
