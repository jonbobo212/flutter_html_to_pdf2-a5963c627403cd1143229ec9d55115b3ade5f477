import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/order/edit_order_tracking_details_cubit.dart';

Future<dynamic> showUpdateTrackingDetailsBottomsheet(
    BuildContext context, ConsignmentModel consignment) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return BlocProvider<EditOrderTrackingDetailsCubit>(
        create: (context) => EditOrderTrackingDetailsCubit(),
        child: UpdateTrackingDetailsBottomsheetContainer(
          consignment: consignment,
        ),
      );
    },
  );
}

class UpdateTrackingDetailsBottomsheetContainer extends StatefulWidget {
  final ConsignmentModel consignment;
  const UpdateTrackingDetailsBottomsheetContainer(
      {super.key, required this.consignment});

  @override
  State<UpdateTrackingDetailsBottomsheetContainer> createState() =>
      _UpdateTrackingDetailsBottomsheetContainerState();
}

class _UpdateTrackingDetailsBottomsheetContainerState
    extends State<UpdateTrackingDetailsBottomsheetContainer> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController courierAgencyAgencyController =
      TextEditingController();
  final TextEditingController trackingIdController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    courierAgencyAgencyController.text =
        widget.consignment.trackingDetails?.courierAgency ?? '';
    trackingIdController.text =
        widget.consignment.trackingDetails?.trackingId ?? '';
    urlController.text = widget.consignment.trackingDetails?.url ?? '';
    super.initState();
  }

  @override
  void dispose() {
    courierAgencyAgencyController.dispose();
    trackingIdController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditOrderTrackingDetailsCubit,
        EditOrderTrackingDetailsState>(
      listener: (context, state) {
        if (state is EditOrderTrackingDetailsSuccess) {
          widget.consignment.trackingDetails ??= TrackingDetails();
          widget.consignment.trackingDetails!.courierAgency =
              courierAgencyAgencyController.text;
          widget.consignment.trackingDetails!.trackingId =
              trackingIdController.text;
          widget.consignment.trackingDetails!.url = urlController.text;
          Navigator.of(context).pop();
        } else if (state is EditOrderTrackingDetailsFail) {
          setSnackbar(state.error, context);
        }
      },
      builder: (context, state) {
        return IgnorePointer(
          ignoring: state is EditOrderTrackingDetailsInProgress,
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 15.0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            getTranslated(context, 'TRACKING_DETAIL')!,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          getTranslated(context, 'COURIER_AGENCY')!,
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
                          keyboardType: TextInputType.text,
                          controller: courierAgencyAgencyController,
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.normal,
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return getTranslated(context, 'FIELD_REQUIRED');
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
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: red,
                              ),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: black,
                              ),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: grey2),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius8),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          getTranslated(context, 'TRACKING_ID')!,
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
                          keyboardType: TextInputType.text,
                          controller: trackingIdController,
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.normal,
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return getTranslated(context, 'FIELD_REQUIRED');
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
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: red,
                              ),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: black,
                              ),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: grey2),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius8),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          getTranslated(context, 'URL')!,
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
                          keyboardType: TextInputType.url,
                          controller: urlController,
                          style: const TextStyle(
                            color: black,
                            fontWeight: FontWeight.normal,
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return getTranslated(context, 'FIELD_REQUIRED');
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
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: red,
                              ),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: black,
                              ),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius7),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: grey2),
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius8),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              context
                                  .read<EditOrderTrackingDetailsCubit>()
                                  .editOrderTrackingDetails(
                                    consignmentId: widget.consignment.id,
                                    courierAgency:
                                        courierAgencyAgencyController.text,
                                    trackingId: trackingIdController.text,
                                    url: urlController.text,
                                  );
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: state is EditOrderTrackingDetailsInProgress
                                ? const EdgeInsets.symmetric(vertical: 2)
                                : const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: state is EditOrderTrackingDetailsInProgress
                                ? const CircularProgressIndicator(
                                    color: white,
                                  )
                                : Text(
                                    getTranslated(context, 'SAVE_LBL')!,
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
          ),
        );
      },
    );
  }
}
