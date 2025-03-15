// chats_addons/message_options.dart

import 'package:Chat/models/message.dart';
import 'package:flutter/material.dart';

void showMessageOptions(BuildContext context, Message message, Function() onReply, Function() onCopy, Function()? onDelete) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.reply, color: Colors.blue),
              title: Text("Responder"),
              onTap: () {
                Navigator.pop(context); // Cerrar el modal
                onReply(); // Ejecutar la acción de responder
              },
            ),
            ListTile(
              leading: Icon(Icons.copy, color: Colors.blue),
              title: Text("Copiar"),
              onTap: () {
                Navigator.pop(context); // Cerrar el modal
                onCopy(); // Ejecutar la acción de copiar
              },
            ),
            if (onDelete != null) // Mostrar la opción de eliminar solo si está disponible
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Eliminar"),
                onTap: () {
                  Navigator.pop(context); // Cerrar el modal
                  onDelete(); // Ejecutar la acción de eliminar
                },
              ),
          ],
        ),
      );
    },
  );
}