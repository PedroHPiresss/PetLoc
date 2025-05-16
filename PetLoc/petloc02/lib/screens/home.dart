import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../navigation/app_routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _petsRef = FirebaseDatabase.instance.ref('pets');
  List<Map<String, dynamic>> _pets = [];

  @override
  void initState() {
    super.initState();
    _carregarPets();
  }

  void _carregarPets() {
    _petsRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        final petsMap = Map<String, dynamic>.from(data as Map);
        final petsList = petsMap.entries.map((entry) {
          final petData = Map<String, dynamic>.from(entry.value);
          return {
            'id': entry.key,
            'nome': petData['nome'] ?? '',
            'descricao': petData['descricao'] ?? '',
            'contato': petData['contato'] ?? '',
            'imagemPath': petData['imagemPath'] ?? '',
          };
        }).toList();

        // Limitar a 4 pets para exibir
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
          // Faixa azul fixa
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
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
                  style: TextStyle(fontSize: 20, color: Colors.white70),
                ),
                SizedBox(height: 30),

                // Linha horizontal com as miniaturas dos pets + botão adicionar
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
                          child: Icon(
                            Icons.add,
                            color: Colors.blueAccent,
                            size: 40,
                          ),
                        ),
                      ),

                      SizedBox(width: 20),

                      // Miniaturas dos pets cadastrados
                      ..._pets.map((pet) {
                        // Decodifica a imagem base64
                        final String base64Str = pet['imagemPath'] ?? '';
                        Widget avatar;

                        if (base64Str.isNotEmpty) {
                          try {
                            final decodedBytes = base64Decode(base64Str);
                            avatar = CircleAvatar(
                              radius: 40,
                              backgroundImage: MemoryImage(decodedBytes),
                            );
                          } catch (e) {
                            // Se falhar no decode, exibe um ícone padrão
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
                              avatar,
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
            case 0:
              // Já na home
              break;
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
