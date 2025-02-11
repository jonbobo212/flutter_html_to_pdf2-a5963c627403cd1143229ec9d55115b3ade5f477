import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Model/getWithdrawelRequest/getWithdrawelmodel.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/validation.dart';

class ListIteamsWidget extends StatelessWidget {
  final int index;
  final List<GetWithdrawelReq> tranList;
  const ListIteamsWidget({
    Key? key,
    required this.index,
    required this.tranList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color back;
    if (tranList[index].status == "success" ||
        tranList[index].status == ACCEPTEd) {
      back = Colors.green;
    } else if (tranList[index].status == PENDINg) {
      back = Colors.orange;
    } else {
      back = red;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          boxShadow: [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: white,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${getTranslated(context, "ID_LBL")!} : ${tranList[index].id!}",
                      style: const TextStyle(
                          color: black, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: back,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(circularBorderRadius5),
                        ),
                      ),
                      child: Text(
                        StringValidation.capitalize(tranList[index].status!),
                        style: const TextStyle(color: white),
                      ),
                    )
                    // Text(tranList[index].dateCreated!),
                  ],
                ),
                const Divider(),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Text(
                    //   "${getTranslated(context, "ID_LBL")!} : ${tranList[index].id!}",
                    // ),
                    Spacer(),
                  ],
                ),
                tranList[index].paymentAddress != null &&
                        tranList[index].paymentAddress!.isNotEmpty
                    ? Text(
                        "${getTranslated(context, "Date")!} : ${tranList[index].dateCreated!}")
                    : Container(),
                tranList[index].paymentAddress != null &&
                        tranList[index].paymentAddress!.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "${getTranslated(context, "PaymentAddress")!} : "),
                          Container(
                            child: Wrap(children: [
                              Text("${tranList[index].paymentAddress!}.")
                            ]),
                          )
                        ],
                      )
                    : Container(),
                tranList[index].paymentType != null &&
                        tranList[index].paymentType!.isNotEmpty
                    ? Text(
                        "${getTranslated(context, "PaymentType")!} : ${tranList[index].paymentType!}")
                    : Container(),
                tranList[index].remarks != null
                    ? Text(
                        "${getTranslated(context, 'Remark')} : ${tranList[index].remarks}",
                      )
                    : Container(),
                const Divider(),
                // GetRowFields(
                //   title: "${getTranslated(context, "AMT_LBL")} - ",
                //   value: tranList[index].amountRequested!,
                //   simple: false,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${getTranslated(context, "AMT_LBL")}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DesignConfiguration.getPriceFormat(
                        context,
                        double.parse(tranList[index].amountRequested!),
                      )!,
                      style: const TextStyle(
                          color: primary, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
