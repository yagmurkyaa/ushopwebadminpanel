import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ushop_admin_panel/consts/constants.dart';
import 'package:ushop_admin_panel/widgets/orders_widget.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({
    Key? key,
    required this.isInDashboard})
      : super(key: key);

  final bool isInDashboard;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("orders")
          .orderBy("orderDate", descending: false)
          .snapshots(), //collectiondaki dosya ismiyle aynı olmalı
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return  Container(
              padding: const EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: Colors.yellow[700]?.withOpacity(0.8),//Theme.of(context).cardColor, //çerçevenin rengi
                borderRadius: const BorderRadius.all(Radius.circular(8)), //10//çervenin köşesi
              ),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: isInDashboard && snapshot.data!.docs.length > 4
                      ? 5
                      : snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        OrdersWidget(
                          price: snapshot.data!.docs[index]["price"],
                          totalPrice: snapshot.data!.docs[index]["totalPrice"],
                          userId: snapshot.data!.docs[index]["userId"],
                          userName: snapshot.data!.docs[index]["userName"],
                          productId: snapshot.data!.docs[index]["productId"],
                          imageUrl: snapshot.data!.docs[index]["imageUrl"],
                          quantity: snapshot.data!.docs[index]["quantity"],
                          orderDate: snapshot.data!.docs[index]["orderDate"],
                          orderId: snapshot.data!.docs[index]["orderId"],
                        ),
                        Divider(thickness: 3,),
                      ],
                    );
                  }),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "There isn't any product in USHOP yet!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    //backgroundColor: Colors.cyan,
                  ),
                ),
              ),
            );
          }
        }
        return const Center(
          child: Text(
            "Something went wrong",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        );
      },
    );
      /*Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.yellow[700]?.withOpacity(0.8),//Theme.of(context).cardColor, //çerçevenin rengi
            borderRadius: const BorderRadius.all(Radius.circular(8)), //10//çervenin köşesi
          ),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (ctx, index) {
                return Column(
                  children: const [
                    OrdersWidget(),
                    Divider(thickness: 3,),
                  ],
                );
              }),
    ); stream builderı eklemeden önce*/
  }
}