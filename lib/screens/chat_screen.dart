import 'package:Chat/chats_addons/reply_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para Clipboard
import '../services/firebase_service.dart';
import '../models/message.dart';
import 'package:Chat/chats_addons/emoji_picker_addon.dart';
import 'package:Chat/chats_addons/image_picker_addon.dart';
import 'package:Chat/chats_addons/image_viewer.dart';
import 'package:Chat/chats_addons/message_options.dart'; // Para el menú contextual

class ChatScreen extends StatefulWidget {
  final String username;
  const ChatScreen({super.key, required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin{
  final TextEditingController _messageController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode(); // Para manejar el foco del teclado

  // Variables para manejar la respuesta a un mensaje
  Message? _replyingToMessage;
void _sendMessage() {
  if (_messageController.text.isNotEmpty) {
    Message message = Message(
      sender: widget.username,
      text: _messageController.text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      replyTo: _replyingToMessage, // Mensaje al que se está respondiendo
    );
    _firebaseService.sendMessage(message);
    _messageController.clear();
    _cancelReply(); // Limpiar la respuesta después de enviar
    // Desplazar la lista hacia abajo después de enviar un mensaje
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Mantener el foco en el campo de texto después de enviar el mensaje
    _focusNode.requestFocus();
  }
}
  void _replyToMessage(Message message) {
    setState(() {
      _replyingToMessage = message; // Guardar el mensaje al que se está respondiendo
    });
    _focusNode.requestFocus(); // Enfocar el campo de texto
  }

  void _cancelReply() {
    setState(() {
      _replyingToMessage = null; // Limpiar el mensaje al que se está respondiendo
    });
  }

  void _copyMessage(Message message) {
    // Copiar el contenido del mensaje al portapapeles
    Clipboard.setData(ClipboardData(text: message.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Mensaje copiado al portapapeles")),
    );
  }

void _deleteMessage(Message message) {
  // Eliminar el mensaje de Firebase
  _firebaseService.deleteMessage(message);

  // Crear un controlador de animación
  final animationController = AnimationController(
    vsync: this, // Necesita un TickerProviderStateMixin
    duration: Duration(milliseconds: 750), // Duración de la animación de borrado
  );

  // Crear una animación para el desplazamiento del ícono
  final iconAnimation = Tween<double>(begin: 0, end: 150).animate(
    CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut, // Curva suave de entrada y salida
    ),
  );

  // Mostrar un SnackBar personalizado con animación
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: StatefulBuilder(
        builder: (context, setState) {
          // Iniciar la animación después de 0.25 segundos
          Future.delayed(Duration(milliseconds: 250), () {
            animationController.forward(); // Iniciar la animación de borrado
          });

          return AnimatedBuilder(
            animation: iconAnimation,
            builder: (context, child) {
              return Stack(
                clipBehavior: Clip.none, // Permitir que el ícono se salga del Stack
                children: [
                  // Texto "Mensaje eliminado"
                  Opacity(
                    opacity: 1 - iconAnimation.value / 150, // Desvanecer el texto
                    child: Padding(
                      padding: EdgeInsets.only(left: 24), // Espacio para el ícono
                      child: Text(
                        "Mensaje eliminado",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Ícono animado (aparece durante la animación)
                  Positioned(
                    left: iconAnimation.value, // Desplazar el ícono hacia la derecha
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              );
            },
          );
        },
      ),
      duration: Duration(milliseconds: 1000), // Duración total del SnackBar
      backgroundColor: Colors.redAccent, // Color de fondo
      behavior: SnackBarBehavior.floating, // Hacerlo flotante
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bordes redondeados
      ),
    ),
  );

  // Programar el cierre del SnackBar después de 1 segundo
  Future.delayed(Duration(milliseconds: 1000), () {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Cerrar el SnackBar
  });
}
  @override
  void dispose() {
    _focusNode.dispose(); // Liberar el foco al cerrar la pantalla
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chat",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Conectado como ${widget.username}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
  stream: _firebaseService.getMessages(),
  initialData: [], // Evita que muestre el círculo de carga
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text("No hay mensajes aún."));
    }

    List<Message> messages = snapshot.data!;
    return ListView.builder(
      reverse: true,
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isMe = msg.sender == widget.username;
        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: IntrinsicWidth(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              decoration: BoxDecoration(
                color: isMe ? Colors.blueAccent : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 12 : 0),
                  topRight: Radius.circular(isMe ? 0 : 12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (msg.replyTo != null) // Mostrar el sub-recuadro de respuesta
                    GestureDetector(
                      onTap: () {
                        // Abrir el modal con el mensaje completo
                        showReplyFullScreen(context, msg.replyTo!);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Respondiendo a ${msg.replyTo!.sender}: ${msg.replyTo!.text}",
                          style: TextStyle(
                            color: isMe ? Colors.blueGrey : Colors.grey[700],
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  if (!isMe)
                    Text(
                      msg.sender,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (msg.imageUrl != null) // Mostrar la imagen si existe
                    GestureDetector(
                      onTap: () {
                        // Abrir el modal con la imagen en tamaño completo
                        showImageFullScreen(context, msg.imageUrl!);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: Image.network(
                          msg.imageUrl!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (msg.text.isNotEmpty) // Mostrar el texto si existe
                    Text(
                      msg.text,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatTimestamp(msg.timestamp),
                        style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.grey[700],
                          fontSize: 10,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert, size: 16, color: isMe ? Colors.white70 : Colors.grey[700]),
                        onPressed: () {
                          // Mostrar el menú contextual
                          showMessageOptions(
                            context,
                            msg,
                            () {
                              // Acción para responder al mensaje
                              _replyToMessage(msg);
                            },
                            () {
                              // Acción para copiar el mensaje
                              _copyMessage(msg);
                            },
                            isMe ? () {
                              // Acción para eliminar el mensaje (solo si es tuyo)
                              _deleteMessage(msg);
                            } : null, // No mostrar la opción de eliminar si no es tu mensaje
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  },
),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (_replyingToMessage != null) // Mostrar el sub-recuadro de respuesta
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.reply, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Respondiendo a ${_replyingToMessage!.sender}: ${_replyingToMessage!.text}",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, size: 16, color: Colors.red),
                          onPressed: _cancelReply, // Cancelar la respuesta
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    // Botón de emojis
                    EmojiPickerAddon(messageController: _messageController),
                    SizedBox(width: 8),
                    // Botón de imágenes
                    ImagePickerAddon(
                      onImageUploaded: (imageUrl) {
                        // Crear un mensaje con la URL de la imagen
                        Message message = Message(
                          sender: widget.username,
                          text: '', // El texto estará vacío para mensajes de imagen
                          timestamp: DateTime.now().millisecondsSinceEpoch,
                          imageUrl: imageUrl, // URL de la imagen
                          replyTo: _replyingToMessage, // Mensaje al que se está respondiendo
                        );
                        _firebaseService.sendMessage(message);
                        _cancelReply(); // Limpiar la respuesta después de enviar
                      },
                    ),
                    SizedBox(width: 8),
                    // Campo de texto
                    Expanded(
                      child: TextField(
  controller: _messageController,
  focusNode: _focusNode, // Asignar el FocusNode al campo de texto
  decoration: InputDecoration(
    hintText: "Escribe un mensaje...",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
  ),
  onSubmitted: (value) {
    if (_messageController.text.isNotEmpty) {
      Message message = Message(
        sender: widget.username,
        text: _messageController.text,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        replyTo: _replyingToMessage, // Mensaje al que se está respondiendo
      );
      _firebaseService.sendMessage(message);
      _messageController.clear();
      _cancelReply(); // Limpiar la respuesta después de enviar
      _focusNode.requestFocus(); // Mantener el foco en el campo de texto
    }
  },
),
                    ),
                    SizedBox(width: 8),
                    // Botón de enviar
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}