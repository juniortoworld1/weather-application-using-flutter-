import 'package:flutter/material.dart';
import 'package:weatherapplication/Input_fields/InputFields.dart';
import 'package:weatherapplication/api_model/api_auth.dart';

class Weather_dashboard extends StatefulWidget {
  const Weather_dashboard({super.key});

  @override
  State<Weather_dashboard> createState() => _Weather_dashboardState();
}

class _Weather_dashboardState extends State<Weather_dashboard> {
  final Api _service = Api();
  final TextEditingController _searchController = TextEditingController() ;
  String _currentCity = "100.0.0.2";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea prevents the UI from hitting the status bar/notch
      body: SafeArea(
        child: FutureBuilder(
          future: _service.fetchdata(_currentCity),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              final data = snapshot.data as Map;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  // This keeps items aligned to the top-center
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Inputfields(
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _currentCity = value; // This updates the city
                          });
                        }
                      },
                      label: "City",
                      controller: _searchController,
                      hint: "Search your location",

                    ),
                    const SizedBox(height: 30),

                    Expanded(
                      child: Column(
                        children: [
                          Image.network(
                            "https:${data['current']['condition']['icon']}",
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                          ),
                          Text(
                            data['location']['name'],
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['current']['temp_c']}°C",
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}