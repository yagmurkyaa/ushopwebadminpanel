import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ushop_admin_panel/consts/theme_data.dart';
import 'package:ushop_admin_panel/controllers/MenuController.dart';
import 'package:ushop_admin_panel/inner_screens/add_product.dart';
import 'package:ushop_admin_panel/providers/dark_theme_provider.dart';
import 'package:ushop_admin_panel/screens/main_screen.dart';
//import 'firebase_options.dart';

/*void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA96eR1NFaj78QUJIioul_g6uU19y3PamU", // Your apiKey
      appId: "1:587526600299:web:cbc4fe1f8194ea0ed3a32e", // Your appId
      messagingSenderId: "587526600299", // Your messagingSenderId
      projectId: "ushopecommerceapplication", // Your projectId
      storageBucket: "ushopecommerceapplication.appspot.com",
      authDomain: "ushopecommerceapplication.firebaseapp.com",
      //  measurementId: "G-RBDT58W304"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}) ;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
    await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('App is being initialized'),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Center(
                    child: Text('An error has been occured ${snapshot.error}'),
                  ),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => MenuController(),
              ),
              ChangeNotifierProvider(
                  create: (_) {
                    return themeChangeProvider;
                  }
              ),
            ],
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: "USHOP",
                    theme: Styles.themeData(
                        themeProvider.getDarkTheme, context),
                    home: const MainScreen(),
                    routes: {
                      UploadProductForm.routeName: (context) =>
                      const UploadProductForm(),
                    });
              },
            ),
          );
        });
  }
}
