import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sellermultivendor/Widget/ProductDescription.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Provider/settingProvider.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';
import '../ImagesWidgets.dart';
import '../getCommanBtn.dart';
import '../getCommanInputTextFieldWidget.dart';
import '../getCommanWidget.dart';
import '../getIconSelectionDesingWidget.dart';

currentPage3(
  BuildContext context,
  Function setState,
  Function updateCitys,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      getPrimaryCommanText(getTranslated(context, "Product Main Image")!, true),
      getCommanSizedBox(),
      Row(children: [
        getCommonButtonAdd(
            getTranslated(context, "Upload")!, 1, setState, context),
        getCommanSizedBoxWidth(),
        getCommanSizedBoxWidth(),
        addProvider!.productImage != '' ? selectedMainImageShow() : Container(),
      ]),
      getCommanSizedBox(),
      getCommanSizedBox(),
      getPrimaryCommanText(
          getTranslated(context, "Product Other Images")!, true),
      getCommanSizedBox(),

      Row(
        children: [
          getCommonButtonAdd(
              getTranslated(context, "Upload")!, 2, setState, context),
          getCommanSizedBoxWidth(),
          Expanded(
            flex: 3,
            child: addProvider!.otherImageUrl.isNotEmpty
                ? uploadedOtherImageShow(setState)
                : Container(),
          )
        ],
      ),
      getCommanSizedBox(),
      getPrimaryCommanText(getTranslated(context, "Select Video Type")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
          getTranslated(context, "not Selected Yet!(ex. Vimeo, Youtube)")!,
          8,
          context,
          setState,
          updateCitys),
      getCommanSizedBox(),
      (addProvider!.selectedTypeOfVideo == 'vimeo' ||
              addProvider!.selectedTypeOfVideo == 'youtube')
          ? getCommanInputTextField(
              addProvider!.selectedTypeOfVideo == 'vimeo'
                  ? getTranslated(
                      context,
                      "Paste Vimeo Video link / url ...!",
                    )!
                  : addProvider!.selectedTypeOfVideo == 'youtube'
                      ? getTranslated(
                          context,
                          "Paste Youtube Video link / url...!",
                        )!
                      : getTranslated(context, "Self Hosted")!,
              9,
              0.06,
              1,
              2,
              context,
            )
          : addProvider!.selectedTypeOfVideo == 'self_hosted'
              ? Column(
                  children: [
                    videoUpload(context, setState),
                    selectedVideoShow(),
                  ],
                )
              : Container(),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, 'Product Description')!, true),
          ),
        ],
      ),
      (addProvider!.description == "" || addProvider!.description == null)
          ? Container()
          : getCommanSizedBox(),
      (addProvider!.description == "" || addProvider!.description == null)
          ? GestureDetector(
              onTap: (() {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      addProvider!.description ?? "",
                      getTranslated(context, "Product Description")!,
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.setDescription(changed);
                  }
                  setState();
                  // addProvider!.description = changed;
                });
                // setState();
              }),
              child: Container(
                decoration: BoxDecoration(
                  color: grey1,
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  border: Border.all(
                    color: grey2,
                    width: 1,
                  ),
                ),
                width: width,
                child: Container(
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, left: 8, right: 8, bottom: 28),
                    child: Text(
                      getTranslated(context, "Description")!,
                      style: const TextStyle(color: lightBlack),
                    ),
                  ),
                ),
              ),
            )
          : GestureDetector(
              child: getDescription(1),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                      addProvider!.description ?? "",
                      getTranslated(context, "Product Description")!,
                    ),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.setDescription(changed);
                  }
                  // addProvider!.description = changed;
                  setState();
                });
                // setState();
              },
            ),

      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, "Extra Description")!, true),
          ),
        ],
      ),
      (addProvider!.extraDescription == "" ||
              addProvider!.extraDescription == null)
          ? Container()
          : getCommanSizedBox(),
      (addProvider!.extraDescription == "" ||
              addProvider!.extraDescription == null)
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
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                        addProvider!.extraDescription ?? "",
                        getTranslated(context, "Product Extra Description")!),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.extraDescription = changed;
                  }
                  setState();
                });
              },
            )
          : GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: grey1,
                  borderRadius: BorderRadius.circular(circularBorderRadius5),
                  border: Border.all(
                    color: black.withOpacity(0.1),
                  ),
                ),
                width: width,
                child: Container(
                  child: getDescription(3),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute<String>(
                    builder: (context) => ProductDescription(
                        addProvider!.extraDescription ?? "",
                        getTranslated(context, "Product Extra Description")!),
                  ),
                ).then((changed) {
                  if (changed?.trim().isNotEmpty ?? false) {
                    addProvider!.extraDescription = changed;
                  }
                  setState();
                });
              },
            ),
    ],
  );
}

//==============================================================================
//=========================== Description ======================================

getDescription(int fromdescription) {
  return Container(
    decoration: BoxDecoration(
      color: grey1,
      borderRadius: BorderRadius.circular(circularBorderRadius5),
      border: Border.all(
        color: grey2,
        width: 1,
      ),
    ),
    width: width,
    child: Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: HtmlWidget(
        fromdescription == 1
            ? addProvider!.description ?? ""
            : fromdescription == 2
                ? addProvider!.sortDescription ?? ""
                : addProvider!.extraDescription ?? "",
        onErrorBuilder: (context, element, error) =>
            Text('$element error: $error'),
        onLoadingBuilder: (context, element, loadingProgress) =>
            const CircularProgressIndicator(),
        onTapUrl: (url) {
          launchUrl(
            Uri.parse(url),
          );
          return true;
        },
        renderMode: RenderMode.column,
        textStyle: const TextStyle(fontSize: textFontSize14),
      ),
    ),
  );
}
