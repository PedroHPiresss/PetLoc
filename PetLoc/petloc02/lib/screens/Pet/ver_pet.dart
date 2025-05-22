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
      backgroundColor: Color(0xFFF2F7FF),
      appBar: AppBar(
        title: Text(petData!['nome'] ?? 'Detalhes do Pet'),
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagem ajustada sem sombra, só borda suave
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade100, width: 2),
              ),
              clipBehavior: Clip.hardEdge,
              height: 250,
              width: double.infinity,
              child: petData!['imagemBase64'] != null && petData!['imagemBase64'].isNotEmpty
                  ? Image.memory(
                      base64Decode(petData!['imagemBase64']),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.pets, size: 120, color: Colors.grey[700]),
                    ),
            ),
            SizedBox(height: 30),

            // Card com detalhes do pet (sem alteração)
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Icon(
                        Icons.pets,
                        size: 50,
                        color: Color.fromARGB(255, 92, 151, 253),
                      ),
                    ),
                    SizedBox(height: 20),

                    Center(
                      child: Text(
                        petData!['nome'] ?? '',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 33, 54, 175),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 16),

                    Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 6),

                    Text(
                      petData!['descricao'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Contato',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(Icons.contact_phone, color: Colors.blue[700]),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            petData!['contato'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 40),

            // Botões (sem alteração)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _deletarPet,
                  icon: Icon(Icons.delete, size: 20),
                  label: Text("Deletar Perfil"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _navegarParaEditarPet,
                  icon: Icon(Icons.edit, size: 20),
                  label: Text("Editar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 92, 151, 253),
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
