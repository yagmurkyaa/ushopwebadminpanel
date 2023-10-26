import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ushop_admin_panel/consts/constants.dart';
import 'package:ushop_admin_panel/controllers/MenuController.dart';
import 'package:ushop_admin_panel/responsive.dart';
import 'package:ushop_admin_panel/services/utils.dart';
import 'package:ushop_admin_panel/widgets/grid_products.dart';
import 'package:ushop_admin_panel/widgets/header.dart';
import 'package:ushop_admin_panel/widgets/side_menu.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("products")
            .snapshots(),
        builder: (context, snapshot) {
        return Scaffold(
          key: context.read<MenuController>().getGridScaffoldKey,
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
                        const SizedBox(height: 15,),//25
                        Header(
                          title: "All Products in the USHOP",
                          fct: () {
                            context.read<MenuController>().controlProductsMenu(); //how to access a provider
                           //key değiştiği için burdaki menu de değişmeli. önceden dahboard menu idi.
                          },
                        ),
                        const SizedBox(height: 25,),
                        Responsive(
                          mobile: ProductGridWidget(
                            crossAxisCount: size.width < 755 ? 2 : 4, //650
                            childAspectRatio:
                            size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                            isInMain: false,
                          ),
                          desktop: ProductGridWidget(
                            childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                            isInMain: false,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
