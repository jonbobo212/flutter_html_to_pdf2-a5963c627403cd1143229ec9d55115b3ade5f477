import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Widget/desing.dart';

// ignore: must_be_immutable
class OrderdItemCard extends StatelessWidget {
  final OrderItem item;
  final bool? enableSelection;
  bool? selected;
  final Function(String id)? onSelectionChange;
  final Widget? bottom;
  OrderdItemCard(
      {super.key,
      required this.item,
      this.enableSelection,
      this.selected,
      this.onSelectionChange,
      this.bottom});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enableSelection == true
          ? () {
              onSelectionChange?.call(item.id!);
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: DesignConfiguration.getCacheNotworkImage(
                    imageurlString: item.image ?? '',
                    context: context,
                    boxFit: BoxFit.cover,
                    heightvalue: 65,
                    widthvalue: 65,
                    placeHolderSize: null),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name!.firstUpperCase())
                        .bold()
                        .setMaxLines(lines: 1),
                    Text('QTY: ${item.quantity}'.toString()).size(12),
                    item.type == "variable_product"
                        ? Text("Variant: ${item.variantValues}")
                        : const SizedBox.shrink(),
                    Text(DesignConfiguration.getPriceFormat(
                                context, item.price?.toDouble() ?? 0) ??
                            '')
                        .bold()
                        .color(primary),
                  ],
                ),
              ),
              item.activeStatus != null
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(item.activeStatus
                              .toString()
                              .replaceUnderscores()
                              .firstUpperCase())
                          .bold()
                          .size(10),
                    )
                  : const SizedBox(),
              Container(),
              if (enableSelection == true)
                Radio(
                  value: item.id!,
                  groupValue: selected == true ? item.id : null,
                  onChanged: (value) {
                    onSelectionChange?.call(value!);
                  },
                )
            ],
          ),
          bottom ?? const SizedBox.shrink()
        ],
      ),
    );
  }
}
