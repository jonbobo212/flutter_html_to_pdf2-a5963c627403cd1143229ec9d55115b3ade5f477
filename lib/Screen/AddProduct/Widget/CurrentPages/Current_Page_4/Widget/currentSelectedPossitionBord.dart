import 'package:flutter/material.dart';
import '../../../../../../Helper/Color.dart';
import '../../../../../../Helper/Constant.dart';
import '../../../../../../Widget/validation.dart';
import '../../../../Add_Product.dart';

currentSelectedPossitionBord(
  BuildContext context,
  Function setState,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            addProvider!.curSelPos = 0;
            setState();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(circularBorderRadius5),
                  bottomLeft: Radius.circular(circularBorderRadius5)),
              color: addProvider!.curSelPos == 0 ? primary : grey2,
            ),
            child: Center(
              child: Text(
                getTranslated(context, "General Information")!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: addProvider!.curSelPos == 0 ? white : black,
                ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            addProvider!.curSelPos = 1;
            setState();
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: addProvider!.curSelPos == 1 ? primary : grey2,
            ),
            child: Center(
              child: Text(
                getTranslated(context, "Attributes")!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: addProvider!.curSelPos == 1 ? white : black,
                ),
              ),
            ),
          ),
        ),
      ),
      addProvider!.productType == 'variable_product'
          ? Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  addProvider!.curSelPos = 2;
                  setState();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(circularBorderRadius5),
                        topRight: Radius.circular(circularBorderRadius5)),
                    color: addProvider!.curSelPos == 2 ? primary : grey2,
                  ),
                  child: Center(
                    child: Text(
                      getTranslated(context, "Variations")!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: addProvider!.curSelPos == 2 ? white : black,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    ],
  );
}
