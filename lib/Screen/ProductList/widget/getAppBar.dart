import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/ProductList/ProductList.dart';
import 'package:sellermultivendor/Widget/validation.dart';

class GradientAppBar2 extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final BuildContext context;
  final Function update;
  final Widget widget;
  final bool fromNavbar;
  // final double barHeight = 80.0;
  final bool? customback;

  GradientAppBar2(
      this.title, this.context, this.update, this.fromNavbar, this.widget,
      {this.customback});

  @override
  State<GradientAppBar2> createState() => _GradientAppBar2State();

  @override
  Size get preferredSize => Size(width, 50);
}

class _GradientAppBar2State extends State<GradientAppBar2> {
  bool serachIsEnable = false;

  void _handleSearchEnd() {
    if (!mounted) return;
    setState(
      () {
        serachIsEnable = false;
        productListProvider!.controllerForText.clear();
      },
    );
  }

  void _handleSearchStart() {
    if (!mounted) return;
    setState(
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(circularBorderRadius10),
          bottomRight: Radius.circular(circularBorderRadius10),
        ),
        gradient: LinearGradient(
          colors: [grad1Color, grad2Color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.fromNavbar
                    ? Container()
                    : InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsetsDirectional.only(start: 15.0),
                          child: Icon(
                            Icons.arrow_back,
                            color: white,
                            size: 25,
                          ),
                        ),
                      ),
                Row(
                  children: [
                    serachIsEnable
                        ? Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 8.0),
                            child: SizedBox(
                              // height: 60,
                              width:
                                  widget.fromNavbar ? width * 0.7 : width * 0.5,
                              child: TextField(
                                controller:
                                    productListProvider!.controllerForText,
                                autofocus: true,
                                style: const TextStyle(
                                  color: white,
                                ),
                                decoration: InputDecoration(
                                  prefixIcon:
                                      const Icon(Icons.search, color: white),
                                  hintText: getTranslated(context, "Search"),
                                  hintStyle: const TextStyle(color: white),
                                  disabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: white,
                                    ),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 36,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                top: 9.0,
                                start: 60,
                                end: 15,
                              ),
                              child: Text(
                                getTranslated(context, 'PRODUCTS')!,
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: white,
                                  fontSize: textFontSize20,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (!mounted) return;
                        setState(
                          () {
                            if (serachIsEnable == false) {
                              serachIsEnable = true;
                              _handleSearchStart();
                            } else {
                              serachIsEnable = false;
                              _handleSearchEnd();
                            }
                          },
                        );
                        // Routes.navigateToSearch(context);
                      },
                      child: Icon(
                        serachIsEnable ? Icons.close : Icons.search,
                        color: white,
                        size: 25,
                      ),
                    ),
                    widget.widget
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
