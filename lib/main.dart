import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project1/controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:project1/google_maps.dart';
import 'package:project1/home_page.dart';
import 'package:project1/login_page.dart';
import 'package:project1/sign_up_page.dart';
import 'package:project1/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // ✅ Change from MaterialApp to GetMaterialApp
      debugShowCheckedModeBanner: false,
      title: "Flutter Firebase",
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',  // Set the initial route
      getPages: [  // ✅ Use GetX Named Routes
        GetPage(name: '/', page: () => SplashScreen(child: LoginPage())),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/signUp', page: () => SignupPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/maps', page: () => GoogleMapsPage()),
      ],
    );
  }
}






// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// // import 'package:project1/firebase_options.dart';
// import 'firebase_options.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:project1/google_maps.dart';
// import 'package:project1/home_page.dart';
// import 'package:project1/login_page.dart';
// import 'package:project1/sign_up_page.dart';
// import 'package:project1/splash_screen.dart';
//
//
// // import 'package:firebase_core_web/firebase_core_web.dart'
//
// Future main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
//   ) ;
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Flutter Firebase",
//       theme: ThemeData(
//         primarySwatch: Colors.pink,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text("Flutter"),
//         ),
//         body: FutureBuilder(
//             future: _initialization,
//             builder: (context , snapshot){
//               if(snapshot.hasError){
//                 return Center(
//                   child: Text("Could not connect"),
//                 );
//               }
//               if(snapshot.connectionState == ConnectionState.done){
//                 return LoginPage() ;
//               }
//               return Center(child : CircularProgressIndicator());
//             }
//         )
//       )
//     );
//     //
//     //
//     // MaterialApp(
//     //   title: 'Flutter Firebase',
//     //   routes: {
//     //     '/': (context) => SplashScreen(
//     //       // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
//     //       child: LoginPage(),
//     //     ),
//     //     '/login': (context) => LoginPage(),
//     //     '/signUp': (context) => SignupPage(),
//     //     '/home': (context) => HomePage(),
//     //     '/maps':(context)=> GoogleMapsPage(),
//     //   },
//     // );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Firebase',
//       routes: {
//         '/': (context) => SplashScreen(
//           // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
//           child: LoginPage(),
//         ),
//         '/login': (context) => LoginPage(),
//         '/signUp': (context) => SignupPage(),
//         '/home': (context) => HomePage(),
//         '/maps':(context)=> GoogleMapsPage(),
//       },
//     );
//   }
// }
//
//
