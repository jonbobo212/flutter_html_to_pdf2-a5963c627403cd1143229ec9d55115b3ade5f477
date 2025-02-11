import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Model/order/order_filter_model.dart';
import 'package:sellermultivendor/Widget/validation.dart';

Future<dynamic> showOrderListFilterBottomSheet(
    BuildContext context, OrderListFilterModel orderFilterModel) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return OrderListFilterBottomsheetContainer(filterModel: orderFilterModel);
    },
  );
}

// ignore: must_be_immutable
class OrderListFilterBottomsheetContainer extends StatefulWidget {
  OrderListFilterModel filterModel;
  OrderListFilterBottomsheetContainer({super.key, required this.filterModel});

  @override
  State<OrderListFilterBottomsheetContainer> createState() =>
      _OrderListFilterBottomsheetContainerState();
}

class _OrderListFilterBottomsheetContainerState
    extends State<OrderListFilterBottomsheetContainer> {
  late final OrderListFilterModel oldFilters = OrderListFilterModel(
      dateRange: widget.filterModel.dateRange,
      orderType: widget.filterModel.orderType);

  openDateRangePicker() {
    showDateRangePicker(
      context: context,
      firstDate:
          DateTime.now().subtract(const Duration(days: 3650)), //past 10 years
      lastDate: DateTime.now(),
      initialDateRange: oldFilters.dateRange,
    ).then((value) {
      if (value != null) {
        oldFilters.dateRange = value;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text(
                  getTranslated(context, "FILTER_BY")!,
                  style: const TextStyle(
                    fontSize: textFontSize16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 10,
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
                const SizedBox(
                  height: 10,
                ),
                Text(
                  getTranslated(context, 'SELECT_DATE_RANGE')!,
                  style: const TextStyle(color: black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          openDateRangePicker();
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: black12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range_outlined),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  oldFilters.dateRange != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(oldFilters.dateRange!.start)
                                      : getTranslated(context, 'START_DATE')!,
                                  style: oldFilters.dateRange != null
                                      ? null
                                      : TextStyle(
                                          color: black.withOpacity(0.6),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          openDateRangePicker();
                        },
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: black12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range_outlined),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  oldFilters.dateRange != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(oldFilters.dateRange!.end)
                                      : getTranslated(context, 'END_DATE')!,
                                  style: oldFilters.dateRange != null
                                      ? null
                                      : TextStyle(
                                          color: black.withOpacity(0.6),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  getTranslated(context, 'PRODUCT_TYPE')!,
                  style: const TextStyle(color: black),
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: OrderType.values
                      .map(
                        (type) => GestureDetector(
                          onTap: () {
                            oldFilters.orderType = type;
                            setState(() {});
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 15,
                                height: 15,
                                child: Radio<OrderType>(
                                  value: type,
                                  groupValue: oldFilters.orderType,
                                  onChanged: (value) {
                                    oldFilters.orderType = value!;
                                    setState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                getTranslated(context, type.toString())!,
                                style: const TextStyle(
                                  fontSize: textFontSize14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: white,
              boxShadow: [
                BoxShadow(
                  color: black12,
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      widget.filterModel.clearFilters();
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: black),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        getTranslated(context, 'Clear')!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: textFontSize16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      widget.filterModel.applyFilters(filterModel: oldFilters);
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        getTranslated(context, 'Apply')!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: white,
                          fontSize: textFontSize16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
