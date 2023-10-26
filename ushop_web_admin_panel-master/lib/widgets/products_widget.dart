import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:ushop_admin_panel/inner_screens/edit_product.dart';
import 'package:ushop_admin_panel/services/global_method.dart';
import 'package:ushop_admin_panel/services/utils.dart';
import 'package:ushop_admin_panel/widgets/buttons.dart';
import 'package:ushop_admin_panel/widgets/text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  bool _isLoading = false;
  String title = "";
  String productCategory = "";
  String? imageUrl;
  String price = "0.0";
  double salePrice = 0.0;
  bool isOnSale = false;
  //bool isPiece = false;

  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  /*Future<void> fetchProducts() async {
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
  }*/

  Future<void> getProductsData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        setState(() {
          title = productsDoc.get("title");
          productCategory = productsDoc.get("productCategoryName");
          imageUrl = productsDoc.get("imageUrl");
          price = productsDoc.get("price");
          salePrice = productsDoc.get("salePrice");
          isOnSale = productsDoc.get("isOnSale");
          //isPiece = productsDoc.get('isPiece');
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(error: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor.withOpacity(0.6),
        child: InkWell( //it allows you to press on it
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => EditProductScreen(
                      id: widget.id,
                      title: title,
                      price: price,
                      salePrice: salePrice,
                      productCat: productCategory,
                      imageUrl: imageUrl == null
                          ? "assets/images/ushoplogo.png"
                          : imageUrl!,
                      isOnSale: isOnSale,
                      //isPiece: isPiece
              ))
            ).then((value) => setState(() {}));
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0), //8 yapınca pixel error
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Image.network(
                        imageUrl == null
                        ? "assets/images/ushoplogo.png"
                        : imageUrl!,
                        fit: BoxFit.fill,
                        // width: screenWidth * 0.12,
                        height: size.width * 0.14, //12
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () async{
                              await FirebaseFirestore.instance
                                  .collection("products")
                                  .doc(widget.id)
                                  .delete();
                              await Fluttertoast.showToast( //showToast boolean olduğu için
                                msg: "Product has beeen deleted!",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                              );
                              while (Navigator.canPop(context)){ //side menu varken bu olmaz
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            value: 1,
                          ),
                        ])
                  ],
                ),
                const SizedBox(
                  height: 4, //
                ),
                Row(
                  children: [
                    TextWidget(
                      text: isOnSale ? '${salePrice.toStringAsFixed(2)}₺' : '$price₺',
                      color: color,
                      textSize: 18,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Visibility(
                        visible: isOnSale,
                        child: Text(
                          "$price ₺",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: color),
                        )),
                    const Spacer(),
                    /*TextWidget(
                      text: "Quantity", //isPiece ? "Piece" : "Kg",
                      color: color,
                      textSize: 18,
                    ),*/
                  ],
                ),
                /*TextWidget(
                  text: "Stock :", //isPiece ? "Piece" : "Kg",
                  color: color,
                  textSize: 18,
                ),*/
                const SizedBox(
                  height: 4, //2
                ),
                TextWidget(
                  text: title,
                  color: color,
                  textSize: 24,
                  isTitle: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}