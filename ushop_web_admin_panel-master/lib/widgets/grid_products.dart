import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ushop_admin_panel/consts/constants.dart';
import 'package:ushop_admin_panel/services/utils.dart';
import 'package:ushop_admin_panel/widgets/products_widget.dart';
import 'package:ushop_admin_panel/widgets/text_widget.dart';

class ProductGridWidget extends StatelessWidget {
  const ProductGridWidget({Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    this.isInMain = true,})
      : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain; //Checks if the gird is on dashboard screen or not
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("products").snapshots(), //collectiondaki dosya ismiyle aynı olmalı
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return /*snapshot.data!.docs.length == 0
                ? Center(
                    child: TextWidget(
                      text: "You have not added any product yet!",
                      color: color,
                    ),)
                :*/ GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: isInMain && snapshot.data!.docs.length > 4
                       ? 4
                       : snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: defaultPadding,
                      mainAxisSpacing: defaultPadding,
                    ),
                    itemBuilder: (context, index) {
                      return ProductWidget(
                        id: snapshot.data!.docs[index]["id"],
                      );
                    });
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
  }
}
