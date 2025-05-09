import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../navigation/app_routes.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  @override
  _CadastroUsuarioScreenState createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;
  String? _erro;

  Future<void> _criarConta() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text.trim(),
      );

      // Navega para a tela principal após o cadastro
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on FirebaseAuthException catch (e) {
      String mensagemErro;
      switch (e.code) {
        case 'email-already-in-use':
          mensagemErro = 'Este e-mail já está em uso.';
          break;
        case 'weak-password':
          mensagemErro = 'A senha precisa ter pelo menos 6 caracteres.';
          break;
        case 'invalid-email':
          mensagemErro = 'E-mail inválido.';
          break;
        default:
          mensagemErro = 'Erro: ${e.message}';
      }

      setState(() {
        _erro = mensagemErro;
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4A90E2),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Criar Conta",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: "Nome",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                ),
                if (_erro != null) ...[
                  SizedBox(height: 10),
                  Text(
                    _erro!,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _carregando ? null : _criarConta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                  ),
                  child: _carregando
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Cadastrar",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: Text(
                    "Já tem conta? Entrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
