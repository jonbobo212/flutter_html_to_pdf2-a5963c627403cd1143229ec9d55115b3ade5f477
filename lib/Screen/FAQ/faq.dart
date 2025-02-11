import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Screen/FAQ/widget/getFaQIteams.dart';
import 'package:sellermultivendor/Widget/ButtonDesing.dart';
import 'package:sellermultivendor/Widget/bottomsheet.dart';
import '../../Helper/Color.dart';
import '../../Provider/faqProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Model/FAQModel/Faqs_Model.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/validation.dart';

class AddFAQs extends StatefulWidget {
  final String? id;
  final Product? model;
  const AddFAQs(this.id, this.model, {Key? key}) : super(key: key);
  @override
  _AddFAQsState createState() => _AddFAQsState();
}

FaQProvider? faqProvider;

class _AddFAQsState extends State<AddFAQs> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    faqProvider = Provider.of<FaQProvider>(context, listen: false);
    faqProvider!.initializevariableValues();

    faqProvider!.scrollOffset = 0;
    faqProvider!.getFaQs(context, setStateNow, widget.id!);

    faqProvider!.buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    faqProvider!.scrollController = ScrollController(keepScrollOffset: true);
    faqProvider!.scrollController!.addListener(_transactionscrollListener);

    faqProvider!.buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: faqProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  _transactionscrollListener() {
    if (faqProvider!.scrollController!.offset >=
            faqProvider!.scrollController!.position.maxScrollExtent &&
        !faqProvider!.scrollController!.position.outOfRange) {
      if (mounted) {
        setState(
          () {
            faqProvider!.scrollLoadmore = true;
            faqProvider!.getFaQs(context, setStateNow, widget.id!);
          },
        );
      }
    }
  }

  newQuestionButtomSheet() async {
    await CustomBottomSheet.showBottomSheet(
      context: context,
      enableDrag: true,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              Center(child: CustomBottomSheet.bottomSheetHandle(context)),
              CustomBottomSheet.bottomSheetLabel(
                context,
                getTranslated(context, 'Add Question')!,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 42,
                      child: TextFormField(
                        onFieldSubmitted: (v) {
                          FocusScope.of(context)
                              .requestFocus(faqProvider!.tagsController);
                        },
                        controller: faqProvider!.mobilenumberController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Question",
                          labelStyle: TextStyle(
                            color: black,
                            fontSize: 17.0,
                          ),
                          hintStyle: TextStyle(
                            color: grey3,
                            fontWeight: FontWeight.w400,
                            fontFamily: "PlusJakartaSans",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        focusNode: faqProvider!.tagsController,
                        onSaved: (String? value) {
                          faqProvider!.tagvalue = value;
                        },
                        onChanged: (String? value) {
                          faqProvider!.tagvalue = value;
                        },
                        style: const TextStyle(
                          color: black,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(faqProvider!.ansFocus);
                      },
                      controller: faqProvider!.answerController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: getTranslated(
                            context, "Enter Your Answer (Optional)")!,
                        labelStyle: const TextStyle(
                          color: black,
                          fontSize: 17.0,
                        ),
                        hintStyle: const TextStyle(
                          color: grey3,
                          fontWeight: FontWeight.w400,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      focusNode: faqProvider!.ansFocus,
                      onSaved: (String? value) {
                        faqProvider!.ansValue = value;
                      },
                      onChanged: (String? value) {
                        faqProvider!.ansValue = value;
                      },
                      style: const TextStyle(
                        color: black,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: AppBtn(
                            width: MediaQuery.of(context).size.width / 2.2,
                            title: getTranslated(context, "CANCEL")!,
                            btnAnim: faqProvider!.buttonSqueezeanimation,
                            btnCntrl: faqProvider!.buttonController,
                            color: white,
                            textcolor: black,
                            onBtnSelected: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        AppBtn(
                            width: MediaQuery.of(context).size.width / 2.2,
                            title: getTranslated(context, "SEND_LBL")!,
                            btnAnim: faqProvider!.buttonSqueezeanimation,
                            btnCntrl: faqProvider!.buttonController,
                            onBtnSelected: () async {
                              if (faqProvider!.tagvalue != '' &&
                                  faqProvider!.tagvalue != null) {
                                faqProvider!.tagList.clear();
                                faqProvider!.scrollLoadmore = true;

                                faqProvider!.addTagAPI(
                                    context, widget.id!, setStateNow);
                                Navigator.pop(context);
                                Future.delayed(const Duration(seconds: 2)).then(
                                  (_) async {
                                    faqProvider!.scrollLoadmore = true;
                                    faqProvider!.scrollOffset = 0;
                                    faqProvider!.getFaQs(
                                      context,
                                      setStateNow,
                                      widget.id!,
                                    );
                                    setStateNow();
                                    Navigator.pop(context);
                                  },
                                );
                              }
                            })
                      ],
                    ),
                    Platform.isIOS
                        ? const Padding(padding: EdgeInsets.only(bottom: 30))
                        : const Padding(padding: EdgeInsets.zero)
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  oldQuestionButtomSheet(
    BuildContext context,
    String question,
    String? answer,
    String id,
    int index,
  ) async {
    await CustomBottomSheet.showBottomSheet(
      context: context,
      enableDrag: true,
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        return Wrap(
          children: [
            Center(child: CustomBottomSheet.bottomSheetHandle(context)),
            CustomBottomSheet.bottomSheetLabel(
              context,
              getTranslated(context, "Edit Answer")!,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.w400,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: faqProvider!.listController[index],
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                      color: black,
                      fontSize: 18.0,
                    ),
                    onChanged: (String? value) {},
                    textInputAction: TextInputAction.next,
                    validator: (val) =>
                        StringValidation.validateMob(val!, context),
                    onSaved: (String? value) {},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: faqProvider!.tagList[index].answer!.isNotEmpty
                          ? getTranslated(context, "Edit Your Answer")
                          : getTranslated(context, "Enter Your Answer"),
                      labelStyle: const TextStyle(
                        color: black,
                        fontSize: 17.0,
                      ),
                      hintStyle: const TextStyle(
                        color: grey3,
                        fontWeight: FontWeight.w400,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: AppBtn(
                          width: MediaQuery.of(context).size.width / 2.2,
                          title: getTranslated(context, "CANCEL")!,
                          btnAnim: faqProvider!.buttonSqueezeanimation,
                          btnCntrl: faqProvider!.buttonController,
                          color: white,
                          textcolor: black,
                          onBtnSelected: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      AppBtn(
                          width: MediaQuery.of(context).size.width / 2.2,
                          title: getTranslated(context, 'Submit')!,
                          btnAnim: faqProvider!.buttonSqueezeanimation,
                          btnCntrl: faqProvider!.buttonController,
                          onBtnSelected: () async {
                            if (faqProvider!
                                .listController[index].text.isEmpty) {
                              setSnackbar(
                                  getTranslated(
                                      context, "Please Add Your Answer")!,
                                  context);
                            } else {
                              faqProvider!.editProductFaqAPI(
                                faqProvider!.tagList[index].id,
                                faqProvider!.listController[index].text,
                                context,
                              );
                              faqProvider!.tagList.clear();
                              faqProvider!.scrollLoadmore = true;
                              Future.delayed(const Duration(seconds: 2)).then(
                                (_) async {
                                  faqProvider!.scrollLoadmore = true;
                                  faqProvider!.scrollOffset = 0;
                                  faqProvider!.getFaQs(
                                      context, setStateNow, widget.id!);
                                  setStateNow();
                                },
                              );
                              Navigator.pop(context);
                            }
                          })
                    ],
                  ),
                  Platform.isIOS
                      ? const Padding(padding: EdgeInsets.only(bottom: 30))
                      : const Padding(padding: EdgeInsets.zero)
                ],
              ),
            ),
          ],
        );
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: lightWhite,
      appBar: GradientAppBar(
        widget.model!.name ?? "",
      ),
      floatingActionButton: SizedBox(
        height: 40.0,
        width: 40.0,
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: newPrimary,
            child: const Icon(
              Icons.add,
              size: 32,
              color: white,
            ),
            onPressed: () {
              newQuestionButtomSheet();
            },
          ),
        ),
      ),
      body: isNetworkAvail
          ? _showContent()
          : noInternet(
              context,
              setStateNoInternate,
              faqProvider!.buttonSqueezeanimation,
              faqProvider!.buttonController),
    );
  }

  _showContent() {
    return faqProvider!.scrollNodata
        ? Column(
            children: [
              // GradientAppBar(
              //   widget.model!.name ?? "",
              // ),
              SizedBox(
                height: height * 0.8,
                child: DesignConfiguration.getNoItem(context),
              ),
            ],
          )
        : NotificationListener<ScrollNotification>(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GradientAppBar(
                //   widget.model!.name ?? "",
                // ),
                faqProvider!.scrollGettingData
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          right: 15.0,
                          left: 15.0,
                        ),
                        child: Text(getTranslated(context, 'Questions')!,
                            style: const TextStyle(
                              color: black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "PlusJakartaSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.left),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      controller: faqProvider!.scrollController,
                      shrinkWrap: true,
                      itemCount: faqProvider!.tagList.length,
                      itemBuilder: (innercontext, index) {
                        FaqsModel? item;

                        item = faqProvider!.tagList.isEmpty
                            ? null
                            : faqProvider!.tagList[index];

                        return item == null
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  oldQuestionButtomSheet(
                                    context,
                                    faqProvider!.tagList[index].question!,
                                    faqProvider!.tagList[index].answer,
                                    // faqProvider!.tagList[index].id!,
                                    widget.id!,
                                    index,
                                  );
                                },
                                child: GetMediaWidget(
                                    index: index,
                                    id: widget.id!,
                                    update: setStateNow,
                                    parentContext: context),
                              );
                      },
                    ),
                  ),
                ),
                faqProvider!.scrollGettingData
                    ? const Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: 5,
                          bottom: 5,
                        ),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container(),
              ],
            ),
          );
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          ).then(
            (value) {
              setState(
                () {},
              );
            },
          );
        } else {
          await faqProvider!.buttonController!.reverse();
          if (mounted) {
            setState(
              () {},
            );
          }
        }
      },
    );
  }

  Future<void> _playAnimation() async {
    try {
      await faqProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }
}
