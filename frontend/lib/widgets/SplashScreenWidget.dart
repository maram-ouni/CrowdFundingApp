// import 'dart:io';

// import 'package:collective/screens/HomeScreen.dart';
// import 'package:collective/screens/LoginScreen.dart';
// import 'package:flutter/material.dart';


// import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreenWidget extends StatefulWidget {
//   @override
//   _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
// }

// class _SplashScreenWidgetState extends State<SplashScreenWidget> {
//   bool _isLogedIn = false;

//   splashScreenCheck() {
//     return Future.delayed(Duration(milliseconds: 1500), () async {
//       try {
//         final result = await InternetAddress.lookup('google.com');
//         if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//           if (_isLogedIn == true) {
//             return HomeScreen();
//           } else {
//             return LoginScreen();
//           }
//         }
//         return LoginScreen();
//       } on SocketException catch (_) {
//         return Scaffold(
//           body: Center(
//             child: Container(
//               padding: EdgeInsets.all(50),
//               child: Text(
//                 'No internet connection, please check your network and restart the app!',
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         );
//       }
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     SharedPreferences.getInstance().then(
//       (prefValue) {
//         if (prefValue.containsKey('token')) {
//           setState(() {
//             _isLogedIn = true;
//           });
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       statusBarIconBrightness: Brightness.dark,
//     ));
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         padding: EdgeInsets.only(top: 230),
//         child: SplashScreen(
//           navigateAfterFuture: splashScreenCheck(),
//           image: Image.asset('assets/images/Logo.png'),
//           backgroundColor: Theme.of(context).colorScheme.surface,
//           photoSize: 50.0,
//           useLoader: false,
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';
import 'package:collective/screens/HomeScreen.dart';
import 'package:collective/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  bool _isLogedIn = false;

  // Fonction pour vérifier la connexion Internet et l'état de l'utilisateur
  Future<Widget> splashScreenCheck() async {
    // Vérification de la connexion Internet
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (_isLogedIn) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      }
      return LoginScreen();  // Si pas de connexion, rediriger vers LoginScreen
    } on SocketException catch (_) {
      // Si aucune connexion Internet, afficher un message d'erreur
      return Scaffold(
        body: Center(
          child: Container(
            padding: EdgeInsets.all(50),
            child: Text(
              'No internet connection, please check your network and restart the app!',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Vérifier l'état de l'utilisateur (connecté ou non)
    SharedPreferences.getInstance().then(
      (prefValue) {
        if (prefValue.containsKey('token')) {
          setState(() {
            _isLogedIn = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Modifier la couleur de la barre d'état
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Widget>(
        // Appeler la fonction de vérification au démarrage
        future: splashScreenCheck(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Afficher un indicateur de chargement pendant la vérification
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Si une erreur survient, afficher un message d'erreur
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Afficher l'écran approprié après la vérification
            return snapshot.data!;
          }
        },
      ),
    );
  }
}

