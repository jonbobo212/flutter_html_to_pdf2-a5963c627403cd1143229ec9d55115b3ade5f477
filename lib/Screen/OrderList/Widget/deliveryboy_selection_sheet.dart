import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Helper/extensions/lib/controller.dart';
import 'package:sellermultivendor/Model/delivery_boy_model.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/cubits/deliveryboy/fetch_deliveryboy_cubit.dart';

class DeliveryboySelectionSheet extends StatefulWidget {
  const DeliveryboySelectionSheet({super.key});

  @override
  State<DeliveryboySelectionSheet> createState() =>
      _DeliveryboySelectionSheetState();
}

class _DeliveryboySelectionSheetState extends State<DeliveryboySelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController = ScrollController()
    ..pageEndListener(
      () {
        context.read<FetchDeliveryboyCubit>().fetchMore();
      },
    );
  @override
  void initState() {
    context.read<FetchDeliveryboyCubit>().fetch();
    _searchController.searchListener((text) {
      context.read<FetchDeliveryboyCubit>().fetch(search: text);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('select_delivery_boy'.translate(context)).size(20),
                const CloseButton()
              ],
            ),
          ),
          const Divider(
            height: 0,
            indent: 0,
            thickness: 2,
          ),
          buildSearchField(),
          BlocBuilder<FetchDeliveryboyCubit, FetchDeliveryboyState>(
            builder: (context, state) {
              if (state is FetchDeliveryboyInProgress) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: CircularProgressIndicator(
                      color: primary,
                    ),
                  ),
                );
              }
              if (state is FetchDeliveryboyFail) {
                return Center(child: Text(state.e.toString()));
              }
              if (state is FetchDeliveryboySuccess) {
                if (state.result.deliveryBoys.isEmpty) {
                  return Center(child: Text("NO_DEL_BODY".translate(context)));
                }
                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: state.result.deliveryBoys.length,
                          itemBuilder: (context, index) {
                            DeliveryBoy deliveryBoy =
                                state.result.deliveryBoys[index];
                            return ListTile(
                              title: Text(deliveryBoy.name),
                              onTap: () {
                                Navigator.pop(context, deliveryBoy);
                              },
                            );
                          },
                        ),
                      ),
                      if (state.isLoadingMore)
                        DesignConfiguration.showCircularProgress(true, primary)
                    ],
                  ),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  Widget buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
            hintText: 'search_delivery_boy'.translate(context),
            filled: true,
            fillColor: lightWhite,
            isDense: true,
            prefixIcon: const Icon(
              Icons.search,
              color: black,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none)),
      ),
    );
  }
}
