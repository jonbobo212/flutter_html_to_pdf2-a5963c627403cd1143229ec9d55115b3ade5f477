import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/delivery_boy_model.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/cancel_shiprocket_order_confirmation_dialog.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/card_with_title_divider.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/consignment_card.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/createShiprocketOrderBottomsheet.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/deliveryboy_selection_sheet.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/select_status_bottomsheet.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/update_tracking_details_bottomsheet.dart';
import 'package:sellermultivendor/Widget/api.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/deliveryboy/fetch_deliveryboy_cubit.dart';
import 'package:sellermultivendor/cubits/order/cancel_shiprocket_order_cubit.dart';
import 'package:sellermultivendor/cubits/order/create_shiprocket_order_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignment_invoice.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignment_label.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/generate_awb_cubit.dart';
import 'package:sellermultivendor/cubits/order/send_pickup_request_cubit.dart';
import 'package:sellermultivendor/cubits/order/update_consignment_status_cubit.dart';
import 'package:sellermultivendor/cubits/order/update_shiprocket_order_status_cubit.dart';
import 'package:sellermultivendor/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:http/http.dart' as http;

class ConsignmentDetails extends StatefulWidget {
  final ConsignmentModel consignment;
  final OrderModel order;
  const ConsignmentDetails(
      {super.key, required this.consignment, required this.order});

  @override
  State<ConsignmentDetails> createState() => _ConsignmentDetailsState();
}

class _ConsignmentDetailsState extends State<ConsignmentDetails> {
  OrderStatus? selectedOrderStatus;
  DeliveryBoy? selectedDeliveryBoy;
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isRequestSent = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Widget buildDetailRow(String title, String content) {
    print("---> $title : $content");
    return content.trim().isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Flexible(
                  child: Text(
                    content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                )
              ],
            ),
          );
  }

  _onTapUpdateStatus() {
    if (selectedOrderStatus == null) {
      if (selectedOrderStatus!.name == 'delivered' &&
          DELIVERY_BOY_OTP_SETTING == "1") {
        showPopUpViewForOTP();
      }
      setSnackbar("set_order_status".translate(context), context,
          margin: const EdgeInsets.only(bottom: 100),
          backgroundColor: lightWhite,
          action: SnackBarBehavior.floating);
      return;
    }
    if (selectedDeliveryBoy == null &&
        widget.consignment.trackingDetails!.courierAgency == null) {
      setSnackbar("dboy_update".translate(context), context,
          margin: const EdgeInsets.only(bottom: 100),
          backgroundColor: lightWhite,
          action: SnackBarBehavior.floating);
      return;
    }

    if (selectedOrderStatus!.name == 'delivered') {
      if (selectedDeliveryBoy != null) {
        {
          context.read<UpdateConsignmentStatusCubit>().update(
                consignmentId: widget.consignment.id,
                status: selectedOrderStatus!.name,
                deliveryboyId: selectedDeliveryBoy!.id,
                otp: otpController.text,
              );
        }
      } else {
        context.read<UpdateConsignmentStatusCubit>().update(
              consignmentId: widget.consignment.id,
              status: selectedOrderStatus!.name,
              otp: otpController.text,
            );
      }
    } else {
      if (selectedDeliveryBoy != null) {
        {
          context.read<UpdateConsignmentStatusCubit>().update(
              consignmentId: widget.consignment.id,
              status: selectedOrderStatus!.name,
              deliveryboyId: selectedDeliveryBoy!.id);
        }
      } else {
        context.read<UpdateConsignmentStatusCubit>().update(
            consignmentId: widget.consignment.id,
            status: selectedOrderStatus!.name);
      }
    }
    print(
        "selectedDeliveryBoy---> ${selectedDeliveryBoy!.name} -----> ${selectedOrderStatus!.name}");
    selectedOrderStatus = null;
    selectedDeliveryBoy = null;
    otpController.clear();
  }

  Widget _buildShiprocketBottombar() {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      notchMargin: 0,
      child: FittedBox(
        fit: BoxFit.none,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.consignment.isShiprocketOrderCreatedBool) ...[
              SizedBox(
                width: context.screenWidth * 00.9,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.consignment.activeStatus
                            .toString()
                            .toLowerCase() !=
                        'delivered') ...[
                      Expanded(
                        child: BlocConsumer<CancelShiprocketOrderCubit,
                            CancelShiprocketOrderState>(
                          listener: (context, state) {
                            if (state is CancelShiprocketOrderSuccess) {
                              context
                                  .read<FetchConsignmentsCubit>()
                                  .updateConsignment(state.consignment);
                              setState(() {});
                              setSnackbar(
                                  getTranslated(context,
                                      'SHIPROCKET_ORDER_CANCELED_SUCCESSFULLY')!,
                                  context);
                            } else if (state is CancelShiprocketOrderFail) {
                              setSnackbar(state.errorMessage, context);
                            }
                          },
                          builder: (context, state) {
                            return OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: black),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                if (state is CancelShiprocketOrderInProgress) {
                                  return;
                                }
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const CancelShiprocketOrderConfirmationDialog();
                                  },
                                ).then((value) {
                                  if (value == true) {
                                    context
                                        .read<CancelShiprocketOrderCubit>()
                                        .cancelShiprocketOrder(
                                            shiprocketOrderId: widget
                                                    .consignment
                                                    .trackingDetails
                                                    ?.shiprocketOrderId ??
                                                "");
                                  }
                                });
                              },
                              child: Row(
                                children: [
                                  if (state
                                      is CancelShiprocketOrderInProgress) ...[
                                    const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        color: black,
                                        strokeWidth: 1.5,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                  Expanded(
                                    child: Text(
                                      getTranslated(context, 'CANCEL_ORDER')!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primary),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          if (widget.consignment.trackingDetails == null ||
                              widget.consignment.trackingDetails!.url == null ||
                              widget
                                  .consignment.trackingDetails!.url!.isEmpty) {
                            setSnackbar(
                                "tracking_url_not_added".translate(context),
                                context);
                            return;
                          }
                          final Uri uri = Uri.parse(
                              widget.consignment.trackingDetails!.url ?? "");
                          try {
                            await launchUrl(uri);
                          } catch (e) {
                            setSnackbar(
                                getTranslated(context, 'UNABLE_TO_OPEN_URL')!,
                                context);
                          }
                        },
                        child: Text(
                          getTranslated(context, 'TRACK_ORDER')!,
                          style: const TextStyle(
                              color: primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<UpdateShiprocketOrderStatusCubit,
                  UpdateShiprocketOrderStatusState>(listener: (context, state) {
                if (state is UpdateShiprocketOrderStatusSuccess) {
                  context
                      .read<FetchConsignmentsCubit>()
                      .updateConsignment(state.consignment);
                  setState(() {});
                  setSnackbar(
                      getTranslated(
                          context, 'SHIPROCKET_ORDER_UPDATED_SUCCESSFULLY')!,
                      context);
                } else if (state is UpdateShiprocketOrderStatusFail) {
                  setSnackbar(state.errorMessage, context);
                }
              }, builder: (context, state) {
                return MaterialButton(
                  textColor: white,
                  height: 41,
                  disabledColor: primary.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  minWidth: context.screenWidth * 00.9,
                  onPressed: () {
                    if (state is UpdateShiprocketOrderStatusInProgress) {
                      return;
                    }
                    context
                        .read<UpdateShiprocketOrderStatusCubit>()
                        .updateShiprocketOrderStatus(
                            trackingId: widget
                                    .consignment.trackingDetails!.trackingId ??
                                "");
                  },
                  color: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is UpdateShiprocketOrderStatusInProgress)
                        const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: white,
                            strokeWidth: 1.5,
                          ),
                        ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(getTranslated(context, 'REFRESH_ORDER_STATUS')!),
                    ],
                  ),
                );
              }),
            ] else ...[
              BlocConsumer<CreateShiprocketOrderCubit,
                  CreateShiprocketOrderState>(
                listener: (context, state) {
                  if (state is CreateShiprocketOrderSuccess) {
                    context
                        .read<FetchConsignmentsCubit>()
                        .updateConsignment(state.consignment);
                    setState(() {});
                    setSnackbar(
                        getTranslated(
                            context, 'SHIPROCKET_ORDER_CREATED_SUCCESSFULLY')!,
                        context);
                  } else if (state is CreateShiprocketOrderFail) {
                    setSnackbar(state.errorMessage, context);
                  }
                },
                builder: (context, state) {
                  return MaterialButton(
                    textColor: white,
                    height: 41,
                    disabledColor: primary.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    minWidth: context.screenWidth * 00.9,
                    onPressed: () {
                      if (state is CreateShiprocketOrderInProgress) {
                        return;
                      }
                      showCreateShiprocketOrderBottomSheet(
                          rootNavigatorKey.currentContext!,
                          cubit: context.read<CreateShiprocketOrderCubit>(),
                          pickupLocation: widget.order.pickupLocation ?? '',
                          consignmentId: widget.consignment.id);
                    },
                    color: primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state is CreateShiprocketOrderInProgress)
                          const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: white,
                                strokeWidth: 1.5,
                              )),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                            getTranslated(context, 'CREATE_SHIPROCKET_ORDER')!),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<bool> checkPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      if (result.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightWhite,
      floatingActionButton: !widget.order.isDigitalOrder &&
              widget.consignment.activeStatus != 'delivered' &&
              !widget.consignment.isShiprocketConsignmentBool
          ? FloatingActionButton(
              onPressed: () async {
                await showUpdateTrackingDetailsBottomsheet(
                    rootNavigatorKey.currentContext!, widget.consignment);
                setState(() {});
              },
              child: const Icon(
                Icons.add_location_alt_rounded,
                color: white,
              ),
            )
          : null,
      bottomNavigationBar: widget.consignment.isShiprocketConsignmentBool
          ? MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => CreateShiprocketOrderCubit(),
                ),
                BlocProvider(
                  create: (context) => CancelShiprocketOrderCubit(),
                ),
                BlocProvider(
                  create: (context) => UpdateShiprocketOrderStatusCubit(),
                ),
              ],
              child: Builder(builder: (context) {
                return _buildShiprocketBottombar();
              }),
            )
          : widget.consignment.activeStatus != 'delivered'
              ? BottomAppBar(
                  padding: EdgeInsets.zero,
                  notchMargin: 0,
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: context.screenWidth * 00.9,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildCustomDropdownCard(
                                title: selectedOrderStatus == null
                                    ? 'Update Status'
                                    : selectedOrderStatus!.name
                                        .toString()
                                        .firstUpperCase(),
                                onTap: () async {
                                  selectedOrderStatus =
                                      await showModalBottomSheet(
                                    isDismissible: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    context: rootNavigatorKey.currentContext!,
                                    builder: (context) {
                                      print(
                                          " selectedOrderStatus----->${selectedOrderStatus}");
                                      return SelectStatusBottomSheet(
                                        selectedOrderStatus:
                                            selectedOrderStatus,
                                        currentOrderStatus: OrderStatus.values
                                            .byName(widget
                                                .consignment.activeStatus),
                                      );
                                    },
                                  );
                                  // .then(
                                  //   (value) {
                                  //     //TODO: add condition for otp system is on or off
                                  //     if (value == OrderStatus.delivered &&
                                  //         DELIVERY_BOY_OTP_SETTING == "1") {
                                  //       showPopUpViewForOTP();
                                  //     }
                                  //   },
                                  // );

                                  setState(() {});
                                },
                              ),
                              buildVerticalDivider(),
                              buildCustomDropdownCard(
                                title: selectedDeliveryBoy != null
                                    ? selectedDeliveryBoy!.name.firstUpperCase()
                                    : 'Delivery Boy',
                                onTap: () async {
                                  selectedDeliveryBoy =
                                      await showModalBottomSheet(
                                    isDismissible: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    isScrollControlled: true,
                                    constraints: BoxConstraints(
                                      minHeight: context.screenHeight * 0.6,
                                      maxHeight: context.screenHeight * 0.9,
                                    ),
                                    context: rootNavigatorKey.currentContext!,
                                    builder: (context) {
                                      return BlocProvider(
                                        create: (context) =>
                                            FetchDeliveryboyCubit(),
                                        child:
                                            const DeliveryboySelectionSheet(),
                                      );
                                    },
                                  );
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        MaterialButton(
                          textColor: white,
                          height: 41,
                          disabledColor: primary.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          minWidth: context.screenWidth * 00.9,
                          onPressed: context
                                  .watch<UpdateConsignmentStatusCubit>()
                                  .state is! UpdateConsignmentStatusInProgress
                              ? _onTapUpdateStatus
                              : null,
                          color: primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (context
                                  .watch<UpdateConsignmentStatusCubit>()
                                  .state is UpdateConsignmentStatusInProgress)
                                const SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: white,
                                      strokeWidth: 1.5,
                                    )),
                              const SizedBox(
                                width: 8,
                              ),
                              const Text('Update Status'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
      body: BlocListener<UpdateConsignmentStatusCubit,
          UpdateConsignmentStatusState>(
        listener: (context, state) {
          if (state is UpdateConsignmentStatusInSuccess) {
            context
                .read<FetchConsignmentsCubit>()
                .updateConsignment(state.result);
            setState(() {});
            setSnackbar(
                getTranslated(context, 'PARCEL_STATUS_UPDATE_SUCCESSFULLY')!,
                context);
          }
          if (state is UpdateConsignmentStatusFail) {
            setSnackbar(state.error.toString(), context);
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ConsignmentCard(
                  consignment: widget.consignment,
                ),
                const SizedBox(
                  height: 14,
                ),
                CardWithTitleDivider(
                    title: 'Order Overview'.translate(context),
                    child: Column(
                      children: [
                        buildDetailRow('parcel_id'.translate(context),
                            widget.consignment.id),
                        buildDetailRow('parcel_date'.translate(context),
                            widget.consignment.createdDate),
                        buildDetailRow('PAYMENT_MTHD'.translate(context),
                            widget.consignment.paymentMethod),
                        buildDetailRow(
                            'preferred_delivery_date'.translate(context),
                            widget.consignment.deliveryDate),
                        buildDetailRow(
                            'preferred_delivery_time'.translate(context),
                            widget.consignment.deliveryTime),
                        if (widget.consignment.trackingDetails != null &&
                            widget
                                .consignment.isShiprocketOrderCreatedBool) ...[
                          buildDetailRow(
                              'shiprocket_order_id'.translate(context),
                              widget.consignment.trackingDetails!
                                      .shiprocketOrderId ??
                                  ''),
                          buildDetailRow(
                              'shiprocket_tracking_id'.translate(context),
                              widget.consignment.trackingDetails!.trackingId ??
                                  ''),
                        ],
                      ],
                    )),
                const SizedBox(
                  height: 14,
                ),
                CardWithTitleDivider(
                    title: 'SHIPPING_DETAIL'.translate(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.consignment.username.firstUpperCase())
                            .bold(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(widget.consignment.userAddress),
                        ),
                        Text(
                            '${"phone_number".translate(context)}: ${widget.consignment.mobile}'),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                if (widget.consignment.isShiprocketOrderCreatedBool) ...[
                  if ((widget.consignment.trackingDetails!.awbCode == "" ||
                          widget.consignment.trackingDetails!.awbCode ==
                              null) &&
                      widget.consignment.activeStatus
                              .toString()
                              .toLowerCase() !=
                          'canceled')
                    BlocConsumer<GenerateAWBCubit, GenerateAWBState>(
                      listener: (context, state) {
                        if (state is GenerateAWBSuccess) {
                          context
                              .read<FetchConsignmentsCubit>()
                              .updateConsignment(state.result);
                          setState(() {});
                          setSnackbar(
                            'SEND_SUCCESS'.translate(context),
                            context,
                            backgroundColor: Colors.green,
                          );
                        }

                        if (state is GenerateAWBFailure) {
                          setSnackbar(
                            state.errorMessage,
                            context,
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        print("sendPickUpRequeststate------>${state}");

                        // Only handle UI rendering logic here
                        return Column(
                          children: [
                            Card(
                              elevation: 0,
                              child: InkWell(
                                child: ListTile(
                                  dense: true,
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: primary,
                                  ),
                                  leading: const Icon(
                                    Icons.sim_card_download_outlined,
                                    color: primary,
                                  ),
                                  title: Text(
                                    'GENERATE_AWB'.translate(context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: black),
                                  ),
                                ),
                                onTap: () async {
                                  context.read<GenerateAWBCubit>().generateAWB(
                                        shipmentId: widget.consignment
                                            .trackingDetails!.shipmentId!,
                                      );
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
                  if (widget.consignment.trackingDetails!.pickupScheduledDate ==
                          "" &&
                      (widget.consignment.activeStatus
                                  .toString()
                                  .toLowerCase() !=
                              'canceled' ||
                          widget.consignment.activeStatus
                                  .toString()
                                  .toLowerCase() !=
                              'pickup scheduled' ||
                          widget.consignment.activeStatus
                                  .toString()
                                  .toLowerCase() !=
                              'cancellation requested'))
                    BlocConsumer<SendPickUpRequestCubit,
                        SendPickUpRequestState>(
                      listener: (context, state) {
                        if (state is SendPickUpRequestSuccess) {
                          context
                              .read<FetchConsignmentsCubit>()
                              .updateConsignment(state.result);
                          setState(() {});

                          setSnackbar(
                            'SEND_SUCCESS'.translate(context),
                            context,
                            backgroundColor: Colors.green,
                          );
                          //Navigator.pop(
                          //    context); // Close dialog or screen after success
                        }

                        if (state is SendPickUpRequestFailure) {
                          setSnackbar(
                            state.errorMessage,
                            context,
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      builder: (context, state) {
                        print("sendPickUpRequeststate------>${state}");

                        // Only handle UI rendering logic here
                        return Column(
                          children: [
                            Card(
                              elevation: 0,
                              child: InkWell(
                                child: ListTile(
                                  dense: true,
                                  leading: const Icon(
                                    Icons.send_sharp,
                                    color: primary,
                                  ),
                                  title: Text(
                                    'SENDPICKUPREQUEST'.translate(context),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: black),
                                  ),
                                ),
                                onTap: () async {
                                  context
                                      .read<SendPickUpRequestCubit>()
                                      .sendRequest(
                                        shipmentId: widget.consignment
                                            .trackingDetails!.shipmentId!,
                                      );

                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
                  if (widget.consignment.trackingDetails!.labelUrl != "")
                    BlocConsumer<FetchConsignmentLabelCubit,
                        FetchConsignmentLabelState>(
                      listener: (context, state) async {
                        if (state is FetchConsignmentLabelFailure) {
                          setSnackbar(state.error, context);
                        }
                        if (state is FetchConsignmentLabelSuccess) {
                          // Use the response directly as PDF URL
                          String pdfUrl = state.consignmentLabel;

                          if (pdfUrl.trim().isNotEmpty) {
                            bool hasPermission = await checkPermission();

                            // Set target directory based on platform and permission
                            String target = Platform.isAndroid && hasPermission
                                ? (await ExternalPath
                                    .getExternalStoragePublicDirectory(
                                    ExternalPath.DIRECTORY_DOWNLOADS,
                                  ))
                                : (await getApplicationDocumentsDirectory())
                                    .path;

                            var targetFileName =
                                'Label_${widget.consignment.name}.pdf';
                            var filePath = '$target/$targetFileName';

                            try {
                              var response = await http.get(Uri.parse(pdfUrl));
                              if (response.statusCode == 200) {
                                File file = File(filePath);
                                await file.writeAsBytes(response.bodyBytes);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${getTranslated(context, 'LABEL_PATH')} $targetFileName",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: black),
                                    ),
                                    action: SnackBarAction(
                                      label: getTranslated(context, 'VIEW')!,
                                      textColor: black,
                                      onPressed: () async {
                                        await OpenFilex.open(filePath);
                                      },
                                    ),
                                    backgroundColor: white,
                                    elevation: 1.0,
                                  ),
                                );
                              } else {
                                setSnackbar(
                                    getTranslated(context, 'somethingMSg')!,
                                    context);
                              }
                            } catch (e) {
                              setSnackbar(
                                  getTranslated(context, 'somethingMSg')!,
                                  context);
                              return;
                            }
                          } else {
                            setSnackbar(getTranslated(context, 'somethingMSg')!,
                                context);
                          }
                        }
                      },
                      builder: (context, state) {
                        return Card(
                          elevation: 0,
                          child: InkWell(
                            child: ListTile(
                              dense: true,
                              trailing: const Icon(
                                Icons.keyboard_arrow_right,
                                color: primary,
                              ),
                              leading: const Icon(
                                Icons.receipt,
                                color: primary,
                              ),
                              title: Text(
                                'Download Label'.translate(context),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: black),
                              ),
                            ),
                            onTap: () async {
                              context
                                  .read<FetchConsignmentLabelCubit>()
                                  .fetchConsignmentLabel(widget.consignment
                                      .trackingDetails!.shipmentId!);
                            },
                          ),
                        );
                      },
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
                BlocConsumer<FetchConsignmentInvoiceCubit,
                    FetchConsignmentInvoiceState>(
                  listener: (context, state) async {
                    if (state is FetchConsignmentInvoiceFailure) {
                      setSnackbar(state.error, context);
                    }
                    if (state is FetchConsignmentInvoiceSuccess) {
                      String invoiceHtml = state.consignmentInvoice;
                      if (invoiceHtml.trim().isNotEmpty) {
                        bool hasPermission = await checkPermission();

                        String target = Platform.isAndroid && hasPermission
                            ? (await ExternalPath
                                .getExternalStoragePublicDirectory(
                                ExternalPath.DIRECTORY_DOWNLOADS,
                              ))
                            : (await getApplicationDocumentsDirectory()).path;

                        var targetFileName =
                            'Invoice_${widget.consignment.name}';
                        var generatedPdfFile, filePath;
                        try {
                          generatedPdfFile =
                              await FlutterHtmlToPdf.convertFromHtmlContent(
                                  invoiceHtml, target, targetFileName);
                          filePath = generatedPdfFile.path;
                        } catch (e) {
                          setSnackbar(
                              getTranslated(context, 'somethingMSg')!, context);
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${getTranslated(context, 'INVOICE_PATH')} $targetFileName",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: black),
                            ),
                            action: SnackBarAction(
                              label: getTranslated(context, 'VIEW')!,
                              textColor: black,
                              onPressed: () async {
                                await OpenFilex.open(filePath);
                              },
                            ),
                            backgroundColor: white,
                            elevation: 1.0,
                          ),
                        );
                      } else {
                        setSnackbar(
                            getTranslated(context, 'somethingMSg')!, context);
                      }
                    }
                  },
                  builder: (context, state) {
                    return Card(
                      elevation: 0,
                      child: InkWell(
                        child: ListTile(
                          dense: true,
                          trailing: const Icon(
                            Icons.keyboard_arrow_right,
                            color: primary,
                          ),
                          leading: const Icon(
                            Icons.receipt,
                            color: primary,
                          ),
                          title: Text(
                            'Download Invoice'.translate(context),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: black),
                          ),
                        ),
                        onTap: () async {
                          context
                              .read<FetchConsignmentInvoiceCubit>()
                              .fetchConsignmentInvoice(widget.consignment.id);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CardWithTitleDivider(
                    title: 'PRICE_DETAIL'.translate(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDetailRow(
                            'price'.translate(context),
                            DesignConfiguration.getPriceFormat(
                                context, widget.consignment.total.toDouble())!),
                        buildDetailRow(
                            'delivery_charge'.translate(context),
                            DesignConfiguration.getPriceFormat(context,
                                widget.consignment.deliveryCharge.toDouble())!),
                        buildDetailRow(
                            'promocd'.translate(context),
                            DesignConfiguration.getPriceFormat(context,
                                widget.consignment.promoDiscount.toDouble())!),
                        buildDetailRow(
                            'wallet_balance'.translate(context),
                            DesignConfiguration.getPriceFormat(context,
                                widget.consignment.walletBalance.toDouble())!),
                        const Divider(
                          height: 0,
                          indent: 0,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('total'.translate(context)).size(16),
                            Text(DesignConfiguration.getPriceFormat(
                                    context,
                                    widget.consignment.totalPayable
                                        .toDouble())!)
                                .size(16),
                          ],
                        )
                      ],
                    )),
                const SizedBox(
                  height: 55, //for floating action button
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomDropdownCard({
    required String title,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onTap.call();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: Text(title).setMaxLines(lines: 1).centerAlign()),
            SvgPicture.asset(DesignConfiguration.setNewSvgPath('down_arrow')),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }

  showPopUpViewForOTP() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(getTranslated(context, 'ENTEROTP')!),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value!.isEmpty || value.length != 6) {
                  return getTranslated(context, 'OTPERROR')!;
                } else {
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              decoration: InputDecoration(
                hintText: getTranslated(context, 'ENTEROTP')!,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  selectedOrderStatus = OrderStatus.delivered;
                } else {
                  selectedOrderStatus = null;
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget buildVerticalDivider() {
    return Container(
      width: 2,
      height: 32,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: lightWhite,
    );
  }
}
