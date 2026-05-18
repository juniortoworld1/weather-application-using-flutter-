import 'dart:ui'; // CRITICAL: Required for ImageFilter backdrop blurs
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weatherapplication/Input_fields/InputFields.dart';
import 'package:weatherapplication/Input_fields/InputFields.dart';
import 'package:weatherapplication/api_model/api_auth.dart';
import 'package:weatherapplication/animted_clouds/animted_clouds.dart';
import 'package:weatherapplication/lottie_custom/custom_lottie.dart';

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({super.key});

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  static const List<int> _lottieCodes = [
    1000, 1003, 1006, 1009, 1030, 1135, 1147,
    1063, 1150, 1153, 1180, 1183, 1240,
    1186, 1189, 1192, 1195, 1243, 1246,
    1087, 1273, 1276, 1279, 1282,
    1066, 1069, 1114, 1117, 1213, 1216, 1225
  ];

  final Api _service = Api();
  final TextEditingController _searchController = TextEditingController();

  String _currentCity = "London";
  late Future<dynamic> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _service.fetchdata(_currentCity);
  }

  void _searchWeather(String city) {
    if (city.isNotEmpty) {
      setState(() {
        _currentCity = city;
        _weatherFuture = _service.fetchdata(_currentCity);
      });
    }
  }

  Widget _getWeatherWidget(int conditionCode, String iconsURL, int isDay) {
    if (_lottieCodes.contains(conditionCode)) {
      return AnimtedClouds(code_: conditionCode, isday_: isDay);
    } else {
      return Image.network(
        "https:$iconsURL",
        width: 100,
        height: 100,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.cloud_off, color: Colors.white70, size: 40),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0F101D), // Darker midnight tone for rich contrast
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Inputfields(
                onSubmitted: (value) => _searchWeather(value.trim()),
                label: "Location",
                controller: _searchController,
                hint: "Search city...",
              ),
              const SizedBox(height: 24),
              Expanded(
                child: FutureBuilder(
                  future: _weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white38));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white70)));
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text("No data found", style: const TextStyle(color: Colors.white60)));
                    }

                    final data = snapshot.data as Map<String, dynamic>;
                    final List forecastList = data['forecast']['forecastday'];

                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(), // Premium iOS/Android elastic scroll feel
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // City Label & Clean Subtitle Date
                              Text(
                                data['location']['name'],
                                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -1.0),
                              ),
                              Text(
                                "Today, ${data['location']['localtime'].toString().split(' ')[0]}",
                                style: const TextStyle(fontSize: 14, color: Colors.white38, fontWeight: FontWeight.w500, letterSpacing: 0.5),
                              ),
                              const SizedBox(height: 16),

                              // Typography Contrast Section: Massive Light Numbers + Bold Condition Text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${data['current']['temp_c']}°",
                                          style: const TextStyle(fontWeight: FontWeight.w100, fontSize: 86, color: Colors.white, height: 1.0),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          data['current']['condition']['text'].toString().toUpperCase(),
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 2.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.20,
                                    width: screenWidth * 0.42,
                                    child: _getWeatherWidget(
                                      data['current']['condition']['code'],
                                      data['current']['condition']['icon'],
                                      data['current']['is_day'],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),

                              // MODERN ENGINE: Horizontal Hourly Forecast Reel
                              const Text("HOURLY FORECAST", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.5)),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 135,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: (data['forecast']['forecastday'][0]['hour'] as List).length,
                                  itemBuilder: (context, hourIndex) {
                                    final hourData = data['forecast']['forecastday'][0]['hour'][hourIndex];
                                    // Displays hourly updates at 3-hour intervals to keep the layout concise
                                    if (hourIndex % 3 != 0) return const SizedBox.shrink();

                                    return _buildGlassCard(
                                      margin: const EdgeInsets.only(right: 12, bottom: 6),
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(hourData['time'].toString().split(' ')[1], style: const TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 6),
                                          Image.network("https:${hourData['condition']['icon']}", width: 36, height: 36),
                                          const SizedBox(height: 6),
                                          Text("${hourData['temp_c']}°", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Weather Metrics Bento Row
                              const Text("CURRENT METRICS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.5)),
                              const SizedBox(height: 12),
                              _buildGlassCard(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildMetricColumn('assets/images/humidity.json', "${data['current']['humidity']}%", "Humidity"),
                                    _buildMetricColumn('assets/images/spedometer.json', "${data['current']['wind_kph']} km/h", "Wind"),
                                    _buildMetricColumn('assets/images/UV_aniamted.json', "${data['current']['uv']}", "UV Index"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              const Text(
                                "7-DAY FORECAST",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.5),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),

                        // Refactored 7-Day Forecast SliverList
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final dayData = forecastList[index];
                              final Map dayDetails = dayData['day'];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: _buildGlassCard(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 55,
                                        height: 55,
                                        child: _getWeatherWidget(dayDetails['condition']['code'], dayDetails['condition']['icon'], 1),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(dayData['date'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                                            const SizedBox(height: 3),
                                            Text(dayDetails['condition']['text'], style: const TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w500)),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "${dayDetails['avgtemp_c'].toStringAsFixed(1)}°",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white, letterSpacing: -0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: forecastList.length,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String assetPath, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: kIsWeb ? 85 : 60,
          height: kIsWeb ? 85 : 60,
          child: CustomLottie(assetPath: assetPath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white38))
      ],
    );
  }

  // 💎 PREMIUM ELEMENT: Isolated, Reusable Glassmorphism Wrapper
  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding, EdgeInsetsGeometry? margin}) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            )
          ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), // Frosting factor
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05), // Translucent backdrop
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.12), // Subtle translucent boundary highlight
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

