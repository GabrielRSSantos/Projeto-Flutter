import 'package:flutter/material.dart';
import 'package:max_shoes_vendedor/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Max Shoes Vendedor',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: SplashPage(),
      ),
    );
  }
}
