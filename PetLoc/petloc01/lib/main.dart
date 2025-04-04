// lib/main.dart
import 'package:flutter/material.dart';
import 'navigation/app_routes.dart'; // Importando as rotas nomeadas

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home, // Define a rota inicial
      onGenerateRoute: generateRoute, // Usa a função de rotas geradas
    );
  }
}
