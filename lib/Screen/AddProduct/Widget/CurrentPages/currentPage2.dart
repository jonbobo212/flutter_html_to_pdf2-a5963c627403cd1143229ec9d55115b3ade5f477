//==============================================================================
//============================= UI Part ========================================
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';
import '../getCommanInputTextFieldWidget.dart';
import '../getCommanWidget.dart';
import '../getCommonSwitch.dart';
import '../getIconSelectionDesingWidget.dart';

currentPage2(
  BuildContext context,
  Function update,
  Function updateCitys,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                    getTranslated(context, "Total Allowed Quantity")!, true),
                getCommanSizedBox(),
                getCommanInputTextField(
                  " ",
                  4,
                  0.06,
                  1,
                  3,
                  context,
                ),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                    getTranslated(context, "Minimum Order Quantity")!, true),
                getCommanSizedBox(),
                getCommanInputTextField(
                  " ",
                  5,
                  0.06,
                  1,
                  3,
                  context,
                ),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                    getTranslated(context, "Quantity Step Size")!, true),
                getCommanSizedBox(),
                getCommanInputTextField(
                  " ",
                  6,
                  0.06,
                  1,
                  3,
                  context,
                ),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                    getTranslated(context, "Warranty Period")!, true),
                getCommanSizedBox(),
                getCommanInputTextField(
                  " ",
                  7,
                  0.06,
                  1,
                  2,
                  context,
                ),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                    getTranslated(context, "Guarantee Period")!, true),
                getCommanSizedBox(),
                getCommanInputTextField(
                  " ",
                  8,
                  0.06,
                  1,
                  2,
                  context,
                ),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getPrimaryCommanText(
                    getTranslated(context, "Deliverable Type")!, true),
                getCommanSizedBox(),
                getIconSelectionDesing(
                  getTranslated(context, "(ex, all, include)")!,
                  4,
                  context,
                  update,
                  updateCitys,
                ),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? addProvider!.deliverabletypeValue == "2" ||
                  addProvider!.deliverabletypeValue == "3"
              ? getCommanSizedBox()
              : Container()
          : Container(),
      addProvider!.deliverabletypeValue == "2" ||
              addProvider!.deliverabletypeValue == "3"
          ? getPrimaryCommanText(
              getTranslated(
                  context,
                  AppSettingsRepository.appSettings.isCityWiseDeliveribility
                      ? "SELECT_CITY"
                      : "Select ZipCode")!,
              false)
          : Container(),
      addProvider!.deliverabletypeValue == "2" ||
              addProvider!.deliverabletypeValue == "3"
          ? getCommanSizedBox()
          : const SizedBox.shrink(),
      addProvider!.deliverabletypeValue == "2" ||
              addProvider!.deliverabletypeValue == "3"
          ? getIconSelectionDesing(
              getTranslated(
                  context,
                  AppSettingsRepository.appSettings.isCityWiseDeliveribility
                      ? "PLEASE_SELECT_CITIES"
                      : "not Selected Yet!(ex. 791572)")!,
              6,
              context,
              update,
              updateCitys)
          : Container(),
      getCommanSizedBox(),
      getPrimaryCommanText(getTranslated(context, "selected category")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
          getTranslated(context, "not Selected Yet!(ex. vegetable, Fashion)")!,
          5,
          context,
          update,
          updateCitys),
      getCommanSizedBox(),
      getPrimaryCommanText(getTranslated(context, "Select Brand")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        getTranslated(
            context, "not Selected Yet!(ex. TaTa, Apple, MicroSoft)")!,
        13,
        context,
        update,
        updateCitys,
      ),
      getCommanSizedBox(),
      getPrimaryCommanText(
          getTranslated(context, "Select PickUp Location")!, false),
      getCommanSizedBox(),
      getIconSelectionDesing(
        getTranslated(context, "PickUp Location Not Selected Yet")!,
        16,
        context,
        update,
        updateCitys,
      ),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: getPrimaryCommanText(
                      getTranslated(context, "Is Product Returnable?")!, true),
                ),
                getCommanSwitch(1, update),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: getPrimaryCommanText(
                      getTranslated(context, "Is Product COD Allowed?")!, true),
                ),
                getCommanSwitch(2, update),
              ],
            )
          : Container(),
      getCommanSizedBox(),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: getPrimaryCommanText(
                getTranslated(context, "Tax included in price?")!, true),
          ),
          getCommanSwitch(3, update),
        ],
      ),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: getPrimaryCommanText(
                      getTranslated(context, "Is Product Cancelable?")!, true),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "(Till Received)",
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                getCommanSwitch(4, update),
              ],
            )
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? getCommanSizedBox()
          : Container(),
      addProvider!.currentSellectedProductIsPysical
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getPrimaryCommanText(
                    getTranslated(context, "Is Attachment Required ?")!, true),
                getCommanSwitch(6, update),
              ],
            )
          : Container(),
    ],
  );
}
