import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/card_with_title_divider.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/ordered_item_card.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/order/delete_consignment_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_orders_cubit.dart';

class ConsignmentCard extends StatelessWidget {
  final ConsignmentModel consignment;
  final bool? showDeleteButton;
  const ConsignmentCard({
    super.key,
    required this.consignment,
    this.showDeleteButton,
  });

  _onTapDelete(BuildContext context) async {
    var response = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('delete_consignment'.translate(context)),
          content: Text('delete_consignment_message'.translate(context)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('CANCEL'.translate(context))),
            TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Delete'.translate(context))),
          ],
        );
      },
    );

    if (response == true) {
      context.read<DeleteConsignmentCubit>().delete(consignment.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardWithTitleDivider(
      title: consignment.name,
      trailing: Row(
        children: [
          if (showDeleteButton == true)
            BlocConsumer<DeleteConsignmentCubit, DeleteConsignmentState>(
              listener: (context, state) {
                if (state is DeleteConsignmentFail) {
                  log(state.error.toString());
                  setSnackbar(state.error.toString(), context);
                }

                if (state is DeleteConsignmentSuccess) {
                  if (state.id == consignment.id) {
                    context.read<FetchConsignmentsCubit>().remove(state.id);
                    context
                        .read<FetchOrdersCubit>()
                        .updateOrder(state.orderModel);
                    setSnackbar(
                        'DELETE_CONSIGNMENT_SUCCESSFULY'.translate(context),
                        context);
                  }
                }
              },
              builder: (context, state) {
                if (state is DeleteConsignmentInProgress &&
                    state.id == consignment.id) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        color: primary,
                        strokeWidth: 1.5,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    if (state is DeleteConsignmentInProgress &&
                        state.id == consignment.id) {
                      return;
                    }
                    _onTapDelete(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.delete),
                  ),
                );
              },
            ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(consignment.activeStatus.toString().firstUpperCase())
                .bold()
                .size(10),
          ),
        ],
      ),
      child: ListView.separated(
        itemCount: consignment.consignmentItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          print("--> ${consignment.consignmentItems[index].variantName}");
          return OrderdItemCard(
              item: OrderItem.fromConsignment(
                  consignment.consignmentItems[index]));
        },
      ),
    );
  }
}
