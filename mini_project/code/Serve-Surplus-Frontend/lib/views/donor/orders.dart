import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serve_surplus/schema/order.dart';
import 'package:serve_surplus/services/donor.dart';
import 'package:serve_surplus/views/donor/individual_order.dart';
import 'package:serve_surplus/widgets/custom_button.dart';

class DonorOrdersPage extends StatefulWidget {
  const DonorOrdersPage({super.key});

  @override
  State<DonorOrdersPage> createState() => _DonorOrdersPageState();
}

class _DonorOrdersPageState extends State<DonorOrdersPage> {
  List<Order>? orders;
  String status = "All Orders";

  navigateToIndividualOrder(int index) {
    Navigator.pushNamed(
      context,
      IndividualDonorOrderPage.routeName,
      arguments: orders![index],
    );
  }

  getAllOrders() async {
    orders = await DonorServices.getDonorOrders(context: context);
    if (context.mounted) {
      setState(() {});
    }
  }

  getOrdersByStatus() async {
    if (status == "All Orders") {
      orders = await DonorServices.getDonorOrders(context: context);
    } else {
      orders = await DonorServices.getDonorOrders(
        context: context,
        status: status,
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Orders",
          style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: orders == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              status = "All Orders";
                              getOrdersByStatus();
                            });
                          },
                          child: Chip(
                            label: const Text("All Orders"),
                            elevation: status == "All Orders" ? 25 : 0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              status = "Processing";
                              getOrdersByStatus();
                            });
                          },
                          child: Chip(
                            label: const Text("Processing"),
                            elevation: status == "Processing" ? 25 : 0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              status = "Delivered";
                              getOrdersByStatus();
                            });
                          },
                          child: Chip(
                            label: const Text("Delivered"),
                            elevation: status == "Delivered" ? 25 : 0,
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: orders!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => navigateToIndividualOrder(index),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(13)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                  child: CachedNetworkImage(
                                    imageUrl: orders![index].image,
                                    width: double.infinity,
                                    height: 170,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url, progress) => SizedBox(
                                      height: 170,
                                      child: Center(
                                        child: CircularProgressIndicator(value: progress.progress),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orders![index].food,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Quantity: ",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(255, 8, 6, 135),
                                            ),
                                          ),
                                          Text(
                                            orders![index].quantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      CustomButton(
                                        "View Order",
                                        formKey: null,
                                        userService: () => navigateToIndividualOrder(
                                          index,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
