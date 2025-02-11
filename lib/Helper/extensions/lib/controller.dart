import 'dart:async';

import 'package:flutter/material.dart';

extension SCController on ScrollController {
  void pageEndListener(VoidCallback callBack) {
    addListener(() {
      if (offset >= position.maxScrollExtent) {
        callBack();
      }
    });
  }
}

extension OBS on TextEditingController {
  void searchListener(Function(String text) fn) {
    Timer? timer;
    addListener(() {
      if (timer?.isActive == true) timer?.cancel();

      timer = Timer(
        const Duration(milliseconds: 500),
        () {
          fn.call(text);
        },
      );
    });
  }
}
