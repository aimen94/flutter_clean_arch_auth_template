import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection container
  await di.setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          primary: Colors.cyan[700],
          secondary: Colors.cyan[200],
        ),

        textTheme: GoogleFonts.sairaTextTheme(Theme.of(context).textTheme),

        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.saira(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.saira(),
          hintStyle: GoogleFonts.saira(),
        ),

        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          buttonColor: Colors.cyan[700],
        ),
      ),

      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',

      routerConfig: AppRouter.router,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/core/app_router.dart';
// import 'service_locator.dart' as di;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await di.setupLocator();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       theme: ThemeData(primaryColor: Colors.cyan[200]),
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       routerConfig: AppRouter.router,
//     );
//   }
// }
