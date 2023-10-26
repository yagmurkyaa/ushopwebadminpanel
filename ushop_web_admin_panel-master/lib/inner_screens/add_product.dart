import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ushop_admin_panel/controllers/MenuController.dart';
import 'package:ushop_admin_panel/responsive.dart';
import 'package:ushop_admin_panel/screens/loading_manager.dart';
import 'package:ushop_admin_panel/services/global_method.dart';
import 'package:ushop_admin_panel/services/utils.dart';
import 'package:ushop_admin_panel/widgets/buttons.dart';
import 'package:ushop_admin_panel/widgets/header.dart';
import 'package:ushop_admin_panel/widgets/side_menu.dart';
import 'package:ushop_admin_panel/widgets/text_widget.dart';
import 'package:uuid/uuid.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({Key? key}) : super(key: key);

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {

  final _formKey = GlobalKey<FormState>();
  String _catValue = "Clothes";
  late final TextEditingController _titleController, _priceController;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);

  int _groupValue = 1;
  bool isPiece = false;

  @override
  void initState() {
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? imageUrl;
    if (isValid) {
      _formKey.currentState!.save();
      if (isValid) {
        _formKey.currentState!.save();
        if (_pickedImage == null) {
          GlobalMethods.errorDialog(
              error: "Please, pick up an image.", context: context);
          return;
        }
        final _uuid = const Uuid().v4();
        try {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance.ref()
              .child("productImages")
              .child("$_uuid.jpg");
          if (kIsWeb) {
            await ref.putData(webImage);
          } else {
            await ref.putFile(_pickedImage!);
          }
          imageUrl = await ref.getDownloadURL();
          await FirebaseFirestore.instance.collection('products')
              .doc(_uuid)
              .set({
            'id': _uuid,
            'title': _titleController.text,
            "price": _priceController.text,
            "salePrice": 0.1,
            "imageUrl": imageUrl,
            "productCategoryName": _catValue,
            "isOnSale": false,
            'createdAt': Timestamp.now(),
          });
          _clearForm();
          Fluttertoast.showToast(
            msg: "Product uploaded succefully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            // backgroundColor: ,
            // textColor: ,
            // fontSize: 16.0
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              error: "${error.message}",
              context: context);
          setState(() {
            _isLoading = false;
          });
        } catch (error) {
          GlobalMethods.errorDialog(
              error: "$error",
              context: context);
          setState(() {
            _isLoading = false;
          });
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

    void _clearForm() {
      isPiece = false;
      //_groupValue = 1;
      _priceController.clear();
      _titleController.clear();
      setState(() {
        _pickedImage = null;
        webImage = Uint8List(8);
      });
    }

    @override
    Widget build(BuildContext context) {
      final theme = Utils(context).getTheme;
      final color = Utils(context).color;
      final _scaffoldColor = Theme
          .of(context)
          .scaffoldBackgroundColor;
      Size size = Utils(context).getScreenSize;

      var inputDecoration = InputDecoration(
        filled: true,
        fillColor: _scaffoldColor,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
            width: 1.0,
          ),
        ),
      );
      return Scaffold(
        key: context
            .read<MenuController>()
            .getAddProductScaffoldKey,
        drawer: const SideMenu(),
        body: LoadingManager(
          isLoading: _isLoading,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: SideMenu(),
                ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 25,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Header(
                            title: "Add Product",
                            showTextField: false,
                            fct: () {
                              context.read<MenuController>()
                                  .controlAddProductsMenu();
                            }),
                      ),
                      const SizedBox(height: 25,),
                      Container(
                        width: size.width > 755 ? 755 : size.width,
                        color: Theme
                            .of(context)
                            .cardColor,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextWidget(
                                text: "Product title*",
                                color: color,
                                isTitle: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _titleController,
                                key: const ValueKey("Title"),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter a title";
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          TextWidget(
                                            text: "Price in ₺*",
                                            color: color,
                                            isTitle: true,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: TextFormField(
                                              controller: _priceController,
                                              key: const ValueKey("Price ₺"),
                                              keyboardType: TextInputType
                                                  .number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please enter a price";
                                                }
                                                return null;
                                              },
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(
                                                    RegExp(r'[0-9.]')
                                                ),
                                              ],
                                              decoration: inputDecoration,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextWidget(
                                            text: "Category of the Product",
                                            //Product category
                                            color: color,
                                            isTitle: true,
                                          ),
                                          const SizedBox(height: 10),
                                          // Drop down menu code here
                                          _categoryDropDown(),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          /*TextWidget(
                                          text: "Measure unit",
                                          color: color,
                                          isTitle: true,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),

                                        // Radio button code here
                                        Row(
                                          children: [
                                            TextWidget(
                                              text: "option1",
                                              color: color,
                                            ),
                                            Radio(
                                              value: 1,
                                              groupValue: _groupValue,
                                              onChanged: (valuee) {
                                                setState(() {
                                                  _groupValue = 1;
                                                  isPiece = false;
                                                });
                                              },
                                              activeColor: Colors.cyan,
                                            ),
                                            TextWidget(
                                              text: "option2",
                                              color: color,
                                            ),
                                            Radio(
                                              value: 2,
                                              groupValue: _groupValue,
                                              onChanged: (valuee) {
                                                setState(() {
                                                  _groupValue = 2;
                                                  isPiece = true;
                                                });
                                              },
                                              activeColor: Colors.cyan,
                                            ),
                                          ],
                                        )*/
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Image to be picked code is here
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          height: size.width > 755
                                              ? 350
                                              : size.width * 0.45,
                                          decoration: BoxDecoration(
                                            color: Theme
                                                .of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.circular(
                                                12.0),
                                          ),
                                          child: _pickedImage == null
                                              ? dottedBorder(color: color)
                                              : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                12),
                                            child: kIsWeb
                                                ? Image.memory(webImage,
                                                fit: BoxFit.fill)
                                                : Image.file(_pickedImage!,
                                                fit: BoxFit.fill),
                                          )
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        child: Column(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _pickedImage = null;
                                                  webImage = Uint8List(8);
                                                });
                                              },
                                              child: TextWidget(
                                                isTitle: true,
                                                text: "Clear",
                                                textSize: 20,
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              child: TextWidget(
                                                isTitle: true,
                                                textSize: 20,
                                                text: "Update image",
                                                color: Colors.cyan,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  children: [
                                    ButtonsWidget(
                                      onPressed: _clearForm,
                                      text: "Clear form",
                                      icon: Icons.warning_amber,
                                      backgroundColor: Colors.red.shade300,
                                    ),
                                    ButtonsWidget(
                                      onPressed: () {
                                        _uploadForm();
                                      },
                                      text: "Upload the product",
                                      icon: Icons.file_upload,
                                      backgroundColor: Colors.cyan,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
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

    Future<void> _pickImage() async {
      if (!kIsWeb) {
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          var selected = File(image.path);
          setState(() {
            _pickedImage = selected;
          });
        } else {
          print("You have to choose an image first!");
        }
      } else if (kIsWeb) {
        final ImagePicker _picker = ImagePicker();
        XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          var f = await image.readAsBytes();
          setState(() {
            webImage = f;
            _pickedImage = File("a");
          });
        } else {
          print("There is not an image has been picked");
        }
      } else {
        print("Something went wrong!");
      }
    }

    Widget dottedBorder({
      required Color color,
    }) {
      return Padding(
        padding: const EdgeInsets.all(5.0), //8
        child: DottedBorder(
            dashPattern: const [6.7],
            borderType: BorderType.RRect,
            color: color,
            radius: const Radius.circular(12),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    //Icons.image_outlined,
                    color: color,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: (() {
                        _pickImage();
                      }),
                      child: TextWidget(
                        text: "Choose an image\n  for the product",
                        color: Colors.cyan,
                      )
                  )
                ],
              ),
            )
        ),
      );
    }

    Widget _categoryDropDown() {
      final color = Utils(context).color;
      return Container(
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
                value: _catValue,
                onChanged: (value) {
                  setState(() {
                    _catValue = value!;
                  });
                  print(_catValue);
                },
                hint: const Text("Select a category"),
                items: const [
                  DropdownMenuItem(
                    child: Text(
                      "Clothes",
                    ),
                    value: "Clothes",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Accessories",
                    ),
                    value: "Accessories",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Stationeries",
                    ),
                    value: "Stationeries",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Others",
                    ),
                    value: "Others",
                  ),
                ],
              )
          ),
        ),
      );
    }
  }
