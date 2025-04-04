import 'package:flutter/material.dart';

// Importando as telas
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/loja.dart';
import '../screens/desaparecido.dart';
import '../screens/cadastro_pet.dart'; // Nova tela

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String loja = '/loja';
  static const String desaparecido = '/desaparecido';
  static const String cadastroPet = '/cadastro_pet'; // Nova rota
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
    case AppRoutes.cadastroPet:
      return MaterialPageRoute(builder: (_) => CadastroPetScreen()); // Nova tela
    default:
      return MaterialPageRoute(builder: (_) => HomeScreen()); // Rota padrão
  }
}
