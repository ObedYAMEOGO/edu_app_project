import 'dart:async';

import 'package:edu_app_project/core/common/app/providers/course_of_the_day_notifier.dart';
import 'package:edu_app_project/core/common/app/providers/message_reply_notifier.dart';
import 'package:edu_app_project/core/common/app/providers/notifications_notifier.dart';
import 'package:edu_app_project/core/common/app/providers/user_provider.dart';
import 'package:edu_app_project/core/res/colours.dart';
import 'package:edu_app_project/core/res/fonts.dart';
import 'package:edu_app_project/core/services/injection_container.dart';
import 'package:edu_app_project/core/services/router.dart';
import 'package:edu_app_project/firebase_options.dart';
import 'package:edu_app_project/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:edu_app_project/src/on_boarding/presentation/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_links/app_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('fr_FR', null);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLink();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _initDeepLink() async {
    _appLinks = AppLinks();

    try {
      // Handle initial deep link (cold start)
      final Uri? initialUri = await _appLinks!.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri.toString());
      }

      // Listen for deep links while app is running
      _sub = _appLinks!.uriLinkStream.listen((Uri uri) {
        _handleDeepLink(uri.toString());
      });
    } catch (e) {
      print("Erreur deep link : $e");
    }
  }

  void _handleDeepLink(String link) {
    print("Lien reçu : $link");

    if (link == "https://unilink-sever.vercel.app") {
      print("Redirection réussie !");
      // 👉 Here you can navigate inside your app
      // Navigator.pushNamed(context, SomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => CourseOfTheDayNotifier()),
        ChangeNotifierProvider(create: (_) => MessageReplyNotifier()),
        ChangeNotifierProvider(
          create: (_) => NotificationsNotifier(sl<SharedPreferences>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eduritio',
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: Fonts.merriweather,
          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
          ),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: Colours.primaryColour,
          ),
        ),
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
