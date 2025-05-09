import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditarPetScreen extends StatefulWidget {
  final Map<String, dynamic> petData;

  EditarPetScreen({required this.petData});

  @override
  _EditarPetScreenState createState() => _EditarPetScreenState();
}

class _EditarPetScreenState extends State<EditarPetScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  late TextEditingController _contatoController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.petData['nome']);
    _descricaoController = TextEditingController(text: widget.petData['descricao']);
    _contatoController = TextEditingController(text: widget.petData['contato']);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _contatoController.dispose();
    super.dispose();
  }

  // Função para salvar as edições no Firebase
  Future<void> _salvarEdicoes() async {
    final database = FirebaseDatabase.instance.ref();
    final petRef = database.child('pets').child(widget.petData['id']); // Usar o ID do pet para atualizar

    // Atualiza os dados no Firebase
    await petRef.update({
      'nome': _nomeController.text,
      'descricao': _descricaoController.text,
      'contato': _contatoController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pet editado com sucesso!')),
    );

    // Voltar para a tela anterior após salvar
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil do Pet'),
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nome:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                hintText: "Digite o nome do pet",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
            SizedBox(height: 10),
            Text("Descrição:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                hintText: "Digite a descrição do pet",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[300],
              ),
              maxLines: 4,
            ),
            SizedBox(height: 10),
            Text("Contato:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _contatoController,
              decoration: InputDecoration(
                hintText: "Digite o contato do pet",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarEdicoes,
              child: Text("Salvar Alterações"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 92, 151, 253),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
