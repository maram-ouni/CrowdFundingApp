import 'package:collective/screens/BuyCtvScreen.dart';
import 'package:collective/screens/CampScreen.dart';
import 'package:collective/screens/CollabMainScreen.dart';
import 'package:collective/screens/CreateCampCollabJobScreen.dart';
import 'package:collective/screens/CreateCampHomeScreen.dart';
import 'package:collective/screens/CreateCampScreen.dart';
import 'package:collective/screens/HomeScreen.dart';
import 'package:collective/screens/InvestInCamp.dart';
import 'package:collective/screens/LoginScreen.dart';
import 'package:collective/screens/RegisterScreen.dart';
import 'package:collective/screens/SupportEmailScreen.dart';
import 'package:collective/screens/UserDetailsScreen.dart';
import 'package:collective/screens/UserInvestmentScreen.dart';
import 'package:collective/screens/UsersCampScreen.dart';
import 'package:collective/screens/UsersCollabScreen.dart';
import 'package:collective/widgets/SplashScreenWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void fetchData() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    print('Data fetched successfully');
  } else {
    print('Failed to load data');
  }
}

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarDividerColor: Color.fromRGBO(240, 240, 240, 1),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color.fromRGBO(24, 119, 242, 1.0),
          fontFamily: 'Avenir', colorScheme: ColorScheme.light(surface: Colors.white)),
      home: RegisterScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        BuyCtvScreen.routeName: (ctx) => BuyCtvScreen(),
        CreateCampScreen.routeName: (ctx) => CreateCampScreen(),
        CampScreen.routeName: (ctx) => CampScreen(),
        InvestInCamp.routeName: (ctx) => InvestInCamp(),
        UserDetailsScreen.routeName: (ctx) => UserDetailsScreen(),
        UserInvestmentScreen.routeName: (ctx) => UserInvestmentScreen(),
        UsersCollabScreen.routeName: (ctx) => UsersCollabScreen(),
        UsersCampScreen.routeName: (ctx) => UsersCampScreen(),
        SupportEmailScreen.routeName: (ctx) => SupportEmailScreen(),
        CreateCampHomeScreen.routeName: (ctx) => CreateCampHomeScreen(),
        CollabMainScreen.routeName: (ctx) => CollabMainScreen(),
        CreateCampCollabJobScreen.routeName: (ctx) =>
            CreateCampCollabJobScreen(),
      },
    );
  }
}
// import 'package:collective/screens/BuyCtvScreen.dart';
// import 'package:collective/screens/CampScreen.dart';
// import 'package:collective/screens/CollabMainScreen.dart';
// import 'package:collective/screens/CreateCampCollabJobScreen.dart';
// import 'package:collective/screens/CreateCampHomeScreen.dart';
// import 'package:collective/screens/CreateCampScreen.dart';
// import 'package:collective/screens/HomeScreen.dart';
// import 'package:collective/screens/InvestInCamp.dart';
// import 'package:collective/screens/LoginScreen.dart';
// import 'package:collective/screens/RegisterScreen.dart';
// import 'package:collective/screens/SupportEmailScreen.dart';
// import 'package:collective/screens/UserDetailsScreen.dart';
// import 'package:collective/screens/UserInvestmentScreen.dart';
// import 'package:collective/screens/UsersCampScreen.dart';
// import 'package:collective/screens/UsersCollabScreen.dart';
// import 'package:collective/widgets/SplashScreenWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// void fetchData() async {
//   final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

//   if (response.statusCode == 200) {
//     print('Data fetched successfully');
//   } else {
//     print('Failed to load data');
//   }
// }

// void main() {
//   runApp(MyApp());
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     systemNavigationBarColor: Colors.white,
//     systemNavigationBarDividerColor: Color.fromRGBO(240, 240, 240, 1),
//     systemNavigationBarIconBrightness: Brightness.dark,
//   ));
// }

// class MyApp extends StatelessWidget {
//   Future<String> _getInitialRoute() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
    
//     // Si l'utilisateur a un token, on le redirige vers l'écran d'accueil, sinon vers l'écran d'inscription.
//     return token != null && token.isNotEmpty ? HomeScreen.routeName : RegisterScreen.routeName;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Color.fromRGBO(24, 119, 242, 1.0),
//         fontFamily: 'Avenir',
//         colorScheme: ColorScheme.light(surface: Colors.white),
//       ),
//       home: FutureBuilder<String>(
//         future: _getInitialRoute(),
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return SplashScreenWidget(); // Afficher le splashscreen pendant le chargement.
//           } else if (snapshot.hasData) {
//             // Lorsque le future est terminé, on renvoie un écran en fonction de la donnée retournée
//             return Navigator.pushReplacementNamed(ctx, snapshot.data!);
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return RegisterScreen(); // Par défaut, retourner l'écran d'inscription
//           }
//         },
//       ),
//       routes: {
//         LoginScreen.routeName: (ctx) => LoginScreen(),
//         RegisterScreen.routeName: (ctx) => RegisterScreen(),
//         HomeScreen.routeName: (ctx) => HomeScreen(),
//         BuyCtvScreen.routeName: (ctx) => BuyCtvScreen(),
//         CreateCampScreen.routeName: (ctx) => CreateCampScreen(),
//         CampScreen.routeName: (ctx) => CampScreen(),
//         InvestInCamp.routeName: (ctx) => InvestInCamp(),
//         UserDetailsScreen.routeName: (ctx) => UserDetailsScreen(),
//         UserInvestmentScreen.routeName: (ctx) => UserInvestmentScreen(),
//         UsersCollabScreen.routeName: (ctx) => UsersCollabScreen(),
//         UsersCampScreen.routeName: (ctx) => UsersCampScreen(),
//         SupportEmailScreen.routeName: (ctx) => SupportEmailScreen(),
//         CreateCampHomeScreen.routeName: (ctx) => CreateCampHomeScreen(),
//         CollabMainScreen.routeName: (ctx) => CollabMainScreen(),
//         CreateCampCollabJobScreen.routeName: (ctx) =>
//             CreateCampCollabJobScreen(),
//       },
//     );
//   }
// }
