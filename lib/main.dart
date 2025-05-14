import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:sufaweb/Presentation/admin/admin_screen.dart';
import 'package:sufaweb/Presentation/client/client_screen.dart';
import 'package:sufaweb/Router/Login.dart';
import 'package:sufaweb/Router/routes.dart';
import 'package:sufaweb/Widgets/PullToRefreshWrapper.dart';
import 'package:sufaweb/Widgets/RefreshWrapper.dart';
import 'package:sufaweb/Widgets/RestartWidget.dart';
import 'package:sufaweb/Widgets/connectivity_service.dart';
import 'package:sufaweb/Widgets/offline_screen.dart';
import 'package:sufaweb/Widgets/splash_screen.dart';
import 'package:sufaweb/env_loader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvLoader.loadEnv();

  bool hasConnection = await checkInternetConnection();

  if (hasConnection) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: EnvLoader.get('API_KEY')!,
        authDomain: EnvLoader.get('AUTH_DOMAIN')!,
        databaseURL: EnvLoader.get('DATABASE_URL')!,
        projectId: EnvLoader.get('PROJECT_ID')!,
        storageBucket: EnvLoader.get('STORAGE_BUCKET')!,
        messagingSenderId: EnvLoader.get('MESSAGING_SENDER_ID')!,
        appId: EnvLoader.get('APP_ID')!,
        measurementId: EnvLoader.get('MEASUREMENT_ID')!,
      ),
    );

    if (!kIsWeb) {
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
  }

  final pref = await SharedPreferences.getInstance();
  final seenOnboarding = pref.getBool('seenOnboarding') ?? false;

  runApp(RestartWidget(
    child: MyApp(
      seenOnboarding: seenOnboarding,
      isOnline: hasConnection,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final bool isOnline;

  const MyApp({
    super.key,
    this.seenOnboarding = false,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ));
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Azaktilsa',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color.fromARGB(255, 0, 0, 0),
          elevation: 0,
        ),
      ),
      home: RefreshWrapper(
        isOnline: isOnline,
        seenOnboarding: seenOnboarding,
      ),
      routes: routes,
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return FutureBuilder<DatabaseEvent>(
        future: FirebaseDatabase.instance
            .ref()
            .child('Empresas/TerrawaSufalyng/Control/')
            .child(user.uid)
            .once(),
        builder: (context, roleSnapshot) {
          if (roleSnapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(seenOnboarding: true);
          }

          if (roleSnapshot.hasError) {
            return const OfflineScreen();
          }

          if (!roleSnapshot.hasData ||
              roleSnapshot.data!.snapshot.value == null) {
            return const LoginScreen();
          }

          var userData =
              roleSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          String role = userData['role'] ?? '';

          if (role == 'Client') {
            return const PullToRefreshWrapper(child: ClientScreen());
          } else if (role == 'admin') {
            return const PullToRefreshWrapper(child: AdminScreen());
          } else {
            return const Center(
              child: Text(
                'Rol no reconocido.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              ),
            );
          }
        },
      );
    } else {
      return const LoginScreen();
    }
  }
}
