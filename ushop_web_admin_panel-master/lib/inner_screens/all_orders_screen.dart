import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ushop_admin_panel/consts/constants.dart';
import 'package:ushop_admin_panel/controllers/MenuController.dart';
import 'package:ushop_admin_panel/responsive.dart';
import 'package:ushop_admin_panel/services/utils.dart';
import 'package:ushop_admin_panel/widgets/grid_products.dart';
import 'package:ushop_admin_panel/widgets/header.dart';
import 'package:ushop_admin_panel/widgets/orders_list.dart';
import 'package:ushop_admin_panel/widgets/orders_widget.dart';
import 'package:ushop_admin_panel/widgets/side_menu.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<MenuController>().getOrdersScaffoldKey,
      //önceden scaffold key idi böylöyle drawerı başka yerden kontrol etmiş oluyoruz
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row( //drawer yanında dashboard screen o yüzden row yanyana
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    Header(
                      showTextField: false,
                      title: "All Orders",
                      fct: () {
                        context.read<MenuController>().controlAllOrders(); //how to access a provider
                        //key değiştiği için burdaki menu de değişmeli. önceden dahboard menu idi.
                      },
                    ),
                      const SizedBox(height: 20,),
                      const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: OrdersList(
                            isInDashboard: false,
                          ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
