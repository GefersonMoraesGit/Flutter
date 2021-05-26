import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:haumea/models/bottom_tab_provider.dart';
import 'package:provider/provider.dart';

import 'helpers/app_language.dart';
import 'helpers/router.dart';
import 'helpers/theme_preference.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider<BottomNavigationBarProvider>(create: (_) => BottomNavigationBarProvider())
    ],
    child: MyApp(appLanguage: appLanguage),
  ));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;
  final Future<FirebaseApp> firebaseApp = Firebase.initializeApp();

  MyApp({required this.appLanguage});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var isLight = true;
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    // appLanguage.setDefaultLanguage(context);
    return ChangeNotifierProvider<AppLanguage>(
        create: (_) => appLanguage,
        child: Consumer<AppLanguage>(builder: (context, model, child) {
          return MaterialApp(
            title: 'Haumea',
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''), // English, no country code
              const Locale('fr', ''), // French, no country code
            ],
            locale: model.appLocal,
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.getTheme(isLight),
            onGenerateRoute: DeepRouter.generateRoute,
            home: FutureBuilder(
              future: firebaseApp,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                print("test");
                print("test");
                print("test");
                print("test");
                if (snapshot.hasError) {
                  return Text('Error');
                } else if (snapshot.hasData) {
                  return HomePage(title: 'Haumea Magazine');
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        }));
  }
}
