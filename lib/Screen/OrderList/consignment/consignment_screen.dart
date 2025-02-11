import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Helper/extensions/lib/controller.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/consignment_card.dart';
import 'package:sellermultivendor/Screen/OrderList/consignment/consignment_details.dart';
import 'package:sellermultivendor/Screen/OrderList/order_details_screen.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/Widget/errorContainer.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignment_invoice.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignment_label.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/update_consignment_status_cubit.dart';

GlobalKey<NavigatorState> consignmentNavigator = GlobalKey<NavigatorState>();

class ConsignmentScreen extends StatefulWidget {
  final OrderModel order;
  const ConsignmentScreen({super.key, required this.order});

  @override
  State<ConsignmentScreen> createState() => _ConsignmentScreenState();
}

class _ConsignmentScreenState extends State<ConsignmentScreen> {
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _scrollController.pageEndListener(() {
      context.read<FetchConsignmentsCubit>().fetchMore();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///Used this for nested navigation
    return Navigator(
      key: consignmentNavigator,
      initialRoute: '/consignment_main',
      onGenerateRoute: (settings) {
        if (settings.name == '/consignment_main') {
          return MaterialPageRoute(
              builder: (context) => buildConsignmentItemList());
        }
        if (settings.name == '/consignment_details') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => UpdateConsignmentStatusCubit(),
                ),
                BlocProvider(
                  create: (_) => FetchConsignmentInvoiceCubit(),
                ),
                BlocProvider(
                  create: (_) => FetchConsignmentLabelCubit(),
                ),
              ],
              child: ConsignmentDetails(
                consignment: (settings.arguments as Map)['consignment'],
                order: widget.order,
              ),
            ),
          );
        }
        return null;
      },
    );
  }

  Widget buildConsignmentItemList() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FetchConsignmentsCubit>().fetch(orderId: widget.order.id!);
      },
      child: BlocBuilder<FetchConsignmentsCubit, FetchConsignmentsState>(
        builder: (context, state) {
          if (state is FetchConsignmentsFail) {
            return Center(
              child: ErrorContainer(
                  onTapRetry: () {},
                  errorMessage: 'somethingMSg'.translate(context)),
            );
          }
          if (state is FetchConsignmentsInProgress) {
            return DesignConfiguration.showCircularProgress(true, primary);
          }
          if (state is FetchConsignmentsSuccess) {
            if (state.consignmentResult.consignments.isEmpty) {
              return Center(
                child: Text('No Data Found..!!'.translate(context)),
              );
            }

            return SizedBox(
              height: double.maxFinite,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(14),
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        ConsignmentModel consignmentModel =
                            state.consignmentResult.consignments[index];

                        return GestureDetector(
                          onTap: () {
                            showCreateParcelButton.value = false;
                            Navigator.pushNamed(
                                consignmentNavigator.currentContext!,
                                '/consignment_details',
                                arguments: {
                                  'consignment': consignmentModel,
                                });
                          },
                          child: ConsignmentCard(
                            consignment: consignmentModel,
                            showDeleteButton: true,
                          ),
                        );
                      },
                      itemCount: state.consignmentResult.consignments.length,
                    ),
                    if (state.isLoadingMore)
                      DesignConfiguration.showCircularProgress(true, primary)
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
