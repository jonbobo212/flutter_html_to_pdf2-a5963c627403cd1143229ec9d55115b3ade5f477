import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';

class CardWithTitleDivider extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;
  const CardWithTitleDivider({
    required this.title,
    required this.child,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow
                        .ellipsis,
                  ).bold().size(context.font.large),
                ),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 0,
            indent: 0,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          )
        ],
      ),
    );
  }
}
