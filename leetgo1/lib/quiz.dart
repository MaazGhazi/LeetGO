import 'dart:convert';
import 'package:http/http.dart' as http;

class LeetcodeService {
  static const String baseUrl = "https://alfa-leetcode-api.onrender.com";

  Future<Map<String, dynamic>> getUserProfile(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/userProfile/$username'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Profile not found');
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Map<String, dynamic>> getDailyQuestion() async {
    final response = await http.get(Uri.parse('$baseUrl/daily'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load daily question');
    }
  }

  Future<List<dynamic>> getProblems({int limit = 20}) async {
  final response = await http.get(Uri.parse('$baseUrl/problems?limit=$limit'));

  print('Problems Response status: ${response.statusCode}');
  print('Problems Response body: ${response.body}');

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print('Decoded data: $data'); // Print the decoded data

    if (data is Map<String, dynamic>) {
      // Check for the key 'problemsetQuestionList'
      if (data.containsKey('problemsetQuestionList')) {
        return data['problemsetQuestionList'] as List<dynamic>;
      } else {
        throw Exception('Unexpected response format for problems. Available keys: ${data.keys}');
      }
    } else {
      throw Exception('Unexpected response format for problems: ${data.runtimeType}');
    }
  } else {
    throw Exception('Failed to load problems');
  }
}

Future<List<dynamic>> filterProblems(List<String> tags) async {
  final tagString = tags.join('+');
  final response = await http.get(Uri.parse('$baseUrl/problems?tags=$tagString'));

  print('Filtered Problems Response status: ${response.statusCode}');
  print('Filtered Problems Response body: ${response.body}');

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print('Decoded data: $data'); // Print the decoded data

    if (data is Map<String, dynamic>) {
      // Check for the key 'problemsetQuestionList'
      if (data.containsKey('problemsetQuestionList')) {
        return data['problemsetQuestionList'] as List<dynamic>;
      } else {
        throw Exception('Unexpected response format for filtered problems. Available keys: ${data.keys}');
      }
    } else {
      throw Exception('Unexpected response format for filtered problems: ${data.runtimeType}');
    }
  } else {
    throw Exception('Failed to load filtered problems');
  }
}


}


