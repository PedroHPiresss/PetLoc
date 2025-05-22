import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Import necessário
import '../navigation/app_routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _petsRef = FirebaseDatabase.instance.ref('pets');
  List<Map<String, dynamic>> _pets = [];

  String _nomeUsuario = 'Visitante';  // Nome padrão antes do login

  @override
  void initState() {
    super.initState();
    _carregarPets();
    _carregarNomeUsuario();
  }

  void _carregarPets() {
    _petsRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final petsMap = Map<String, dynamic>.from(data);
        final petsList = petsMap.entries.map((entry) {
          final petData = entry.value is Map
              ? Map<String, dynamic>.from(entry.value)
              : <String, dynamic>{};
          return {
            'id': entry.key,
            'nome': petData['nome'] ?? '',
            'descricao': petData['descricao'] ?? '',
            'contato': petData['contato'] ?? '',
            'imagemBase64': petData['imagemBase64'] ?? '',
          };
        }).toList();

        setState(() {
          _pets = petsList.take(4).toList();
        });
      } else {
        setState(() {
          _pets = [];
        });
      }
    });
  }

  void _carregarNomeUsuario() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      if (user != null && user.displayName != null && user.displayName!.isNotEmpty) {
        _nomeUsuario = user.displayName!;
      } else if (user != null && user.email != null) {
        // Se o nome não estiver setado, mostrar parte do email como fallback
        _nomeUsuario = user.email!.split('@')[0];
      } else {
        _nomeUsuario = 'Visitante';
      }
    });
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
        actions: [IconButton(icon: Icon(Icons.menu), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Faixa azul fixa com nome e miniaturas
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá $_nomeUsuario',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Seja Bem-Vindo',
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                SizedBox(height: 30),

                // Linha com botão + pets
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Botão de adicionar pet
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.cadastroPet);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 40,
                          child: Icon(Icons.add, color: Colors.blueAccent, size: 40),
                        ),
                      ),
                      SizedBox(width: 20),

                      // Miniaturas dos pets cadastrados com navegação para detalhes
                      ..._pets.map((pet) {
                        final dynamic base64Data = pet['imagemBase64'];
                        Widget avatar;

                        if (base64Data != null && base64Data is String && base64Data.isNotEmpty) {
                          try {
                            final decodedBytes = base64Decode(base64Data);
                            avatar = CircleAvatar(
                              radius: 40,
                              backgroundImage: MemoryImage(decodedBytes),
                            );
                          } catch (_) {
                            avatar = CircleAvatar(
                              radius: 40,
                              child: Icon(Icons.pets, size: 40),
                            );
                          }
                        } else {
                          avatar = CircleAvatar(
                            radius: 40,
                            child: Icon(Icons.pets, size: 40),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.verPet,
                                    arguments: pet,
                                  );
                                },
                                child: avatar,
                              ),
                              SizedBox(height: 6),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  pet['nome'],
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 50),

          // Grade com botões de navegação
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
                _buildCard(
                  Icons.pets,
                  'Meus Pets',
                  'Cadastre seu pet aqui!',
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.menuPet);
                  },
                ),
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
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.criarDesaparecido);
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

  Widget _buildCard(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
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
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
