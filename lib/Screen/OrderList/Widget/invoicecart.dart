import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        child: ListTile(
          dense: true,
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: primary,
          ),
          leading: const Icon(
            Icons.receipt,
            color: primary,
          ),
          title: Text(
            'Download Invoice'.translate(context),
            style:
                Theme.of(context).textTheme.titleSmall!.copyWith(color: black),
          ),
        ),
        onTap: () async {},
      ),
    );
  }
}
