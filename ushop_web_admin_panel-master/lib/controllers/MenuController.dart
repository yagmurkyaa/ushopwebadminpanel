import 'package:flutter/material.dart';
//Add this changeNotifier to listen to the changes and access the provider, it will become clearer in the state management section (extends sonrası sanırım)
class MenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _gridScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _addProductScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _ordersScaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _editProductScaffoldKey = GlobalKey<ScaffoldState>();

  // Getters
  GlobalKey<ScaffoldState> get getScaffoldKey => _scaffoldKey;
  GlobalKey<ScaffoldState> get getGridScaffoldKey => _gridScaffoldKey;
  GlobalKey<ScaffoldState> get getAddProductScaffoldKey => _addProductScaffoldKey;
  GlobalKey<ScaffoldState> get getOrdersScaffoldKey => _ordersScaffoldKey;
  GlobalKey<ScaffoldState> get getEditProductscaffoldKey => _editProductScaffoldKey;

  // Callbacks
  void controlDashboardMenu() { // for now our application is based on this function
    if (!_scaffoldKey.currentState!.isDrawerOpen) { //it checks that if the drawer is open or not
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void controlProductsMenu() {
    if (!_gridScaffoldKey.currentState!.isDrawerOpen) {
      _gridScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAddProductsMenu() {
    if (!_addProductScaffoldKey.currentState!.isDrawerOpen) {
      _addProductScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlAllOrders() { // for now our application is based on this function
    if (!_ordersScaffoldKey.currentState!.isDrawerOpen) { //it checks that if the drawer is open or not
      _ordersScaffoldKey.currentState!.openDrawer();
    }
  }

  void controlEditProductsMenu() {
    if (!_editProductScaffoldKey.currentState!.isDrawerOpen) {
      _editProductScaffoldKey.currentState!.openDrawer();
    }
  }
}