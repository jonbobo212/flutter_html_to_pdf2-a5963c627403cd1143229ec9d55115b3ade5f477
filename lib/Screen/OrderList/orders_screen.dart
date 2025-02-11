import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Helper/extensions/lib/controller.dart';
import 'package:sellermultivendor/Model/order/order_filter_model.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/order_card.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/order_list_filter_bottomsheet.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/order_staus_with_list.dart';
import 'package:sellermultivendor/Widget/errorContainer.dart';
import 'package:sellermultivendor/Widget/validation.dart';
import 'package:sellermultivendor/cubits/order/fetch_orders_cubit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //to store old state counts
  FetchOrdersSuccess? successState;
  OrderStatus currentOrderStatus = OrderStatus.orders;
  final ScrollController _pageScrollController = ScrollController();

  //order filtering values
  final OrderListFilterModel _orderListFilters = OrderListFilterModel();
  bool isSearchFieldVisible = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _fetchOrders();
    });

    _pageScrollController.pageEndListener(() {
      _fetchOrders(isScrollTriggered: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageScrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetchOrders({bool isScrollTriggered = false}) {
    context.read<FetchOrdersCubit>().fetch(
          searchString: _searchController.text.trim().isEmpty
              ? null
              : _searchController.text,
          dateRange: _orderListFilters.dateRange,
          orderType: _orderListFilters.orderType.apiValue,
          activeStatus: currentOrderStatus.apiValue,
          isScrollTriggered: isScrollTriggered,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightWhite,
      appBar: PreferredSize(
        preferredSize: const Size(double.maxFinite, 50),
        child: Container(
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
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (isSearchFieldVisible) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 12, end: 4, top: 4, bottom: 4),
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(fontSize: 14),
                              hintText: getTranslated(context, 'SEARCH'),
                              fillColor: lightWhite,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  isSearchFieldVisible = false;
                                  _debounce?.cancel();
                                  _searchController.text = "";
                                  setState(() {});
                                  _fetchOrders();
                                },
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false)
                                _debounce?.cancel();
                              _debounce =
                                  Timer(const Duration(milliseconds: 500), () {
                                if (_searchController.text.trim().isNotEmpty) {
                                  _fetchOrders();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showOrderListFilterBottomSheet(
                                  context, _orderListFilters)
                              .then((value) {
                            if (value == true) {
                              setState(() {});
                              _fetchOrders();
                            }
                          });
                        },
                        icon: Icon(
                          _orderListFilters.hasAnyFilters()
                              ? Icons.filter_alt
                              : Icons.filter_alt_outlined,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      getTranslated(context, 'ORDERS')!,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: white,
                        fontSize: textFontSize20,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            isSearchFieldVisible = true;
                            _debounce?.cancel();
                            _searchController.text = "";
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.search,
                            color: white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showOrderListFilterBottomSheet(
                                    context, _orderListFilters)
                                .then((value) {
                              if (value == true) {
                                setState(() {});
                                _fetchOrders();
                              }
                            });
                          },
                          icon: Icon(
                            _orderListFilters.hasAnyFilters()
                                ? Icons.filter_alt
                                : Icons.filter_alt_outlined,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          _fetchOrders();
          return Future.value();
        },
        child: SizedBox(
          height: double.maxFinite,
          child: SingleChildScrollView(
            controller: _pageScrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<FetchOrdersCubit, FetchOrdersState>(
                  builder: (context, state) {
                    if (state is FetchOrdersSuccess) {
                      successState = state;
                    }
                    return SizedBox(
                      height: 94,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: successState?.result.statusData.length ??
                            OrderStatus.values.length,
                        padding: const EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 12,
                          );
                        },
                        itemBuilder: (context, index) {
                          Map<OrderStatus, String> status =
                              successState?.result.statusData[index] ??
                                  {OrderStatus.values[index]: "0"};
                          return OrderStatusCardWithCount(
                            title: status.keys.first.name,
                            count: status.values.first,
                            assetPath: status.keys.first.assetIconSvgPath,
                            onTap: () {
                              if (currentOrderStatus != status.keys.first) {
                                currentOrderStatus = status.keys.first;
                                _fetchOrders();
                                setState(() {});
                              }
                            },
                            isSelected: currentOrderStatus == status.keys.first,
                          );
                        },
                      ),
                    );
                  },
                ),
                BlocBuilder<FetchOrdersCubit, FetchOrdersState>(
                  builder: (context, state) {
                    if (state is FetchOrdersInProgress) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: CircularProgressIndicator(
                            color: primary,
                          ),
                        ),
                      );
                    }

                    if (state is FetchOrdersFail) {
                      return ErrorContainer(
                          onTapRetry: () {},
                          errorMessage: 'somethingMSg'.translate(context));
                    }
                    if (state is FetchOrdersSuccess) {
                      if (state.result.orders.isEmpty) {
                        return Center(
                          child: Text('No Data Found'.translate(context)),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                                bottom: 12, left: 12, right: 12),
                            itemCount: state.result.orders.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            itemBuilder: (context, index) {
                              OrderModel order = state.result.orders[index];
                              return OrderCard(
                                order: order,
                              );
                            },
                          ),
                          if (state.loadingMore) ...[
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: CircularProgressIndicator(
                                  color: primary,
                                ),
                              ),
                            ),
                          ] else if (state.loadingMoreError) ...[
                            Center(
                                child: Text('somethingMSg'.translate(context))),
                          ]
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
