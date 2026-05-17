import 'dart:convert';
import 'package:http/http.dart' as http;
class Api {
  final String apiKey = "a6aa2392e0774d9489151147261405";

  Future<Map<String, dynamic>> fetchdata(String city) async {
    final url = 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7' ;

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Converts the "text" from API into a Map
    } else {
      throw Exception('Failed to load weather');
    }
  }
}