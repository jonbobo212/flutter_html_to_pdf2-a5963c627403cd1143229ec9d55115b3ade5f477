// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/card_with_title_divider.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/ordered_item_card.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/send_order_mail.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/cubits/mail/send_mail_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_orders_cubit.dart';

class OrderDetailsTab extends StatefulWidget {
  final OrderModel order;
  const OrderDetailsTab({
    super.key,
    required this.order,
  });

  @override
  State<OrderDetailsTab> createState() => _OrderDetailsTabState();
}

class _OrderDetailsTabState extends State<OrderDetailsTab> {
  final OrdersRepository _repository = OrdersRepository();
  Set<String> loadingItems = {};
  var result = "";

  updateDigitalItemStatus(String itemId, String status) async {
    try {
      if (loadingItems.contains(itemId)) return;
      loadingItems.add(itemId);
      setState(() {});
      context.read<FetchOrdersCubit>().updateOrder(
          await _repository.updateDigitalOrderItemStatus(
              orderID: widget.order.id!, status: status, itemId: itemId));

      loadingItems.remove(itemId);
      setState(() {});
    } catch (e) {
      loadingItems.remove(itemId);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text((e).toString().firstUpperCase()),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            CardWithTitleDivider(
                title: 'Order Overview'.translate(context),
                child: Column(
                  children: [
                    buildDetailRow('ORDER_ID_LBL'.translate(context),
                        "#${widget.order.id!}"),
                    buildDetailRow('Order Date'.translate(context),
                        widget.order.dateAdded!),
                    buildDetailRow('Payment method'.translate(context),
                        widget.order.paymentMethod!),
                    if (widget.order.notes != '')
                      buildDetailRow(
                          'Notes'.translate(context), widget.order.notes!),

                    ///if its digital order then hide
                    if (!widget.order.isDigitalOrder) ...{
                      if (widget.order.deliveryDate != '')
                        buildDetailRow(
                            'preferred_delivery_date'.translate(context),
                            widget.order.deliveryDate!),
                      if (widget.order.deliveryTime != '')
                        buildDetailRow(
                            'preferred_delivery_time'.translate(context),
                            widget.order.deliveryTime!),
                    }
                  ],
                )),
            const SizedBox(
              height: 15,
            ),
            CardWithTitleDivider(
                title: 'PRODUCTS'.translate(context),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: widget.order.orderItems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    return OrderdItemCard(
                      item: widget.order.orderItems[index],
                      bottom: widget.order.isDigitalOrder
                          ? Row(
                              children: [
                                if (widget
                                        .order.orderItems[index].activeStatus !=
                                    'delivered')
                                  MaterialButton(
                                    color: white,
                                    height: 30,
                                    textColor: primary,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(color: primary),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onPressed: () async {
                                      result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DigitalUpdateStatusDialog(
                                              status: result,
                                            );
                                          });

                                      if (result != "") {
                                        await updateDigitalItemStatus(
                                            widget.order.orderItems[index].id!,
                                            result);
                                      }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (loadingItems.contains(
                                            widget.order.orderItems[index].id))
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: SizedBox(
                                                width: 15,
                                                height: 15,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: primary,
                                                  strokeWidth: 1.5,
                                                )),
                                          ),
                                        Text(
                                            'update_status'.translate(context)),
                                      ],
                                    ),
                                  ),
                                const SizedBox(
                                  width: 5,
                                ),
                                MaterialButton(
                                  color: primary,
                                  height: 30,
                                  textColor: white,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                                SendMailCubit(),
                                            child: SendOrderMailScreen(
                                              order: widget.order,
                                              item: widget
                                                  .order.orderItems[index],
                                            ),
                                          ),
                                        ));
                                  },
                                  child: Text('send_email'.translate(context)),
                                ),
                              ],
                            )
                          : null,
                    );
                  },
                )),
            const SizedBox(
              height: 15,
            ),
            if (widget.order.orderattachments!.isNotEmpty)
              Column(
                children: [
                  CardWithTitleDivider(
                    title: 'ORDER_ATTACHMENTS'.translate(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.order.orderattachments!.length,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final attachmentUrl =
                                  widget.order.orderattachments![index];
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: /*PhotoView(
                                              backgroundDecoration:
                                                  const BoxDecoration(
                                                      color: white),
                                              initialScale:
                                                  PhotoViewComputedScale
                                                          .contained *
                                                      0.9,
                                              minScale: PhotoViewComputedScale
                                                      .contained *
                                                  0.9,
                                              maxScale: PhotoViewComputedScale
                                                      .contained *
                                                  1.8,
                                              gaplessPlayback: false,
                                              customSize:
                                                  MediaQuery.of(context).size,
                                              imageProvider: NetworkImage(
                                                attachmentUrl,
                                              ),
                                            )*/
                                              InteractiveViewer(
                                            panEnabled: true,
                                            minScale: 1.0,
                                            maxScale: 4.0,
                                            child: Image.network(
                                              attachmentUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      DesignConfiguration.getCacheNotworkImage(
                                    imageurlString: attachmentUrl,
                                    context: context,
                                    boxFit: BoxFit.cover,
                                    heightvalue: 65,
                                    widthvalue: 65,
                                    placeHolderSize: null,
                                  ),
                                ),
                              );
                            },
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
            CardWithTitleDivider(
                title: widget.order.isDigitalOrder
                    ? 'contact_details'.translate(context)
                    : 'SHIPPING_DETAIL'.translate(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.order.username!.firstUpperCase()).bold(),
                    if (!widget.order.isDigitalOrder)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(widget.order.address!),
                      ),
                    Text(
                        '${"phone_number".translate(context)}: ${widget.order.mobile}'),
                  ],
                )),
            const SizedBox(
              height: 15,
            ),
            CardWithTitleDivider(
                title: 'price_details'.translate(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetailRow(
                        'price'.translate(context),
                        DesignConfiguration.getPriceFormat(
                            context, widget.order.total!.toDouble())!),
                    buildDetailRow(
                        'delivery_charge'.translate(context),
                        DesignConfiguration.getPriceFormat(
                            context, widget.order.deliveryCharge!.toDouble())!),
                    buildDetailRow(
                        'promocd'.translate(context),
                        DesignConfiguration.getPriceFormat(
                            context, widget.order.promoDiscount!.toDouble())!),
                    buildDetailRow(
                        'wallet_balance'.translate(context),
                        DesignConfiguration.getPriceFormat(
                            context, widget.order.walletBalance!.toDouble())!),
                    const Divider(
                      height: 0,
                      indent: 0,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('total'.translate(context)).size(16),
                        Text(DesignConfiguration.getPriceFormat(context,
                                widget.order.totalPayable!.toDouble())!)
                            .size(16),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title)),
          Expanded(child: Text(content))
        ],
      ),
    );
  }
}

class DigitalUpdateStatusDialog extends StatefulWidget {
  final String status;
  const DigitalUpdateStatusDialog({
    super.key,
    required this.status,
  });

  @override
  State<DigitalUpdateStatusDialog> createState() =>
      _DigitalUpdateStatusDialogState();
}

class _DigitalUpdateStatusDialogState extends State<DigitalUpdateStatusDialog> {
  late String status = widget.status;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('update_status'.translate(context)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile(
            value: 'received',
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: status,
            title: Text('received'.translate(context)),
            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          ),
          RadioListTile(
            value: 'delivered',
            controlAffinity: ListTileControlAffinity.trailing,
            groupValue: status,
            title: Text('delivered'.translate(context)),
            onChanged: (value) {
              setState(() {
                status = value!;
              });
            },
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('cancel'.translate(context))),
        TextButton(
            onPressed: () {
              Navigator.pop(context, status);
            },
            child: Text('Update'.translate(context))),
      ],
    );
  }
}
