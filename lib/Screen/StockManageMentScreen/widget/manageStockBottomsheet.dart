import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Model/ProductModel/Product.dart';
import 'package:sellermultivendor/Model/ProductModel/Variants.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/StockManageMentScreen/StockManageMentList.dart';
import 'package:sellermultivendor/Widget/validation.dart';

Future<dynamic> showStockManageBottomsheet(
    BuildContext context, Product product) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return StockManageBottomsheetContainer(
        product: product,
      );
    },
  );
}

class StockManageBottomsheetContainer extends StatefulWidget {
  final Product product;
  const StockManageBottomsheetContainer({super.key, required this.product});

  @override
  State<StockManageBottomsheetContainer> createState() =>
      _StockManageBottomsheetContainerState();
}

class _StockManageBottomsheetContainerState
    extends State<StockManageBottomsheetContainer> {
  late final bool isVariantStockManageVariantlevel =
      widget.product.stockType == "2";
  late final bool isVariantStockManageProductlevel =
      widget.product.stockType == "1";

  bool isAdd = true;
  bool isLoading = false;

  late Product_Varient selectedVariant = widget.product.prVarientList![0];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController quantityController = TextEditingController();

  String getCurrentStock() {
    final stock = isVariantStockManageVariantlevel
        ? selectedVariant.stock!
        : isVariantStockManageProductlevel
            ? widget.product.productVariantStock!
            : widget.product.stock!;
    return stock.isEmpty ? '0' : stock;
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  Widget _buildVariantSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 48,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: grey2),
        borderRadius: BorderRadius.circular(circularBorderRadius7),
      ),
      child: DropdownButton<Product_Varient>(
        value: selectedVariant,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: black,
        ),
        underline: const SizedBox.shrink(),
        dropdownColor: grey1,
        onChanged: (Product_Varient? value) {
          selectedVariant = value!;
          setState(() {});
        },
        elevation: 8,
        isExpanded: true,
        menuWidth: width * .9,
        items: widget.product.prVarientList!
            .map(
              (e) => DropdownMenuItem<Product_Varient>(
                value: e,
                child: Text(
                  e.varient_value ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: black,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius10),
            topRight: Radius.circular(circularBorderRadius10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15.0, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: textFontSize16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: black12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isVariantStockManageVariantlevel) ...[
                    Text(
                      getTranslated(context, 'SELECT_VARIANT')!,
                      style: const TextStyle(
                        fontSize: textFontSize14,
                        color: black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    _buildVariantSelector(),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated(context, 'CURRENT_STOCK')!,
                              style: const TextStyle(
                                fontSize: textFontSize14,
                                color: black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              height: 48,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                color: grey2.withOpacity(0.4),
                                border: Border.all(color: grey2),
                                borderRadius: BorderRadius.circular(
                                    circularBorderRadius7),
                              ),
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                getCurrentStock(),
                                style: const TextStyle(
                                  fontSize: textFontSize16,
                                  color: black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated(context, 'Quantity')!,
                              style: const TextStyle(
                                fontSize: textFontSize14,
                                color: black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.normal,
                              ),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return getTranslated(
                                      context, 'PLEASE_ENTER_AMOUNT');
                                } else {
                                  int? intValue = int.tryParse(value);
                                  if (intValue == null) {
                                    return getTranslated(
                                        context, 'INVALID_AMOUNT');
                                  }
                                  if (intValue <= 0) {
                                    return getTranslated(
                                        context, 'INVALID_AMOUNT');
                                  }
                                  if (!isAdd &&
                                      intValue > int.parse(getCurrentStock())) {
                                    return getTranslated(
                                        context, 'INVALID_AMOUNT');
                                  }
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                prefixIconConstraints: const BoxConstraints(
                                    minWidth: 40, maxHeight: 20),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: black,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      circularBorderRadius7),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: red,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      circularBorderRadius7),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: black,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      circularBorderRadius7),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: grey2),
                                  borderRadius: BorderRadius.circular(
                                      circularBorderRadius8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    getTranslated(context, 'Type')!,
                    style: const TextStyle(color: black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 15,
                        height: 15,
                        child: Radio<bool>(
                          value: true,
                          groupValue: isAdd,
                          onChanged: (value) {
                            isAdd = true;
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'Add')!,
                        style: const TextStyle(
                          fontSize: textFontSize14,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 15,
                        height: 15,
                        child: Radio<bool>(
                          value: false,
                          groupValue: isAdd,
                          onChanged: (value) {
                            isAdd = false;
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getTranslated(context, 'SUBTRACT')!,
                        style: const TextStyle(
                          fontSize: textFontSize14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      if (isLoading) {
                        return;
                      }
                      if (formKey.currentState!.validate()) {
                        setState(() {});
                        isLoading = true;
                        await stockManagementProvider!.setStockValue(
                          selectedVariant.id!,
                          context,
                          isAdd,
                          quantityController.text.toString(),
                          getCurrentStock(),
                        );
                        isLoading = false;
                        setState(() {});
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: Container(
                      padding: isLoading
                          ? const EdgeInsets.symmetric(vertical: 2)
                          : const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: white,
                            )
                          : Text(
                              getTranslated(context, 'Save Settings')!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: white,
                                fontSize: textFontSize16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
