import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/order/create_shiprocket_order_cubit.dart';

Future<dynamic> showCreateShiprocketOrderBottomSheet(BuildContext context,
    {required CreateShiprocketOrderCubit cubit,
    required String pickupLocation,
    required String consignmentId}) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return CreateShiprocketOrderBottomsheetContainer(
          cubit: cubit,
          pickupLocation: pickupLocation,
          consignmentId: consignmentId);
    },
  );
}

class CreateShiprocketOrderBottomsheetContainer extends StatefulWidget {
  final CreateShiprocketOrderCubit cubit;
  final String pickupLocation;
  final String consignmentId;
  const CreateShiprocketOrderBottomsheetContainer(
      {super.key,
      required this.cubit,
      required this.pickupLocation,
      required this.consignmentId});

  @override
  State<CreateShiprocketOrderBottomsheetContainer> createState() =>
      _CreateShiprocketOrderBottomsheetContainerState();
}

class _CreateShiprocketOrderBottomsheetContainerState
    extends State<CreateShiprocketOrderBottomsheetContainer> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController breadthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    breadthController.dispose();
    lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.only(
            top: 8.0,
            left: 15.0,
            right: 15,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getTranslated(context, "CREATE_SHIPROCKET_ORDER")!,
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
                    "${getTranslated(context, 'PICKUP_LOCATION')!} : ${widget.pickupLocation}",
                    style: const TextStyle(color: black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    getTranslated(context,
                        'Note: Make your pickup location associated with the order is verified from Shiprocket Dashboard and then in admin panel . If it is not verified you will not be able to generate AWB later on.')!,
                    style: const TextStyle(color: black, fontSize: 10),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated(context, 'Weight (kg)')!,
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              controller: weightController,
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.normal,
                              ),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*')),
                                // FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return getTranslated(
                                      context, 'FIELD_REQUIRED');
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
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated(context, 'Height (cms)')!,
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              controller: heightController,
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.normal,
                              ),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*')),
                                // FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return getTranslated(
                                      context, 'FIELD_REQUIRED');
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated(context, 'Breadth (cms)')!,
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              controller: breadthController,
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.normal,
                              ),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*')),
                                // FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return getTranslated(
                                      context, 'FIELD_REQUIRED');
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
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getTranslated(context, 'Length (cms)')!,
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              controller: lengthController,
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.normal,
                              ),
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*')),
                                // FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return getTranslated(
                                      context, 'FIELD_REQUIRED');
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
              child: InkWell(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    widget.cubit.createShiprocketOrder(
                        consignmentId: widget.consignmentId,
                        selectPickUpLocation: widget.pickupLocation,
                        weight: weightController.text.toString(),
                        height: heightController.text.toString(),
                        breadth: breadthController.text.toString(),
                        length: lengthController.text.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    getTranslated(context, 'Submit')!,
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
    );
  }
}
