import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final ScrollController _controller = ScrollController();
  String test = "";
  @override
  void initState() {
    super.initState();
    // context.read<OrderCubit>().trackOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Orders",
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
         actions: [
            IconButton(
              iconSize: 30,
              icon: const Icon(Icons.search),
              onPressed: () {
                _openSearchModal(context);
              },
            ),]
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocConsumer<OrderCubit, OrderState>(
            listener: (context, state) {
              if (state is TrackOrderError) {
                ServerErrorHandler.showError(
                  status: state.status,
                  context: context,
                  message: state.errorMessage,
                  retry: () {
                    context.read<OrderCubit>().trackOrder();
                  },
                );
              }
            },
            builder: (context, state) {
              if (state is TrackOrderError) {
                return const Expanded(
                  flex: 5,
                  child: Center(
                    child: Text("You have not placed any orders yet"),
                  ),
                );
              }
              if (state is TrackOrderLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is TrackOrderLoaded) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListView.builder(
                        controller: _controller,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                title: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                  child: Text(
                                    state.orders[index].orderNo,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                            fontSize: 18,
                                            color: Colors.grey.shade800),
                                  ),
                                ),
                                subtitle: Text(
                                  state.orders[index].orderDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        fontSize: 15,
                                        color: Colors.grey.shade600,
                                      ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(20))),
                                      child: Center(
                                        child: Text(
                                          state.orders[index].status,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                fontSize: 13,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
   void _openSearchModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const SearchModal();
      },
    );
  }
}