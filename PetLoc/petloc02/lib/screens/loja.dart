import 'package:flutter/material.dart';
import '../navigation/app_routes.dart'; // Importação das rotas

class LojaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Loja PetLoc"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "Página da Loja em Construção...",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 2, // Loja está ativa
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.criarDesaparecido);
              break;
            case 2:
              // Já está na loja
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.desaparecido);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
        ],
      ),
    );
  }
}
