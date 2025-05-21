import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ⚠️ Change this IP if you're using Android emulator or real device
  final String baseUrl = "http://10.0.2.2:8000/api";

  /// Logs in with username and password, returns JWT access token if successful
  Future<String?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/token/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Access Token: ${data['access']}");
        return data['access']; // Return JWT token
      } else {
        print("Login failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during login: $e");
      return null;
    }
  }

  /// Uses the access token to fetch protected data from /api/hello/
  Future<String?> fetchHello(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/hello/"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']; // Should be: "Hello from Django API!"
      } else {
        print("Failed to fetch hello: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during fetchHello: $e");
      return null;
    }
  }
}
