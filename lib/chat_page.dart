import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:belajarbersama/utils.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String otherUserUid;
  const ChatPage({required this.chatId, required this.otherUserUid, super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseReference _chatRef = FirebaseDatabase.instance.ref('chats');
  List<Map<String, dynamic>> messages = [];
  String? otherUserName;
  String? otherUserPhotoUrl;

  @override
  void initState() {
    super.initState();
    _listenMessages();
    _fetchOtherUserName();
    _clearUnread();
  }

  void _listenMessages() {
    _chatRef.child('${widget.chatId}/messages').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final List<Map<String, dynamic>> loaded = [];
        data.forEach((key, value) {
          loaded.add({
            'text': value['text'],
            'sender': value['sender'],
            'timestamp': value['timestamp'],
          });
        });
        loaded.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
        setState(() {
          messages = loaded;
        });
      } else {
        setState(() {
          messages = [];
        });
      }
    });
  }

  Future<void> _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _controller.text.trim().isEmpty) return;
    final msgRef = _chatRef.child('${widget.chatId}/messages').push();
    await msgRef.set({
      'text': _controller.text.trim(),
      'sender': user.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    // Update last_activity
    await _chatRef
        .child('${widget.chatId}/last_activity')
        .set(DateTime.now().toIso8601String());

    // === Tandai unread untuk lawan chat ===
    final otherUid = widget.otherUserUid;
    await FirebaseDatabase.instance
        .ref('users/$otherUid/unread_chats/${widget.chatId}')
        .set(true);

    _controller.clear();
  }

  Future<void> _fetchOtherUserName() async {
    final snapshot = await FirebaseDatabase.instance
        .ref('users/${widget.otherUserUid}')
        .get();
    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        otherUserName = data['name'] ?? data['email'] ?? widget.otherUserUid;
        otherUserPhotoUrl = data['photoUrl'] ?? '';
      });
    } else {
      setState(() {
        otherUserName = widget.otherUserUid;
        otherUserPhotoUrl = '';
      });
    }
  }

  Future<void> _clearUnread() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseDatabase.instance
          .ref('users/${user.uid}/unread_chats/${widget.chatId}')
          .remove();
    }
  }

  Future<void> _checkAndDeleteOldChat() async {
    final snapshot = await FirebaseDatabase.instance
        .ref('chats/${widget.chatId}/last_activity')
        .get();
    if (snapshot.exists) {
      final lastActivity = DateTime.parse(snapshot.value as String);
      if (DateTime.now().difference(lastActivity).inHours >= 3) {
        await FirebaseDatabase.instance.ref('chats/${widget.chatId}').remove();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F8), // Pink sangat muda
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5E79),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  (otherUserPhotoUrl != null && otherUserPhotoUrl!.isNotEmpty)
                  ? NetworkImage(transformCloudinaryUrl(otherUserPhotoUrl!))
                  : null,
              child: (otherUserPhotoUrl == null || otherUserPhotoUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 18)
                  : null,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                otherUserName ?? 'Chat',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              reverse: false,
              children: messages.map((msg) {
                final isMe = msg['sender'] == user?.uid;
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(
                              0xFFFF5E79,
                            ) // Pink tua untuk chat sendiri
                          : const Color(0xFFFFB6C1), // Pink muda untuk lawan
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFFF5E79)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFFF5E79),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFFF5E79)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
