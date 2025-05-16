import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

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

  String? _imagemBase64;
  File? _imagemNova;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.petData['nome']);
    _descricaoController = TextEditingController(text: widget.petData['descricao']);
    _contatoController = TextEditingController(text: widget.petData['contato']);
    _imagemBase64 = widget.petData['imagemBase64'];
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _contatoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarNovaImagem() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagemNova = File(pickedFile.path);
      });
    }
  }

  Future<void> _salvarEdicoes() async {
    final database = FirebaseDatabase.instance.ref();
    final petRef = database.child('pets').child(widget.petData['id']);

    String? imagemBase64ParaSalvar = _imagemBase64;

    if (_imagemNova != null) {
      final bytes = await _imagemNova!.readAsBytes();
      imagemBase64ParaSalvar = base64Encode(bytes);
    }

    await petRef.update({
      'nome': _nomeController.text,
      'descricao': _descricaoController.text,
      'contato': _contatoController.text,
      'imagemBase64': imagemBase64ParaSalvar ?? '',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pet editado com sucesso!')),
    );

    Navigator.pop(context);
  }

  Widget _exibirImagem() {
    if (_imagemNova != null) {
      return Image.file(_imagemNova!, height: 150, width: 200, fit: BoxFit.cover);
    } else if (_imagemBase64 != null && _imagemBase64!.isNotEmpty) {
      try {
        final bytes = base64Decode(_imagemBase64!);
        return Image.memory(bytes, height: 150, width: 200, fit: BoxFit.cover);
      } catch (e) {
        // Se a decodificação falhar, mostrar ícone padrão
        return _iconeImagemPadrao();
      }
    } else {
      return _iconeImagemPadrao();
    }
  }

  Widget _iconeImagemPadrao() {
    return Container(
      height: 150,
      width: 200,
      color: Colors.grey[300],
      child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
    );
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _exibirImagem(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selecionarNovaImagem,
                child: Text('Trocar Imagem'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 92, 151, 253),
                ),
              ),
              SizedBox(height: 20),
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
              Center(
                child: ElevatedButton(
                  onPressed: _salvarEdicoes,
                  child: Text("Salvar Alterações"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 92, 151, 253),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
