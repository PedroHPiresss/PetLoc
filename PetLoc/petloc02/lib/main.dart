import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'navigation/app_routes.dart'; // Correto agora

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Loc',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      onGenerateRoute: generateRoute,
    );
  }
}
