import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';

class SelectStatusBottomSheet extends StatefulWidget {
  final OrderStatus? currentOrderStatus;
  final OrderStatus? selectedOrderStatus;
  const SelectStatusBottomSheet(
      {super.key, required this.selectedOrderStatus, this.currentOrderStatus});

  @override
  State<SelectStatusBottomSheet> createState() =>
      _SelectStatusBottomSheetState();
}

class _SelectStatusBottomSheetState extends State<SelectStatusBottomSheet> {
  late OrderStatus? selectedOrder = widget.selectedOrderStatus;
  late List<OrderStatus> orderStatusList = [
    OrderStatus.received,
    OrderStatus.processed,
    OrderStatus.shipped,
    OrderStatus.delivered,
    // if (widget.currentOrderStatus != OrderStatus.delivered &&
    //     widget.currentOrderStatus != OrderStatus.shipped)
    //   OrderStatus.cancelled,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Update status').size(20),
              const CloseButton()
            ],
          ),
        ),
        const Divider(
          height: 0,
          indent: 0,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: orderStatusList
              .sublist(orderStatusList.indexOf(widget.currentOrderStatus!) + 1)
              .length,
          itemBuilder: (context, index) {
            List<OrderStatus> orderStatus = orderStatusList.sublist(
                orderStatusList.indexOf(widget.currentOrderStatus!) + 1);

            return RadioListTile<OrderStatus>(
              value: orderStatus[index],
              contentPadding: EdgeInsets.zero,
              groupValue: selectedOrder,
              title: Text(orderStatus[index].name.firstUpperCase()),
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (value) {
                print("selected order----->${value}-------${selectedOrder}");
                if (value != null) {
                  selectedOrder = value;
                  print("value------->${value}");
                  setState(() {});
                  Navigator.pop(context, selectedOrder);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
