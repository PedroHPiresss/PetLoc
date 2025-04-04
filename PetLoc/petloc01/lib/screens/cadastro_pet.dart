import 'package:flutter/material.dart';

class CadastroPetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo2.png', height: 40),
            SizedBox(width: 10),
            Text("Cadastrar PET"),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Cadastrar PET",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              width: 200,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text("Carregar Imagem"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 92, 151, 253),
              ),
            ),
            SizedBox(height: 20),
            _buildInputField("Nome:", "Digite Aqui"),
            SizedBox(height: 10),
            _buildInputField("Descrição:", "Digite Aqui", maxLines: 3),
            SizedBox(height: 10),
            _buildInputField("Contato:", "Digite Aqui"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Cadastrar PET"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 92, 151, 253),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lista'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Loja'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Pets'),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextField(
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
