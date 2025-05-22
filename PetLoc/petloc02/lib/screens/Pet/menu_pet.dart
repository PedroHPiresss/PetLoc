import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../navigation/app_routes.dart';

class MenuPetScreen extends StatefulWidget {
  @override
  _MenuPetScreenState createState() => _MenuPetScreenState();
}

class _MenuPetScreenState extends State<MenuPetScreen> {
  final DatabaseReference _petsRef = FirebaseDatabase.instance.ref('pets');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pets'),
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _petsRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            final petsMap = Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as Map,
            );

            final petsList = petsMap.entries.map((entry) {
              final petData = Map<String, dynamic>.from(entry.value);
              return {
                'id': entry.key,
                'nome': petData['nome'] ?? '',
                'descricao': petData['descricao'] ?? '',
                'contato': petData['contato'] ?? '',
                'imagemBase64': petData['imagemBase64'] ?? '',
              };
            }).toList();

            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: petsList.length,
              itemBuilder: (context, index) {
                final pet = petsList[index];

                Widget imagemMiniatura;
                if (pet['imagemBase64'] != null && pet['imagemBase64'].isNotEmpty) {
                  try {
                    imagemMiniatura = ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        base64Decode(pet['imagemBase64']),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  } catch (e) {
                    imagemMiniatura = Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.pets, size: 50, color: Colors.grey[700]),
                    );
                  }
                } else {
                  imagemMiniatura = Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.pets, size: 50, color: Colors.grey[700]),
                  );
                }

                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.blueAccent.withOpacity(0.2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.verPet,
                        arguments: pet,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          imagemMiniatura,
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet['nome'],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 33, 54, 175),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  pet['descricao'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.contact_phone, size: 16, color: Colors.blue),
                                    SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        pet['contato'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar pets.'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.cadastroPet);
        },
        child: Icon(Icons.add),
        tooltip: 'Cadastrar novo pet',
      ),
    );
  }
}
