import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import '../Helper/Constant.dart';
import '../Provider/settingProvider.dart';
import 'appBar.dart';
import 'simmerEffect.dart';

class ProductDescription extends StatefulWidget {
  final String? description;
  final String title;

  const ProductDescription(this.description, this.title, {Key? key})
      : super(key: key);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  String result = '';
  bool isLoading = true;
  final HtmlEditorController controller = HtmlEditorController();

  @override
  void initState() {
    setValue();

    super.initState();
    setValueNow();
  }

  setValueNow() async {
    Future.delayed(
      Duration.zero,
      () {
        // controller.setText(widget.description!);
      },
    );
  }

  setValue() async {
    Future.delayed(
      const Duration(seconds: 4),
      () {
        setState(
          () {
            isLoading = false;
          },
        );
      },
    );

    Future.delayed(
      const Duration(seconds: 6),
      () {
        setState(
          () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.setText(widget.description!);
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) {
          controller.clearFocus(); // for close keybord
        }
      },
      child: Scaffold(
        appBar: getAppBar(
          title,
          context,
        ),
        backgroundColor: white,
        resizeToAvoidBottomInset: true,
        body: isLoading
            ? const ShimmerEffect()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HtmlEditor(
                      controller: controller,
                      htmlEditorOptions: HtmlEditorOptions(
                        autoAdjustHeight: true,
                        hint: getTranslated(context,
                            'Please Enter Product Description here...!')!,
                        shouldEnsureVisible: true,
                        adjustHeightForKeyboard: true,
                      ),
                      htmlToolbarOptions: HtmlToolbarOptions(
                        toolbarPosition: ToolbarPosition.aboveEditor,
                        toolbarType: ToolbarType.nativeScrollable,
                        //by default
                        defaultToolbarButtons: [
                          StyleButtons(),
                          FontSettingButtons(fontSizeUnit: true),
                          FontButtons(clearAll: false),
                          ColorButtons(),
                          ListButtons(listStyles: false),
                          ParagraphButtons(
                            textDirection: true,
                            lineHeight: true,
                            caseConverter: false,
                          ),
                        ],
                        gridViewHorizontalSpacing: 0,
                        gridViewVerticalSpacing: 0,
                        // dropdownBackgroundColor: white,
                        toolbarItemHeight: 30,
                        buttonColor: black,
                        buttonFocusColor: fontColor,
                        buttonBorderColor: fontColor,
                        buttonFillColor: secondary,
                        dropdownIconColor: black,
                        dropdownIconSize: 15,
                        textStyle: const TextStyle(
                          // fontSize: textFontSize16,
                          color: black,
                        ),
                        onDropdownChanged: (DropdownType type, dynamic changed,
                            Function(dynamic)? updateSelectedItem) {
                          return true;
                        },
                        mediaLinkInsertInterceptor:
                            (String url, InsertFileType type) {
                          return true;
                        },
                        mediaUploadInterceptor:
                            (PlatformFile file, InsertFileType type) async {
                          return true;
                        },
                      ),
                      otherOptions: OtherOptions(height: height * 0.7),
                      callbacks: Callbacks(
                        onBeforeCommand: (String? currentHtml) {},
                        onChangeContent: (String? changed) {
                          result = changed!;
                        },
                        onChangeCodeview: (String? changed) {
                          result = changed!;
                        },
                        onNavigationRequestMobile: (String url) {
                          return NavigationActionPolicy.ALLOW;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueGrey),
                              onPressed: () {
                                controller.clear();
                              },
                              child: Text(
                                getTranslated(context, "Clear")!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontSize14,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary),
                              onPressed: () async {
                                Navigator.of(context).pop(result);
                              },
                              child: Text(
                                getTranslated(context, "SAVE_LBL")!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: textFontSize14,
                                  color: white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
