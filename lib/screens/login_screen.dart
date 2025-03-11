import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Chat/utils/animations.dart';
import '../data/bg_data.dart';
import '../utils/text_utils.dart';
import 'chat_screen.dart'; // Asegúrate de importar la pantalla de chat

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int selectedIndex = 0;
  bool showOption = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Map<String, String> users = {
    "Gabriel": "1234",
    "Jandy": "kiki",
  };

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (users.containsKey(email) && users[email] == password) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(username: email)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario o contraseña incorrectos")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600; // Detectar si es PC

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo cubriendo toda la pantalla
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg', // Asegúrate de que el archivo está en la carpeta assets
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Container(
              constraints: isDesktop
                  ? BoxConstraints(maxWidth: 600) // Limitar el ancho en PC
                  : null, // Sin restricciones en móvil
              child: Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: Container(
                  height: 400,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Center(
                              child: TextUtil(
                                text: "Login",
                                weight: true,
                                size: 30,
                              ),
                            ),
                            const Spacer(),
                            TextUtil(text: "Usuario"),
                            Container(
                              height: 35,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.white),
                                ),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.mail, color: Colors.white),
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextUtil(text: "Contraseña"),
                            Container(
                              height: 35,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.white),
                                ),
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  suffixIcon: Icon(Icons.lock, color: Colors.white),
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: _login,
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                alignment: Alignment.center,
                                child: TextUtil(
                                  text: "Iniciar sesión",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
