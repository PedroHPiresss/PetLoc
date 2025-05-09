import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../navigation/app_routes.dart';

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
                'imagemPath': petData['imagemPath'] ?? '',
              };
            }).toList();

            return ListView.builder(
              itemCount: petsList.length,
              itemBuilder: (context, index) {
                final pet = petsList[index];
                return Card(
                  margin: EdgeInsets.all(12),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.pets, size: 40),
                    title: Text(pet['nome']),
                    subtitle: Text(pet['descricao']),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.verPet,
                        arguments: pet,
                      );
                    },
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
