import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart'; // Importar o pacote
import 'dart:io'; // Para manipular arquivos de imagem
import '../navigation/app_routes.dart';

class CadastroPetScreen extends StatefulWidget {
  @override
  _CadastroPetScreenState createState() => _CadastroPetScreenState();
}

class _CadastroPetScreenState extends State<CadastroPetScreen> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _contatoController = TextEditingController();
  File? _image;  // Variável para armazenar a imagem selecionada
  final ImagePicker _picker = ImagePicker(); // Instância do ImagePicker

  // Função para selecionar a imagem da galeria ou tirar uma foto
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Você pode usar ImageSource.camera para tirar foto
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Armazenar a imagem selecionada
      });
    }
  }

  Future<void> _salvarPet() async {
    final database = FirebaseDatabase.instance.ref();
    final novoPet = database.child('pets').push(); // /pets/{id}

    // Enviar dados para o Firebase
    await novoPet.set({
      'nome': _nomeController.text,
      'descricao': _descricaoController.text,
      'contato': _contatoController.text,
      'imagemPath': _image?.path ?? 'imagem_local.jpg', // Adiciona o caminho da imagem
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pet cadastrado com sucesso!')),
    );

    _nomeController.clear();
    _descricaoController.clear();
    _contatoController.clear();
    setState(() {
      _image = null; // Limpar a imagem após cadastro
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
            Text("Cadastrar PET"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text("Cadastrar PET", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              // Exibir a imagem ou ícone se não houver imagem
              _image == null
                  ? Container(
                      height: 150,
                      width: 200,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                    )
                  : Image.file(_image!, height: 150, width: 200, fit: BoxFit.cover),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage, // Chama a função para carregar a imagem
                child: Text("Carregar Imagem"),
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 92, 151, 253)),
              ),
              SizedBox(height: 20),
              _buildInputField("Nome:", "Digite Aqui", controller: _nomeController),
              SizedBox(height: 10),
              _buildInputField("Descrição:", "Digite Aqui", controller: _descricaoController, maxLines: 3),
              SizedBox(height: 10),
              _buildInputField("Contato:", "Digite Aqui", controller: _contatoController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarPet,
                child: Text("Cadastrar PET"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 92, 151, 253),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.criarDesaparecido);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, AppRoutes.loja);
              break;
            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.menuPet); // <- ir para lista de pets
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: ''),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint,
      {required TextEditingController controller, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
