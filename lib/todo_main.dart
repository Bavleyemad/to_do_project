import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_project/providers/authproviders.dart';
import 'package:to_do_project/providers/settings_providers.dart';
import 'package:to_do_project/providers/task_provider.dart';
import 'package:to_do_project/ui/home/home_screen.dart';
import 'package:to_do_project/ui/home/list/Register_screen.dart';
import 'package:to_do_project/ui/home/list/login_screen.dart';
import 'package:to_do_project/ui/home/list/splash_screen.dart';

import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProviders()),
      ChangeNotifierProvider(create: (_) => TaskProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
    ],

      child:  MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var AuthProvider=Provider.of<AuthProviders>(context);
    var settingsProvider=Provider.of<SettingsProvider>(context);
    return MaterialApp(
      themeMode: settingsProvider.selectedTheme,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
            titleMedium:
        TextStyle(fontWeight: FontWeight.bold,
        fontSize: 18),
        titleSmall: TextStyle(color: Colors.white,
            fontSize: 18),),
        bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.transparent
        ,elevation: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        ),
        scaffoldBackgroundColor: Color(0xffDFECDB),
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        floatingActionButtonTheme:FloatingActionButtonThemeData(backgroundColor: Colors.blue) ,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: false,
      ),
     routes: {
       SplashScreen.routname:(_)=>SplashScreen(),
       RegisterScreen.routname:(_)=>RegisterScreen(),
        HomeScreen.routename:(_)=>HomeScreen(),
       Loginscreen.routname:(_)=>Loginscreen()
     },
      initialRoute:
      AuthProvider.isLogged()?
      HomeScreen.routename:Loginscreen.routname,
    );
  }
}
