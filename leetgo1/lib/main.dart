// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:leetgo1/login_page.dart';
import 'quiz.dart';
import 'home_screen.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:url_launcher/link.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      // theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

//LEETCODE API info
//INFO SCREEN
class InfoScreen extends StatefulWidget {
  final String username;

  const InfoScreen({required this.username});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final LeetcodeService _leetcodeService = LeetcodeService();
  late Future<Map<String, dynamic>> _profile;
  late Future<Map<String, dynamic>> _dailyQuestion;
  late Future<List<dynamic>> _problems;
  late Future<List<dynamic>> _filteredProblems;
  String _dailyQuestionText = '';

  @override
  void initState() {
    super.initState();
    _profile = _leetcodeService.getUserProfile(widget.username);
    _dailyQuestion = _leetcodeService.getDailyQuestion().then((data) {
      _dailyQuestionText = data['question'] ?? 'No question available';
      return data;
    });
    _problems = _leetcodeService.getProblems();
    _filteredProblems = _leetcodeService.filterProblems(['tag1', 'tag2']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //APP BAR
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _profile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  var data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi ${widget.username} 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text('LeetCode on the GO! 🏃‍♂️', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 20),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Rank', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text('${data['ranking']}', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Contribution Points', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Text('${data['contributionPoint']}' , style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
  onPressed: () {
    final String formattedMessage = 'Here is the daily question from LeetCode:\n\n'
                                    '$_dailyQuestionText\n\n'
                                    "Be the interviewer and ask me the daily question! ";
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerativeAISample(
          username: widget.username,
          welcomeMessage: formattedMessage,
        ),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.lightBlue, // Use backgroundColor instead of primary
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  ),
  child: Text('   Daily Question 💡   ', style: TextStyle(
      fontSize: 25,
      color: Colors.white, // Text color
    ),
    ),
),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerativeAISample(
          username: widget.username,
          welcomeMessage: 'Hi LeetGO, can I ask you a LeetCode problem and you test me on it? Dont give me the answer but let me asnwer it through pseudocode!',
        ),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.lightBlue, // Use backgroundColor instead of primary
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  ),
  child: Text('Talk to LEETGO AI 🤖', style: TextStyle(
      fontSize: 25,
      color: Colors.white, // Text color
    ),),
),
                      ),
                      // Add more fields as needed.
                    ],
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
            SizedBox(height: 20),
  SizedBox(height: 20),
    // Tips Section
    
  Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.blueAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(30),
  ),
  child: ElevatedButton(
    onPressed: () {
      // Your action here
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent, // Makes the button background transparent to show the gradient
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tips for using LeetGO AI:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                '1. Clearly match the LeetCode problem name.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '2. Provide context or details if needed.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '3. Use the feedback to improve.',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),


  
          ],
        ),
      ),
    );
  }
}


//AI SCREEN
 
// Update GenerativeAISample to accept welcomeMessage

class GenerativeAISample extends StatelessWidget {
  final String username;
  final String welcomeMessage;

  const GenerativeAISample({
    super.key,
    required this.username,
    required this.welcomeMessage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LeetGO🏃‍♂️',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(255, 171, 222, 244),
        ),
        useMaterial3: true,
      ),
      home: ChatScreen(
        title: 'LeetGO🏃‍♂️',
        username: username,
        welcomeMessage: welcomeMessage,
      ),
    );
  }
}


class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.title,
    required this.username,
    required this.welcomeMessage,
  });

  final String title;
  final String username;
  final String welcomeMessage;

  @override
  Widget build(BuildContext context) {
    // Replace with your actual API key
    const String apiKey = 'AIzaSyB5n7bAbXirPn9QE33VXwntHfks6lihmFM';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => InfoScreen(username: username),
                ),
              );
            },
          ),
        ],
      ),
      body: ChatWidget(apiKey: apiKey, welcomeMessage: welcomeMessage),
    );
  }
}


class ChatWidget extends StatefulWidget {
  const ChatWidget({
    required this.apiKey,
    required this.welcomeMessage,
    super.key,
  });

  final String apiKey;
  final String welcomeMessage;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode(debugLabel: 'TextField');
  bool _loading = false;
  bool _welcomeMessageSent = false; // Track if the welcome message is sent

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: widget.apiKey,
    );
    _chat = _model.startChat();

    // Send the provided welcome message as the chatbot
    _sendInitialMessage();
  }

  Future<void> _sendInitialMessage() async {
    if (!_welcomeMessageSent) {
      try {
        await _chat.sendMessage(
          Content.text(widget.welcomeMessage),
        );
        setState(() {
          _welcomeMessageSent = true; // Mark as sent
        });
        _scrollDown();
      } catch (e) {
        _showError(e.toString());
      }
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = _chat.history.toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, idx) {
                final content = history[idx];
                final text = content.parts
                    .whereType<TextPart>()
                    .map<String>((e) => e.text)
                    .join('');
                return MessageWidget(
                  text: text,
                  isFromUser: content.role == 'user',
                );
              },
              itemCount: history.length,
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
                    decoration: textFieldDecoration(
                      context,
                      'Enter a prompt...',
                    ),
                    controller: _textController,
                    onSubmitted: (String value) {
                      _sendChatMessage(value);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                if (!_loading)
                  IconButton(
                    onPressed: () async {
                      _sendChatMessage(_textController.text);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                else
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
    });

    try {
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      final text = response.text;

      if (text == null) {
        _showError('Empty response.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
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

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.text,
    required this.isFromUser,
  });

  final String text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            decoration: BoxDecoration(
              color: isFromUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
            margin: const EdgeInsets.only(bottom: 8),
            child: MarkdownBody(data: text),
          ),
        ),
      ],
    );
  }
}

InputDecoration textFieldDecoration(BuildContext context, String hintText) =>
    InputDecoration(
      contentPadding: const EdgeInsets.all(15),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );

