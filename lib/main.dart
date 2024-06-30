import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/di/injects.dart';
import 'package:testinger/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InitialApps.start().then((_) => runApp(const MyApp()));
}

class InitialApps {
  static Future<void> start() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    await configureDependencies();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp.router(
        routeInformationParser: inject<AppRouter>().defaultRouteParser(),
        routerDelegate: inject<AppRouter>().delegate(),
        title: 'Testinger',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Constants.main,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Constants.main),
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
            ),
          ),
        ),
      );
    });
  }
}
