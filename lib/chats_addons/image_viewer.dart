// chats_addons/image_viewer.dart

import 'package:flutter/material.dart';

void showImageFullScreen(BuildContext context, String imageUrl) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Permite que el modal ocupe casi toda la pantalla
    backgroundColor: Colors.transparent, // Fondo transparente
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.9, // 90% de la pantalla
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
            // Imagen en tamaño completo
            Expanded(
              child: InteractiveViewer(
                panEnabled: true, // Permite mover la imagen
                minScale: 1.0, // Escala mínima
                maxScale: 3.0, // Escala máxima (zoom)
                child: Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain, // Ajusta la imagen al contenedor
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}