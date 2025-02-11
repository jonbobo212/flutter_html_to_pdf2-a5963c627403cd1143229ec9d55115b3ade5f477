import 'package:flutter/material.dart';
import '../../../../../../Helper/Color.dart';
import '../../../../../../Helper/Constant.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../../../Widget/validation.dart';
import '../../../../Add_Product.dart';
import '../../../getCommanWidget.dart';

class VariantProductSpecialPrice extends StatelessWidget {
  final int pos;
  const VariantProductSpecialPrice({
    Key? key,
    required this.pos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
   padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getPrimaryCommanText(getTranslated(context, "Special Price")!, true),
          Container(
            width: width * 0.4,
            height: height * 0.06,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: addProvider!.variationList[pos].disPrice ?? '',
              style: const TextStyle(
                color: black,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
              //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (String? value) {
                addProvider!.variationList[pos].disPrice = value;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: black,
                  ),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: grey2),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
