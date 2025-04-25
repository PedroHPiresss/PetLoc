import 'package:flutter/material.dart';
import '../navigation/app_routes.dart';

class CriarDesaparecidoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
        title: Row(
          children: [
            Image.asset('assets/logo2.png', height: 40),
            const SizedBox(width: 10),
            const Text('PET LOC'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {}, // Ainda sem ação
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.camera_alt, size: 50, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Contato',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Ação de salvar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 1, // Índice da aba atual
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              // Já está na tela de criar desaparecido
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.loja);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.desaparecido);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Criar Desaparecido'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
        ],
      ),
    );
  }
}
