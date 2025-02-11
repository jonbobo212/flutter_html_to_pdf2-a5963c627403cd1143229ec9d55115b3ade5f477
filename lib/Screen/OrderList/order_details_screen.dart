// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/consignmnet_item_selection_sheet.dart';
import 'package:sellermultivendor/Screen/OrderList/consignment/consignment_screen.dart';
import 'package:sellermultivendor/Screen/OrderList/order_details_tab.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/Widget/errorContainer.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/order/delete_consignment_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_orders_cubit.dart';

ValueNotifier<bool> showCreateParcelButton = ValueNotifier(true);

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? order;
  final String? id;
  const OrderDetailsScreen({super.key, this.order, this.id});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late OrderModel? order = widget.order;
  final OrdersRepository _ordersRepository = OrdersRepository();
  bool orderFromIdLoadError = false;
  late List<OrderItem> pendingConsignmentItems = widget.order!.orderItems
      .where((e) =>
          e.isConsignmentCreated == '0' &&
          e.activeStatus!.toLowerCase() != "cancelled")
      .toList();
  @override
  void initState() {
    if (order != null) {
      context.read<FetchConsignmentsCubit>().fetch(orderId: order!.id!);
      print(
          "DELIVERY_BOY_OTP_SETTING55------->${DELIVERY_BOY_OTP_SETTING.toString()}");
    } else {
      fetchOrderOfId();
    }

    super.initState();
  }

  Future<void> fetchOrderOfId() async {
    try {
      setState(() {});
      order = await _ordersRepository.fetchOrderById(widget.id!);
      orderFromIdLoadError = false;
    } catch (e) {
      setSnackbar('somethingMSg'.translate(context), context);
      orderFromIdLoadError = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ///if order not loaded yet
    if (order == null) {
      return Scaffold(
          body: orderFromIdLoadError
              ? Center(
                  child: ErrorContainer(
                    onTapRetry: () {
                      fetchOrderOfId();
                    },
                    errorMessage: 'somethingMSg'.translate(context),
                  ),
                )
              : DesignConfiguration.showCircularProgress(true, primary),
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle.light
                .copyWith(statusBarColor: Colors.transparent),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [grad1Color, grad2Color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1],
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.only(),
              ),
            ),
            leading: BackButton(
              color: white,
              onPressed: () {
                if (consignmentNavigator.currentContext != null &&
                    Navigator.canPop(consignmentNavigator.currentContext!)) {
                  showCreateParcelButton.value = true;
                  Navigator.pop(consignmentNavigator.currentContext!);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ));
    }
    return BlocBuilder<FetchOrdersCubit, FetchOrdersState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                return;
              }
              if (consignmentNavigator.currentContext != null &&
                  Navigator.canPop(consignmentNavigator.currentContext!)) {
                showCreateParcelButton.value = true;

                Navigator.pop(consignmentNavigator.currentContext!);
              } else {
                Navigator.pop(context);
              }
            },
            child: Scaffold(
              backgroundColor: lightWhite,
              bottomNavigationBar: order!.isDigitalOrder
                  ? null
                  : ValueListenableBuilder(
                      valueListenable: showCreateParcelButton,
                      builder: (context, show, c) {
                        //Hide if all items are delivered
                        if (order!.orderItems.every(
                            (element) => element.activeStatus == 'delivered')) {
                          return const SizedBox.shrink();
                        }
                        //Hide if all consignment created
                        if (order!.orderItems.every(
                            (element) => element.isConsignmentCreated == '1')) {
                          return const SizedBox.shrink();
                        }

                        if (order!.orderItems.every(
                            (element) => element.activeStatus == "awaiting")) {
                          return const SizedBox.shrink();
                        }

                        if (pendingConsignmentItems.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        if (!show) {
                          return const SizedBox.shrink();
                        }

                        return BottomAppBar(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: MaterialButton(
                              textColor: white,
                              height: 41,
                              onPressed: () {
                                if (order!.isAllItemsConsignmentCreated) {
                                  setSnackbar(
                                      'ALL_ORDERS_ARE_CONSIGNED'
                                          .translate(context),
                                      context);
                                  return;
                                }
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  builder: (context) {
                                    return ConsignmentItemSelectionBottomSheet(
                                      orderItems: order!.orderItems,
                                      orderId: order!.id!,
                                    );
                                  },
                                );
                              },
                              color: primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19)),
                              child: Text('Create Parcel'.translate(context)),
                            ),
                          ),
                        );
                      }),
              appBar: AppBar(
                // automaticallyImplyLeading: false,
                systemOverlayStyle: SystemUiOverlayStyle.light
                    .copyWith(statusBarColor: Colors.transparent),
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [grad1Color, grad2Color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1],
                      tileMode: TileMode.clamp,
                    ),
                    borderRadius: BorderRadius.only(),
                  ),
                ),
                leading: BackButton(
                  color: white,
                  onPressed: () {
                    if (consignmentNavigator.currentContext != null &&
                        Navigator.canPop(
                            consignmentNavigator.currentContext!)) {
                      showCreateParcelButton.value = true;
                      Navigator.pop(consignmentNavigator.currentContext!);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
                backgroundColor: white,
                title: Text('ORDER_DETAILS'.translate(context)).color(white),
                bottom: (!order!.isDigitalOrder)
                    ? TabBar(
                        tabs: [
                          Tab(
                            child: Text('ORDER_DETAILS'.translate(context))
                                .color(white),
                          ),
                          Tab(
                              child: Text('Parcel Details'.translate(context))
                                  .color(white)),
                        ],
                        onTap: (value) {
                          if (value == 0) {
                            showCreateParcelButton.value = true;
                          }
                        },
                      )
                    : null,
              ),
              body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    OrderDetailsTab(
                      order: order!,
                    ),
                    BlocProvider(
                      create: (context) => DeleteConsignmentCubit(),
                      child: ConsignmentScreen(
                        order: order!,
                      ),
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}
