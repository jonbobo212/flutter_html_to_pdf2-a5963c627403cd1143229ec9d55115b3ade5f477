import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {required this.child,
      required this.title,
      super.key,
      this.action,
      this.actionWidget,
      this.titleSize,
      this.boldTitle,
      this.bottom,
      this.leading,
      this.showBackButton});
  final Widget child;
  final double? titleSize;
  final bool? showBackButton;
  final bool? boldTitle;
  final Widget? leading;
  final ({String? title, void Function() onTap})? action;
  final Widget? actionWidget;
  final ({
    String title,
    Widget widget,
  })? bottom;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.8),
            ),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  if (showBackButton == true)
                    BackButton(
                      onPressed: () {
                        // context.pop();
                      },
                    ),
                  if (leading != null) leading!,
                  Text(title).size(titleSize ?? context.font.large).bold(
                        weight: (boldTitle ?? false) ? null : FontWeight.normal,
                      ),
                  if (action != null && actionWidget == null) ...<Widget>[
                    const Spacer(),
                    TextButton(
                      onPressed: action!.onTap,
                      child: Text(action!.title!).color(context.color.tertiary),
                    ),
                  ],
                  if (actionWidget != null) ...<Widget>[
                    const Spacer(),
                    actionWidget!,
                  ],
                ],
              ),
            ],
          ),
        ),
        child,
        if (bottom != null)
          Container(
            decoration: BoxDecoration(
              color: context.color.primary,
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.8),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Text(bottom!.title).bold(),
                  const Spacer(),
                  bottom!.widget,
                ],
              ),
            ),
          ),
      ],
    );
  }
}
