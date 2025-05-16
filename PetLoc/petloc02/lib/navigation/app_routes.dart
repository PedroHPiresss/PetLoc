import 'package:flutter/material.dart';
import 'package:petloc01/screens/cadastro/login/cadastro.dart';

// Importando as telas
import '../screens/home.dart';
import '../screens/cadastro/login/login.dart';
import '../screens/loja/loja.dart';
import '../screens/loja/cadastro_loja.dart';    // nova tela cadastro loja
import '../screens/loja/comprar_loja.dart';     // nova tela comprar loja
import '../screens/Desaparecidos/desaparecido.dart';
import '../screens/Desaparecidos/criar_desaparecido.dart';
import '../screens/Pet/cadastro_pet.dart';
import '../screens/Pet/menu_pet.dart'; // <- Novo
import '../screens/Pet/ver_pet.dart';  // <- Novo
import '../screens/Pet/editar_pet.dart'; // <- Novo

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String loja = '/loja';
  static const String cadastroLoja = '/cadastro_loja';       // nova
  static const String comprarLoja = '/comprar_loja';         // nova
  static const String desaparecido = '/desaparecido';
  static const String cadastroPet = '/cadastro_pet';
  static const String criarDesaparecido = '/criar_desaparecido';
  static const String cadastroUsuario = '/cadastro_usuario';
  static const String menuPet = '/menu_pet';     // <- Novo
  static const String verPet = '/ver-pet';       // <- Novo
  static const String editarPet = '/editar-pet'; // <- Novo
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => HomeScreen());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
    case AppRoutes.loja:
      return MaterialPageRoute(builder: (_) => LojaScreen());
    case AppRoutes.cadastroLoja:
      return MaterialPageRoute(builder: (_) => CadastroLojaScreen());
    case AppRoutes.comprarLoja:
      final produto = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(builder: (_) => ComprarLojaScreen(produto: produto));
    case AppRoutes.desaparecido:
      return MaterialPageRoute(builder: (_) => DesaparecidoScreen());
    case AppRoutes.cadastroPet:
      return MaterialPageRoute(builder: (_) => CadastroPetScreen());
    case AppRoutes.criarDesaparecido:
      return MaterialPageRoute(builder: (_) => CriarDesaparecidoScreen());
    case AppRoutes.cadastroUsuario:
      return MaterialPageRoute(builder: (_) => CadastroUsuarioScreen());
    case AppRoutes.menuPet:
      return MaterialPageRoute(builder: (_) => MenuPetScreen());     // <- Novo
    case AppRoutes.verPet:
      final petData = settings.arguments as Map<String, dynamic>?; // <- extrai os argumentos
      return MaterialPageRoute(builder: (_) => VerPetScreen(petData: petData!, petId: petData['id'])); // Passa o petId
    case AppRoutes.editarPet:
      final petData = settings.arguments as Map<String, dynamic>?; // Extrai os dados do pet
      return MaterialPageRoute(builder: (_) => EditarPetScreen(petData: petData!)); // Passa os dados para editar

    default:
      return MaterialPageRoute(builder: (_) => HomeScreen());
  }
}
