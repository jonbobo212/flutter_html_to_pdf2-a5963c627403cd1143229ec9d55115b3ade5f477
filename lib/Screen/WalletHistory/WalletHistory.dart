import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Screen/Profile/Widget/commonfield.dart';
import 'package:sellermultivendor/Widget/bottomsheet.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import '../../Model/getWithdrawelRequest/getWithdrawelmodel.dart';
import '../../Provider/settingProvider.dart';
import '../../Provider/walletProvider.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Widget/api.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/routes.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';
import 'Widget/listIteam.dart';

String? validateField(String? value, BuildContext context) {
  if (value!.isEmpty) {
    return getTranslated(context, "FIELD_REQUIRED")!;
  } else {
    return null;
  }
}

class WalletHistory extends StatefulWidget {
  const WalletHistory({Key? key}) : super(key: key);

  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

bool isLoadingmore = true;
int offset = 0;
int total = 0;

class _WalletHistoryState extends State<WalletHistory>
    with TickerProviderStateMixin {
  TextEditingController amountController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? amount, msg;
  ScrollController controller = ScrollController();
  TextEditingController? amtC, acc_num, ifsc_code, acc_name, bankDetailC;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  List<GetWithdrawelReq> tempList = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) =>
        context.read<WalletTransactionProvider>().getUserTransaction(context));
    super.initState();
    getSallerBalance();
    controller.addListener(_scrollListener);
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    amtC = TextEditingController();
    acc_name = TextEditingController();
    ifsc_code = TextEditingController();
    acc_num = TextEditingController();
    bankDetailC = TextEditingController();
  }

  _scrollListener() async {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (mounted) {
        if (context.read<WalletTransactionProvider>().hasMoreData) {
          setState(
            () {
              isLoadingmore = true;
            },
          );
          await context
              .read<WalletTransactionProvider>()
              .getUserTransaction(context)
              .then(
            (value) {
              setState(
                () {
                  isLoadingmore = false;
                },
              );
            },
          );
        }
      }
    }
  }

  getSallerBalance() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);

      var parameter = {};
      apiBaseHelper.postAPICall(getSellerDetailsApi, parameter).then(
        (getdata) async {
          bool error = getdata["error"];

          if (!error) {
            var data = getdata["data"][0];
            CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
          }

          setState(() {});
        },
        onError: (error) {
          setSnackbar(
            error.toString(),
            context,
          );
          setState(() {});
        },
      );
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }
    return null;
  }

  getBalanceShower() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                " ${getTranslated(context, "CURBAL_LBL")!}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                  DesignConfiguration.getPriceFormat(
                      context, double.parse(CUR_BALANCE))!,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: black, fontWeight: FontWeight.bold)),
              SimBtn(
                size: 0.9,
                title: getTranslated(context, "WITHDRAW_MONEY")!,
                onBtnSelected: () {
                  _showBottomSheet();
                  // _showDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    Completer<void> completer = Completer<void>();
    await Future.delayed(const Duration(seconds: 3)).then(
      (onvalue) {
        completer.complete();
        offset = 0;
        context.read<WalletTransactionProvider>().transationListOffset = 0;
        total = 0;
        setState(
          () {},
        );
        Future.delayed(Duration.zero).then((value) => context
            .read<WalletTransactionProvider>()
            .getUserTransaction(context));
        getSallerBalance();
      },
    );
    return completer.future;
  }

  // send withdrawel request

  Future<void> sendRequest() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      var parameter = {
        Amount: amtC!.text.toString(),
        PaymentAddress:
            "${acc_num!.text.toString().trim()}\n${ifsc_code!.text.toString().trim()}\n${acc_name!.text.toString().trim()}",
      };

      apiBaseHelper.postAPICall(sendWithDrawalRequestApi, parameter).then(
        (getdata) {
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            setSnackbar(
              msg!,
              context,
            );
            setState(
              () {},
            );
            Future.delayed(Duration.zero).then((value) => context
                .read<WalletTransactionProvider>()
                .getUserTransaction(context));
            _refresh();
          } else {
            setSnackbar(
              msg!,
              context,
            );
          }
        },
      );
    } else {
      if (mounted) {
        setState(
          () {
            isNetworkAvail = false;
          },
        );
      }
    }
  }

  _showBottomSheet() async {
    await CustomBottomSheet.showBottomSheet(
      context: context,
      enableDrag: true,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 10,
                  right: 10),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Center(child: CustomBottomSheet.bottomSheetHandle(context)),
                    CustomBottomSheet.bottomSheetLabel(
                      context,
                      getTranslated(context, "SEND_REQUEST")!,
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            getTranslated(context, "WITHDRWAL_AMT")!,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(),
                          ),
                        ),
                        CommonField(
                          controller: amtC,
                          keyboardType: TextInputType.number,
                          labelText: getTranslated(context, "WITHDRWAL_AMT")!,
                          isObscureText: false,
                          validator: (val) =>
                              StringValidation.validateField(val, context),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          child: Text(
                            getTranslated(context, BANK_DETAIL)!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        CustomBottomSheet.bottomSheetText(
                            context, getTranslated(context, "Name")!),
                        CommonField(
                          controller: acc_name,
                          labelText: getTranslated(context, "Name"),
                          isObscureText: false,
                          validator: (value) => validateField(value, context),
                        ),
                        CustomBottomSheet.bottomSheetText(
                            context, getTranslated(context, "Account Number")!),
                        CommonField(
                          controller: acc_num,
                          labelText: getTranslated(context, "Account Number"),
                          isObscureText: false,
                          validator: (value) => validateField(value, context),
                        ),
                        CustomBottomSheet.bottomSheetText(
                            context, getTranslated(context, "IFSC Code")!),
                        CommonField(
                          controller: ifsc_code,
                          labelText: getTranslated(context, "IFSC Code"),
                          isObscureText: false,
                          validator: (value) => validateField(value, context),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: AppBtn(
                              width: MediaQuery.of(context).size.width / 2.3,
                              title: getTranslated(context, "CANCEL")!,
                              btnAnim: buttonSqueezeanimation,
                              btnCntrl: buttonController,
                              color: white,
                              textcolor: black,
                              onBtnSelected: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          AppBtn(
                            width: MediaQuery.of(context).size.width / 2.3,
                            title: getTranslated(context, "SEND_LBL")!,
                            btnAnim: buttonSqueezeanimation,
                            btnCntrl: buttonController,
                            onBtnSelected: () async {
                              final form = _formkey.currentState!;
                              if (form.validate()) {
                                form.save();

                                sendRequest();
                                Routes.pop(context);
                                context
                                    .read<WalletTransactionProvider>()
                                    .transationListOffset = 0;
                                offset = 0;
                                total = 0;
                                Future.delayed(Duration.zero).then(
                                  (value) => context
                                      .read<WalletTransactionProvider>()
                                      .getUserTransaction(context),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Platform.isIOS
                        ? const Padding(padding: EdgeInsets.only(bottom: 20))
                        : const Padding(padding: EdgeInsets.zero)
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const GradientAppBar(
        "Wallet History",
      ),
      backgroundColor: lightWhite,
      body: isNetworkAvail
          ? Consumer<WalletTransactionProvider>(
              builder: (context, value, child) {
                if (value.getCurrentStatus == WalletStatus.isSuccsess) {
                  return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: Column(
                      children: [
                        // const GradientAppBar(
                        //   "Wallet History",
                        // ),
                        getBalanceShower(),
                        value.userTransactions.isEmpty
                            ? Center(
                                child: Text(
                                  getTranslated(context, "noItem")!,
                                ),
                              )
                            : MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: Flexible(
                                  child: ListView.builder(
                                    controller: controller,
                                    shrinkWrap: true,
                                    itemCount: (offset < total)
                                        ? value.userTransactions.length + 1
                                        : value.userTransactions.length,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return (index ==
                                                  value.userTransactions
                                                      .length &&
                                              isLoadingmore)
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : ListIteamsWidget(
                                              index: index,
                                              tranList: value.userTransactions,
                                            );
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                } else if (value.getCurrentStatus == WalletStatus.isFailure) {
                  return const ShimmerEffect();
                }
                return const ShimmerEffect();
              },
            )
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Future.delayed(Duration.zero).then((value) => context
              .read<WalletTransactionProvider>()
              .getUserTransaction(context));
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }
}
