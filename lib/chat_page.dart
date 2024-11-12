import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String friendName;

  ChatPage({Key? key, required this.friendName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = []; // Stores chat messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("与 ${widget.friendName} 的聊天"),
        backgroundColor: Colors.blue,
        elevation: 0, // Cleaner look
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200], // Light background for chat area
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUserMessage = messages[index]['isUserMessage'];
                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isUserMessage)
                            CircleAvatar(
                              backgroundImage: AssetImage('images/friend_avatar.png'),
                              radius: 16,
                            ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                              color: isUserMessage ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(2, 2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: Text(
                              messages[index]['message'],
                              style: TextStyle(
                                color: isUserMessage ? Colors.white : Colors.black87,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          if (isUserMessage)
                            CircleAvatar(
                              backgroundImage: AssetImage('images/QQ头像.jpg'),
                              radius: 28,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left Button for Emoji or Attachments
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Colors.blue),
                    onPressed: () {
                      // Add action for adding attachments or emojis
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "请输入消息...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onChanged: (text) {
                        setState(() {}); // Update send button visibility
                      },
                    ),
                  ),
                  // Right Button for Voice or other action
                  IconButton(
                    icon: Icon(Icons.mic, color: Colors.blue),
                    onPressed: () {
                      // Add action for voice message recording
                    },
                  ),
                  // Send Button - Visible only if text is entered
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          messages.insert(0, {
                            'message': _controller.text,
                            'isUserMessage': true, // User message
                          });
                        });
                        _controller.clear(); // Clear input after sending
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
