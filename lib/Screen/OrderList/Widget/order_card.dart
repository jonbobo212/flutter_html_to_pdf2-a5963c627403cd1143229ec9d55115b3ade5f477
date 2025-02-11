import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Screen/OrderList/order_details_screen.dart';
import 'package:sellermultivendor/Widget/desing.dart';

class OrderCard extends StatefulWidget {
  final OrderModel order;
  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd MMM, yyyy');

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailsScreen(
                      order: widget.order,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration:
            BoxDecoration(color: white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildOrderIdAndDate(dateFormat),
            _divider(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORDER_DETAILS'.translate(context)).bold(),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.order.orderItems.length.clamp(0, 4),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      OrderItem orderItem = widget.order.orderItems[index];
                      return buildOrderItem(orderItem);
                    },
                  ),
                  buildViewMore()
                ],
              ),
            ),
            _divider(context),
            buildProfileCardAndPrice(context)
          ],
        ),
      ),
    );
  }

  Widget buildViewMore() {
    if (widget.order.orderItems.length > 4) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child:
              Text('VIEW_MORE'.translate(context)).underline().color(primary),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget buildOrderIdAndDate(DateFormat dateFormat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text("#${widget.order.id!}"),
          const Spacer(),
          Text(dateFormat.format(DateTime.parse(widget.order.dateAdded!))),
          // Text(dateFormat.parse(widget.order.dateAdded!).toString())
        ],
      ),
    );
  }

  Widget buildOrderItem(OrderItem item) {
    return Row(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 2,
            height: 2,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 27, 25, 25), shape: BoxShape.circle),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 3,
          child: Text(item.name!.firstUpperCase()).setMaxLines(lines: 1),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
        ),
      ],
    );
  }

  Widget buildProfileCardAndPrice(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            child: DesignConfiguration.getCacheNotworkImage(
                imageurlString: widget.order.userProfilePicture,
                context: context,
                boxFit: BoxFit.cover,
                heightvalue: null,
                widthvalue: null,
                placeHolderSize: null),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: primary.withOpacity(0.08)),
            width: 36,
            height: 36,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.order.username!.firstUpperCase()),
              const SizedBox(
                height: 4,
              ),
              Text(widget.order.mobile!)
                  .size(10)
                  .color(const Color.fromARGB(255, 80, 80, 80)),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(DesignConfiguration.getPriceFormat(
                  context, widget.order.totalPayable!.toDouble())!),
              Text(widget.order.paymentMethod!)
                  .size(10)
                  .color(const Color.fromARGB(255, 80, 80, 80)),
            ],
          )
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return IntrinsicHeight(
      child: OverflowBox(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: 1,
        minHeight: 0.8,
        child: Container(
          color: const Color.fromARGB(255, 235, 235, 235),
          margin: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
