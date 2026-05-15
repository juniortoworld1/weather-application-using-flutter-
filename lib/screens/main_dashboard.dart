import 'package:flutter/material.dart';
import 'package:weatherapplication/Input_fields/InputFields.dart';
import 'package:weatherapplication/api_model/api_auth.dart';
import 'package:weatherapplication/animted_clouds/animted_clouds.dart';

class Weather_dashboard extends StatefulWidget {
  const Weather_dashboard({super.key});

  @override
  State<Weather_dashboard> createState() => _Weather_dashboardState();
}

class _Weather_dashboardState extends State<Weather_dashboard> {
  final Api _service = Api();
  final TextEditingController _searchController = TextEditingController() ;
  String _currentCity = "London";

  Widget getweather(int conditionCode , String iconsURL , int day__) {
    final List<int> lottiecode = [
      1000, 1003, 1006, 1009, 1030, 1135, 1147,
      1063, 1150, 1153, 1180, 1183, 1240,
      1186, 1189, 1192, 1195, 1243, 1246,
      1087, 1273, 1276, 1279, 1282,
      1066, 1069, 1114, 1117, 1213, 1216, 1225
    ];
    if (lottiecode.contains(conditionCode)){
      return AnimtedClouds(code_: conditionCode , isday_: day__,) ;
    }
    else{
      return Image.network(
        "https:$iconsURL",
        width: 120,
        height: 120,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud_off),
      );
    }
  }


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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['location']['name'],
                              style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                            ),
                            Center(
                              child: Expanded(

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 400 ,
                                      width: 400,
                                      child: getweather(data['current']['condition']['code'] , data['current']['condition']['icon'] , data['current']['is_day'] ) ,
                                    ),
                                    Column(
                                      children: [
                                        Text("${data['current']['temp_c']} °C"  , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                                        Text("${data['current']['temp_f']} °F" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ) ,

                          ],
                        ),
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