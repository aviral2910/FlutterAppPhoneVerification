import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:virtuostack/pages/home_page.dart';
import 'package:virtuostack/pages/login_byotp_page.dart';
import 'package:virtuostack/pages/otp_retrieval_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/loginotp": (context) => const LoginByOTP(),
        "/home_page": (context) => const HomePage(title: 'ITEMS'),
      },

      title: 'Flutter Demo',
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.purple.shade50),
          // buttonTheme: ButtonThemeData(buttonColor: Colors.purple.shade700),
          primarySwatch: Colors.purple),
      home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("error");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return InitializerWidget();
            }
            return CircularProgressIndicator();
          }),
      // home: const HomePage(title: 'ITEMS'),
    );
  }
}

class InitializerWidget extends StatefulWidget {
  InitializerWidget({Key? key}) : super(key: key);

  @override
  State<InitializerWidget> createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {
  late FirebaseAuth _auth;
  late bool userloggedin;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _auth = FirebaseAuth.instance;
    if (_auth.currentUser == null) {
      userloggedin = false;
    } else {
      userloggedin = true;
    }

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : userloggedin
            ? HomePage(title: "ITEM")
            : LoginByOTP();
  }
}
