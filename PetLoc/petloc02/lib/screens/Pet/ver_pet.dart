import 'dart:convert'; // Para Base64Decoder
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class VerPetScreen extends StatelessWidget {
  final Map<String, dynamic>? petData;
  final String petId;

  const VerPetScreen({Key? key, this.petData, required this.petId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (petData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Erro')),
        body: Center(child: Text('Erro: Dados do pet não foram encontrados.')),
      );
    }

    Future<void> _deletarPet() async {
      final petRef = FirebaseDatabase.instance.ref().child('pets').child(petId);
      await petRef.remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil do pet deletado com sucesso!')),
      );
      Navigator.pop(context);
    }

    Future<void> _navegarParaEditarPet() async {
      Navigator.pushNamed(
        context,
        '/editar-pet',
        arguments: petData,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(petData!['nome'] ?? 'Detalhes do Pet'),
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            petData!['imagemBase64'] != null && petData!['imagemBase64'].isNotEmpty
                ? Image.memory(
                    Base64Decoder().convert(petData!['imagemBase64']),
                    height: 150,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image, size: 100),
            SizedBox(height: 20),
            Text(
              petData!['nome'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(petData!['descricao'] ?? ''),
            SizedBox(height: 10),
            Text('Contato: ${petData!['contato'] ?? ''}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _deletarPet,
                  child: Text("Deletar Perfil"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: _navegarParaEditarPet,
                  child: Text("Editar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 92, 151, 253),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
