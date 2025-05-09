import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para interagir com o Firebase Firestore
import '../navigation/app_routes.dart'; // Importação corrigida

class DesaparecidoScreen extends StatefulWidget {
  @override
  _DesaparecidoScreenState createState() => _DesaparecidoScreenState();
}

class _DesaparecidoScreenState extends State<DesaparecidoScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _desaparecidos = [];

  // Função para carregar os dados de desaparecidos do Firebase Firestore
  Future<void> _loadDesaparecidos() async {
    final snapshot = await _firestore.collection('desaparecidos').get();
    setState(() {
      _desaparecidos = snapshot.docs.map((doc) {
        return {
          'nome': doc['nome'],
          'descricao': doc['descricao'],
          'contato': doc['contato'],
          'imagem': doc['imagem'],
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDesaparecidos(); // Carregar os desaparecidos quando a tela for carregada
  }

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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _desaparecidos.isEmpty
            ? Center(child: Text("Nenhum desaparecido encontrado"))
            : ListView.builder(
                itemCount: _desaparecidos.length,
                itemBuilder: (context, index) {
                  final desaparecido = _desaparecidos[index];
                  return _buildDesaparecidoCard(
                    desaparecido['imagem'],
                    desaparecido['nome'],
                    desaparecido['descricao'],
                    desaparecido['contato'],
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 3, // Define a posição correta do menu
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.criarDesaparecido);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.loja);
              break;
            case 3:
              // Já está na tela de desaparecidos, então nada acontece
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Desaparecidos'),
        ],
      ),
    );
  }

  Widget _buildDesaparecidoCard(String imageUrl, String title, String description, String phone) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: imageUrl.isNotEmpty
                ? Image.network(imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover)
                : Icon(Icons.image, size: 150, color: Colors.grey[300]),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(description),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.blueAccent),
                    SizedBox(width: 5),
                    Text(phone),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
