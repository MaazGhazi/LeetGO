import 'dart:convert';
import 'package:http/http.dart' as http;

class LeetcodeService {
  static const String baseUrl = "https://alfa-leetcode-api.onrender.com/userProfile";

  Future<Map<String, dynamic>> getUserProfile(String username) async {
  final response = await http.get(Uri.parse('$baseUrl/$username'));
  
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else if (response.statusCode == 404) {
    throw Exception('Profile not found');
  } else {
    throw Exception('Failed to load profile');
  }
}

  // Add more methods for different endpoints if needed.
}
