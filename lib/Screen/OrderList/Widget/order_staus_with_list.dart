import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';

class OrderStatusCardWithCount extends StatelessWidget {
  final String title;
  final String count;
  final String assetPath;
  final bool isSelected;
  final Function() onTap;
  const OrderStatusCardWithCount(
      {super.key,
      required this.title,
      required this.count,
      required this.isSelected,
      required this.onTap,
      required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        height: 70,
        width: 165,
        decoration: BoxDecoration(
            color: isSelected ? primary : white,
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? white : primary.withOpacity(0.1),
                ),
                clipBehavior: Clip.antiAlias,
                child: SvgPicture.asset(
                  assetPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(count)
                      .size(context.font.large - 1)
                      .bold()
                      .color(isSelected ? white : null),
                  Text(title)
                      .firstUpperCaseWidget()
                      .color(isSelected ? white : null),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
