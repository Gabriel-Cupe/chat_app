class Message {
  final String sender;
  final String text;
  final int timestamp;

  Message({
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<dynamic, dynamic> map) {
    return Message(
      sender: map['sender'],
      text: map['text'],
      timestamp: map['timestamp'],
    );
  }
}