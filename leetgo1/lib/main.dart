import 'package:flutter/material.dart';
import 'quiz.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LeetcodeService _leetcodeService = LeetcodeService();
  late Future<Map<String, dynamic>> _profile;
  late Future<Map<String, dynamic>> _dailyQuestion;
  late Future<List<dynamic>> _problems;
  late Future<List<dynamic>> _filteredProblems;

  @override
  void initState() {
    super.initState();
    _profile = _leetcodeService.getUserProfile('neal_wu');
    _dailyQuestion = _leetcodeService.getDailyQuestion();
    _problems = _leetcodeService.getProblems();
    _filteredProblems = _leetcodeService.filterProblems(['tag1', 'tag2']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LeetCode Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
                    Text('Total Solved: ${data['totalSolved']}'),
                    Text('Rank: ${data['ranking']}'),
                    Text('Contribution Points: ${data['contributionPoint']}'),
                    // Add more fields as needed.
                  ],
                );
              } else {
                return Center(child: Text('No data available'));
              }
            },
          ),
          SizedBox(height: 20),
          FutureBuilder<Map<String, dynamic>>(
            future: _dailyQuestion,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                var data = snapshot.data!;
                return Text('Daily Question: ${data['question']}');
              } else {
                return Center(child: Text('No daily question available'));
              }
            },
          ),
          SizedBox(height: 20),
          FutureBuilder<List<dynamic>>(
            future: _problems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                var problems = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: problems.map((problem) => Text('Problem: ${problem['title']}')).toList(),
                );
              } else {
                return Center(child: Text('No problems available'));
              }
            },
          ),
          SizedBox(height: 20),
          FutureBuilder<List<dynamic>>(
            future: _filteredProblems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                var problems = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: problems.map((problem) => Text('Filtered Problem: ${problem['title']}')).toList(),
                );
              } else {
                return Center(child: Text('No filtered problems available'));
              }
            },
          ),
        ],
      ),
    );
  }
}
