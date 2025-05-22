import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../navigation/app_routes.dart';

class LojaScreen extends StatefulWidget {
  @override
  _LojaScreenState createState() => _LojaScreenState();
}

class _LojaScreenState extends State<LojaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _produtos = [];

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    final snapshot = await _firestore
        .collection('produtos_loja')
        .orderBy('criadoEm', descending: true)
        .get();
    setState(() {
      _produtos = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'nome': data['nome'] ?? '',
          'descricao': data['descricao'] ?? '',
          'preco': data['preco'] ?? '',
          'contato': data['contato'] ?? '',
          'imagem': data['imagem'] ?? '',
        };
      }).toList();
    });
  }

  Widget _buildCard(Map<String, dynamic> produto) {
    Uint8List? imageBytes;
    if (produto['imagem'] != null && produto['imagem'].isNotEmpty) {
      try {
        imageBytes = base64Decode(produto['imagem']);
      } catch (e) {
        imageBytes = null;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 130,
              color: Colors.grey[200],
              child: imageBytes != null
                  ? FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      child: Image.memory(imageBytes),
                    )
                  : const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  produto['nome'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "R\$ ${produto['preco']}",
                  style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.comprarLoja,
                        arguments: produto,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Comprar"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 51, 140, 229),
        title: const Text("Loja PetLoc",
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 4,
      ),
      body: _produtos.isEmpty
          ? const Center(child: Text("Nenhum produto disponível."))
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: _produtos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 por linha
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9, // ⬅️ ajuste feito aqui (menos vertical)
                ),
                itemBuilder: (context, index) => _buildCard(_produtos[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 39, 134, 228),
        tooltip: 'Adicionar Produto',
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.cadastroLoja);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(
                  context, AppRoutes.criarDesaparecido);
              break;
            case 2:
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.desaparecido);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
        ],
      ),
    );
  }
}
