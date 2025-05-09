import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
// Remova o 'as AppRoutes' aqui, pois a importação já foi corrigida

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

    // Função para deletar o pet
    Future<void> _deletarPet() async {
      final petRef = FirebaseDatabase.instance.ref().child('pets').child(petId);
      await petRef.remove();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil do pet deletado com sucesso!')),
      );
      Navigator.pop(context); // Volta para a tela anterior
    }

    // Função para editar o pet
    Future<void> _navegarParaEditarPet() async {
      Navigator.pushNamed(
        context,
        '/editar-pet', // Corrige a rota para a tela de edição do pet
        arguments: petData, // Passa os dados do pet para a tela de edição
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
            // Exibe a imagem do pet (se houver)
            petData!['imagemPath'] != null
                ? Image.network(petData!['imagemPath'], height: 150, width: 200)
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
            // Botões para editar e deletar
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
