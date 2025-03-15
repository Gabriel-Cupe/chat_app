// chats_addons/reply_viewer.dart

import 'package:flutter/material.dart';
import '../models/message.dart';

void showReplyFullScreen(BuildContext context, Message message) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Permite que el modal ocupe casi toda la pantalla
    backgroundColor: Colors.transparent, // Fondo transparente
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5, // 50% de la pantalla
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9), // Fondo oscuro
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Botón para cerrar el modal
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // Mensaje completo
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mensaje de ${message.sender}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (message.imageUrl != null) // Mostrar la imagen si existe
                      Image.network(
                        message.imageUrl!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    if (message.text.isNotEmpty) // Mostrar el texto si existe
                      Text(
                        message.text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}