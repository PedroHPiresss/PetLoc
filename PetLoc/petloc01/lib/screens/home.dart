import 'package:flutter/material.dart';
import '../navigation/app_routes.dart'; // Importação corrigida

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
        title: Row(
          children: [
            Image.asset('assets/logo2.png', height: 40),
            SizedBox(width: 10),
            Text('PET LOC'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá Visitante',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Seja Bem-Vindo',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Icon(Icons.add, color: Colors.blueAccent, size: 40),
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/arya.webp'),
                          radius: 40,
                        ),
                        Text('Arya', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                    SizedBox(width: 30),
                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/leo.jpg'),
                          radius: 40,
                        ),
                        Text('Leo', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              children: [
                _buildCard(
                  Icons.person_add, 
                  'Cadastre-se', 
                  'Venha fazer parte dessa comunidade!',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                ),
                _buildCard(
                  Icons.shopping_bag, 
                  'Shopping', 
                  'Conheça nossos produtos!',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.loja);
                  },
                ),
                _buildCard(Icons.pets, 'Meus Pets', 'Cadastre seu pet aqui!'),
                _buildCard(
                  Icons.report, 
                  'Animais Desaparecidos', 
                  'Veja os pets que estão perdidos!',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.desaparecido);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 0, // Home está ativa
        onTap: (index) {
          switch (index) {
            case 0:
              // Já está na home, então não faz nada
              break;
            case 1:
              // Adicione aqui uma tela correspondente se existir
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.loja);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.desaparecido);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 50),
              SizedBox(height: 15),
              Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 8),
              Text(subtitle, style: TextStyle(color: Colors.white70, fontSize: 14), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
