import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:ushop_admin_panel/models/product_model.dart';

class ProductsProvider with ChangeNotifier {

  static List<ProductModel> _productsList = [];

  List<ProductModel> get getProducts { //for accessing to ChangeNotifier
    return _productsList;
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance.collection("products").get().then((
        QuerySnapshot productSnapshot) {
      _productsList = []; //_productsList.clear();
      productSnapshot.docs.forEach((element) {
        _productsList.insert(
            0,
            ProductModel(
              id: element.get("id"),
              title: element.get("title"),
              imageUrl: element.get("imageUrl"),
              productCategoryName: element.get("productCategoryName"),
              price: double.parse(element.get("price"),),
              salePrice: (element.get("salePrice")).toDouble(),
              isOnSale: element.get("isOnSale"), ));
      });
    }); // tüm ürünleri göstermek istediğimiz için id eklemedik kullanıcada öyle değildi.
    notifyListeners();
  }

  List<ProductModel> get getOnSaleProducts {
    return _productsList.where((element) => element.isOnSale).toList();
  }

  ProductModel findProdById(String productId) {
    return _productsList.firstWhere((element) => element.id == productId);
  }

  List<ProductModel> findByCategory(String categoryName) {
    List<ProductModel> _categoryList = _productsList
        .where((element) => element.productCategoryName
        .toLowerCase()
        .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  List<ProductModel> searchQuery(String searchText) {
    List<ProductModel> _searchList = _productsList
        .where((element) => element.title
        .toLowerCase()
        .contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }


}


