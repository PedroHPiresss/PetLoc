import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para interagir com o Firebase Firestore
import 'package:image_picker/image_picker.dart'; // Para escolher a imagem da galeria
import 'dart:io'; // Para usar File
import '../navigation/app_routes.dart'; // Importando as rotas

class CriarDesaparecidoScreen extends StatefulWidget {
  @override
  _CriarDesaparecidoScreenState createState() => _CriarDesaparecidoScreenState();
}

class _CriarDesaparecidoScreenState extends State<CriarDesaparecidoScreen> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _contatoController = TextEditingController();
  final _imagePicker = ImagePicker();
  XFile? _imageFile;

  // Função para selecionar uma imagem da galeria
  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = pickedFile;
      }
    });
  }

  // Função para salvar os dados no Firebase Firestore
  Future<void> _saveData() async {
    if (_imageFile != null && _nomeController.text.isNotEmpty && _descricaoController.text.isNotEmpty && _contatoController.text.isNotEmpty) {
      try {
        // Caso tenha imagem, podemos salvar um caminho local ou uma URL pública.
        // No caso, estamos assumindo que você já tem uma URL pública da imagem ou pode salvar como caminho local.
        
        final imageUrl = _imageFile != null ? _imageFile!.path : ''; // Usando o caminho local da imagem

        // Salvar os dados no Firebase Firestore
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('desaparecidos').add({
          'nome': _nomeController.text,
          'descricao': _descricaoController.text,
          'contato': _contatoController.text,
          'imagem': imageUrl, // Salvando o caminho da imagem ou URL
        });

        // Limpar os campos após salvar
        _nomeController.clear();
        _descricaoController.clear();
        _contatoController.clear();
        setState(() {
          _imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Animal desaparecido salvo com sucesso!')));

        // Opcional: Navegar para a lista de desaparecidos após o sucesso
        Navigator.pushReplacementNamed(context, AppRoutes.desaparecido);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar os dados: $error')));
      }
    } else {
      // Caso não tenha imagem ou campos vazios
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, preencha todos os campos e selecione uma imagem!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 92, 151, 253),
        title: Row(
          children: [
            Image.asset('assets/logo2.png', height: 40),
            const SizedBox(width: 10),
            const Text('PET LOC'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {}, // Ainda sem ação
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageFile == null
                    ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[700])
                    : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contatoController,
              decoration: const InputDecoration(
                labelText: 'Contato',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 1, // Índice da aba atual
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              // Já está na tela de criar desaparecido
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.loja);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.desaparecido);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Criar Desaparecido'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
        ],
      ),
    );
  }
}
