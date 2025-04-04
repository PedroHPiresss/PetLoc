// lib/navigation/app_routes.dart

import 'package:flutter/material.dart';

// Importando as telas
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/loja.dart';
import '../screens/desaparecido.dart';
// Importe suas outras telas aqui quando for necessário

class AppRoutes {
  // Definição das rotas nomeadas
  static const String home = '/home';
  static const String login = '/login';
  static const String loja = '/loja';
  static const String desaparecido = '/desaparecido';
  // Defina as rotas para outras telas
}

// Função para gerar as rotas
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case AppRoutes.loja:
      return MaterialPageRoute(builder: (_) => LojaScreen());
    case AppRoutes.desaparecido:
      return MaterialPageRoute(builder: (_) => DesaparecidoScreen());
    // Adicione mais casos conforme necessário
    default:
      return MaterialPageRoute(builder: (_) => HomeScreen());  // Rota padrão
  }
}
