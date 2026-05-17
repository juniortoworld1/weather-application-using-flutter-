import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weatherapplication/Input_fields/InputFields.dart';
import 'package:weatherapplication/api_model/api_auth.dart';
import 'package:weatherapplication/animted_clouds/animted_clouds.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherapplication/lottie_custom/custom_lottie.dart';

class Weather_dashboard extends StatefulWidget {
  const Weather_dashboard({super.key});

  @override
  State<Weather_dashboard> createState() => _Weather_dashboardState();
}

class _Weather_dashboardState extends State<Weather_dashboard> {
  final Api _service = Api();
  final TextEditingController _searchController = TextEditingController();
  String _currentCity = "London";

  Widget getweather(int conditionCode, String iconsURL, int day__) {
    final List<int> lottiecode = [
      1000, 1003, 1006, 1009, 1030, 1135, 1147,
      1063, 1150, 1153, 1180, 1183, 1240,
      1186, 1189, 1192, 1195, 1243, 1246,
      1087, 1273, 1276, 1279, 1282,
      1066, 1069, 1114, 1117, 1213, 1216, 1225
    ];
    if (lottiecode.contains(conditionCode)) {
      return AnimtedClouds(code_: conditionCode, isday_: day__);
    } else {
      return Image.network(
        "https:$iconsURL",
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud_off, color: Colors.white70),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: const Color(0xFF1A1C2E),
      body: SafeArea(
        child: FutureBuilder(
          future: _service.fetchdata(_currentCity),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No data found", style: const TextStyle(color: Colors.white)));
            } else {
              final data = snapshot.data as Map<String, dynamic>;
              final List forecastList = data['forecast']['forecastday'];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Inputfields(
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _currentCity = value;
                          });
                        }
                      },
                      label: "City",
                      controller: _searchController,
                      hint: "Search your location",
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['location']['name'],
                              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: kIsWeb?400:screenHeight * 0.30,
                                  width: kIsWeb?400:screenWidth*0.6,
                                  child: getweather(
                                    data['current']['condition']['code'],
                                    data['current']['condition']['icon'],
                                    data['current']['is_day'],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${data['current']['temp_c']} °C",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
                                    ),
                                    Text(
                                      "${data['current']['temp_f']} °F",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white60),
                                    ),],
                                ),

                              ],
                            ),
                            const SizedBox(height: kIsWeb?30:0),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white60.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.white70, width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  
                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(  width: kIsWeb?100:70, height: kIsWeb?100:70, child: CustomLottie(assetPath: 'assets/images/humidity.json' , fit: BoxFit.contain,)) ,
                                        Text("${data['current']['humidity']}%" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold, color: Colors.white70),) ,
                                        Text("Humidity" , style: TextStyle(fontSize: 23 , fontWeight: FontWeight.w500 , color: Colors.white60),)
                                      ],
                                    ),
                                  ) ,

                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(  width: kIsWeb?100:70, height: kIsWeb?100:70, child: CustomLottie(assetPath: 'assets/images/spedometer.json' , fit: BoxFit.contain,)) ,
                                        Text("${data['current']['wind_kph']} Km/h" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold, color: Colors.white70),) ,
                                        Text("Wind" , style: TextStyle(fontSize: 23 , fontWeight: FontWeight.w500 , color: Colors.white60),)
                                      ],
                                    ),
                                  ) ,

                                  Container(
                                    child: Column(
                                      children: [
                                        SizedBox(  width: kIsWeb?100:70, height: kIsWeb?100:70, child: CustomLottie(assetPath: 'assets/images/UV_aniamted.json' , fit: BoxFit.contain,)) ,
                                        Text("${data['current']['uv']}" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold, color: Colors.white70),) ,
                                        Text("UV index" , style: TextStyle(fontSize: 23 , fontWeight: FontWeight.w500 , color: Colors.white60),)
                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ) ,

                            SizedBox(height: 30,) ,
                            const Text(
                              "7-Day Forecast",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: forecastList.length,
                              itemBuilder: (context, index) {
                                final dayData = forecastList[index];
                                final String date = dayData['date'];
                                final Map dayDetails = dayData['day'];
                                final double avgTempC = dayDetails['avgtemp_c'];
                                final int conditionCode = dayDetails['condition']['code'];
                                final String iconUrl = dayDetails['condition']['icon'];

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white60.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.white70, width: 1.5),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: getweather(conditionCode, iconUrl, 1),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(date, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                                            const SizedBox(height: 5),
                                            Text(dayDetails['condition']['text'], style: const TextStyle(color: Colors.white70)),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text("${avgTempC.toStringAsFixed(1)} °C", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
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