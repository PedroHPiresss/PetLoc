import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petloc01/navigation/app_routes.dart';
import 'dart:typed_data';

class DesaparecidoScreen extends StatefulWidget {
  const DesaparecidoScreen({Key? key}) : super(key: key);

  @override
  _DesaparecidoScreenState createState() => _DesaparecidoScreenState();
}

class _DesaparecidoScreenState extends State<DesaparecidoScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _desaparecidos = [];

  Future<void> _loadDesaparecidos() async {
    final snapshot = await _firestore.collection('desaparecidos').get();
    setState(() {
      _desaparecidos = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'nome': data['nome'] ?? '',
          'descricao': data['descricao'] ?? '',
          'contato': data['contato'] ?? '',
          'imagem': data['imagem'] ?? '',
        };
      }).toList();
    });
  }

  Future<void> _deleteDesaparecido(String id) async {
    await _firestore.collection('desaparecidos').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro deletado com sucesso')),
    );
    _loadDesaparecidos();
  }

  @override
  void initState() {
    super.initState();
    _loadDesaparecidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FF),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
        title: Row(
          children: [
            Image.asset('assets/logo2.png', height: 40),
            const SizedBox(width: 12),
            const Text(
              'PET LOC',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        elevation: 6,
        shadowColor: Colors.blue.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: _desaparecidos.isEmpty
            ? Center(
                child: Text(
                  "Nenhum desaparecido encontrado",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _desaparecidos.length,
                itemBuilder: (context, index) {
                  final d = _desaparecidos[index];
                  return _buildDesaparecidoCard(
                    d['id'],
                    d['imagem'],
                    d['nome'],
                    d['descricao'],
                    d['contato'],
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 3,
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
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Criar'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Desaparecidos'),
        ],
      ),
    );
  }

  Widget _buildDesaparecidoCard(
      String id, String? imagemBase64, String nome, String descricao, String contato) {
    Widget imageWidget;

    if (imagemBase64 != null && imagemBase64.isNotEmpty) {
      try {
        Uint8List bytes = base64Decode(imagemBase64);
        imageWidget = ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Container(
            height: 180,
            width: double.infinity,
            color: Colors.grey[300],
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: Image.memory(bytes),
            ),
          ),
        );
      } catch (e) {
        imageWidget = _placeholderImage();
      }
    } else {
      imageWidget = _placeholderImage();
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget,
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 33, 54, 175)),
                    ),
                    const SizedBox(height: 6),
                    Text(descricao),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 18, color: Color.fromARGB(255, 92, 151, 253)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            contato,
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirmar exclusão'),
                    content: const Text('Deseja realmente deletar este registro?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _deleteDesaparecido(id);
                        },
                        child: const Text('Deletar'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
        height: 180,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
      ),
    );
  }
}
