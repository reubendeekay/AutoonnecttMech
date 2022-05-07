import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:mechanic_admin/auth/auth_screen.dart';
import 'package:mechanic_admin/chat/chat_room.dart';
import 'package:mechanic_admin/drawer/hidden_drawer.dart';
import 'package:mechanic_admin/firebase_options.dart';
import 'package:mechanic_admin/helpers/constants.dart';
import 'package:mechanic_admin/helpers/loading_screen.dart';
import 'package:mechanic_admin/providers/admin_user_provider.dart';
import 'package:mechanic_admin/providers/auth_provider.dart';
import 'package:mechanic_admin/providers/chat_provider.dart';
import 'package:mechanic_admin/providers/location_provider.dart';
import 'package:mechanic_admin/providers/mechanic_provider.dart';
import 'package:mechanic_admin/providers/payment_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const HidenDrawer();
  };
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: LocationProvider()),
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: ChatProvider()),
        ChangeNotifierProvider.value(value: MechanicProvider()),
        ChangeNotifierProvider.value(value: AdminUserProvider()),
        ChangeNotifierProvider.value(value: PaymentProvider()),
      ],
      child: GetMaterialApp(
        title: 'AutoConnect Mechanic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const InitialLoadingScreen();
              } else {
                return const AuthScreen();
              }
            }),
        routes: {
          ChatRoom.routeName: (context) => ChatRoom(),
        },
      ),
    );
  }
}
