// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(Icons.menu, color: Colors.black),
//           onPressed: () {},
//         ),
//         actions: [
//           CircleAvatar(
//             backgroundColor: Colors.orange,
//             child: Icon(Icons.person, color: Colors.white),
//           ),
//           SizedBox(width: 16),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Hi Nanas 👋', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//             Text('Let\'s Play', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Rank', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         Text('116/654', style: TextStyle(fontSize: 16)),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text('Points', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         Text('2,825', style: TextStyle(fontSize: 16)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text('Level 2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text('Quiz #Icon', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 8),
//             LinearProgressIndicator(value: 0.4, color: Colors.blue, backgroundColor: Colors.grey[300]),
//             SizedBox(height: 10),
//             GridView.count(
//               crossAxisCount: 3,
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               children: [
//                 Icon(Icons.diamond, size: 50, color: Colors.blue),
//                 Icon(Icons.star, size: 50, color: Colors.yellow),
//                 Icon(Icons.bolt, size: 50, color: Colors.blue),
//                 Icon(Icons.emoji_events, size: 50, color: Colors.yellow),
//                 Icon(Icons.military_tech, size: 50, color: Colors.orange), // Use military_tech instead of crown
//               ],
//             ),
//             SizedBox(height: 1),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.lightBlue, // Use backgroundColor instead of primary
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//                   padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
//                 ),
//                 child: Text('Continue', style: TextStyle(fontSize: 18)),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Games'),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//         ],
//       ),
//     );
//   }
// }

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

  @override
  void initState() {
    super.initState();
    _profile = _leetcodeService.getUserProfile('neal_wu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LeetCode Profile')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var data = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Solved: ${data['totalSolved']}'),
                  Text('Rank: ${data['ranking']}'),
                  Text('Contribution Points: ${data['contributionPoint']}'),
                  // Add more fields as needed.
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
