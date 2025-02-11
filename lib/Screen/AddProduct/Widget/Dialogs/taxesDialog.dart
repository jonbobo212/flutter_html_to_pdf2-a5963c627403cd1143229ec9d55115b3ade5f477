//------------------------------------------------------------------------------
//============================== Tax Selection =================================

import 'package:flutter/material.dart';
import '../../../../Helper/Color.dart';
import '../../../../Helper/Constant.dart';
import '../../../../Widget/validation.dart';
import '../../Add_Product.dart';

taxesDialog(BuildContext context, Function setStateNow) async {
  if (addProvider!.taxesList.isNotEmpty) {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            addProvider!.taxesState = setStater;
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(circularBorderRadius25),
                  topRight: Radius.circular(circularBorderRadius25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, "Select Tax")!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: primary),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: lightBlack),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: getTaxtList(context, setStateNow),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

List<Widget> getTaxtList(
  BuildContext context,
  Function update,
) {
  return addProvider!.taxesList
      .asMap()
      .map(
        (index, element) => MapEntry(
          index,
          InkWell(
            onTap: () {
              if (addProvider!.selectedTax.contains(element)) {
                addProvider!.selectedTax.remove(element);
              } else {
                addProvider!.selectedTax.add(element);
              }
              addProvider!.taxesState(() {});
              update();
            },
            child: SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(
                  20.0,
                ),
                child: Row(
                  children: [
                    addProvider!.selectedTax.contains(element)
                        ? Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: grey2,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: const BoxDecoration(
                                  color: primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: grey2,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                height: 16,
                                width: 16,
                                decoration: const BoxDecoration(
                                  color: white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        addProvider!.taxesList[index].title!,
                      ),
                    ),
                    Text(
                      "${addProvider!.taxesList[index].percentage!}%",
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      )
      .values
      .toList();
}
