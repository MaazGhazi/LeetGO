import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:leetgo1/message_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: const String.fromEnvironment('api_key'),
    );
    _chatSession = _model.startChat();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeetGO Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _chatSession.history.length,
                itemBuilder: (context, index) {
                  final Content content = _chatSession.history.toList()[index];
                  final text = content.parts
                      .whereType<TextPart>()
                      .map<String>((e) => e.text)
                      .join('');
                  return MessageWidget(
                    text: text,
                    isFromUser: content.role == 'user',
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: textFieldDecoration(),
                      controller: _textController,
                      onSubmitted: _sendChatMessage,
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  InputDecoration textFieldDecoration() {
    return InputDecoration(
      hintText: 'Type a message...',
      contentPadding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[200],
    );
  }

  Future<void> _sendChatMessage(String message) async {
  setState(() {
    _loading = true;
  });

  try {
    final response = await _chatSession.sendMessage(
      Content.text(message),
    );

    final text = response.text;
    if (text == null) {
      _showError('No response from API.');
      return;
    } else {
      setState(() {
        _loading = false;
        _scrollDown();
      });
      // Handle the response text here
    }
  } catch (e) {
    _showError(e.toString());
    setState(() {
      _loading = false;
    });
  } finally {
    _textController.clear();
    setState(() {
      _loading = false;
    });
    _textFieldFocus.requestFocus();
  }
}
void _scrollDown() {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      );
    },
  );
}

void _showError(String message) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Something went wrong'),
        content: SingleChildScrollView(
          child: SelectableText(message),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}


}
