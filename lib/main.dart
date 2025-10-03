import 'package:flutter/material.dart';
import 'package:flutter_application_2/core/app_router.dart';
import 'package:flutter_application_2/features/auth/presentions/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter app',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<AuthCubit>(
          create: (context) => di.sl<AuthCubit>(),
          child: MaterialApp.router(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.cyan,
                primary: Color(0xff010d88),
                secondary: Colors.cyan[200],
              ),
              textTheme: GoogleFonts.sairaTextTheme(
                Theme.of(context).textTheme,
              ),
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
          ),
        ),
      ),
    );
  }
}
