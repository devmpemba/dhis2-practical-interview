import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Weather_App/model/Weather.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _humidity = '';
  String _windSpeed = '';
  double visibilityData = 0.0;
  double humidityData = 0.0;
  double windSpeedData = 0.0;

  Future<void> _getWeather(String cityName) async {
    // Show the progress dialog
    showDialog(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    const apiKey = '7504f2a690fcd79a618b0c26813120a0';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final weather = Weather(
          visibility: data['visibility'] / 1000,
          humidity: data['main']['humidity'].toDouble(),
          windSpeed: data['wind']['speed'],
        );

        setState(() {
          //temperature calculation
          double temperatureInCelsius = data['main']['temp'] - 273.15;
          _temperature = '${temperatureInCelsius.toStringAsFixed(2)}°C';

          _humidity = 'Humidity: ${weather.humidity}%';
          _windSpeed = 'Wind Speed: ${weather.windSpeed} m/s';

          // Update the UI with the new design
          visibilityData = weather.visibility;
          humidityData = weather.humidity;
          windSpeedData = weather.windSpeed;
        });

        // Close the progress dialog
        Navigator.pop(context);
      } else {
        // Handle errors
        print('Error: ${response.statusCode}');

        // Close the progress dialog
        Navigator.pop(context);
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');

      // Close the progress dialog
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Containers (Humidity, Visibility, Wind Speed)
            Text(
              _temperature,
              style: const TextStyle(fontSize: 65, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display Temperature

                // Visibility
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.indigo,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          "Visibility",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "${visibilityData.toStringAsFixed(2)} km",
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),

                // Humidity
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.indigo,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            Icons.water_drop,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          "Humidity",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "${humidityData.toStringAsFixed(2)}%",
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),

                // Wind Speed
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.indigo,
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          padding: const EdgeInsets.all(10.0),
                          child: const Icon(
                            Icons.wind_power,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Text(
                          "Wind Speed",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "${windSpeedData.toStringAsFixed(2)} km/hr",
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // TextField and Get Weather Button
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Enter city name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(

              onPressed: () {
                _getWeather(_cityController.text);
              },
              child: const Text('Get Weather'),
            ),
          ],
        ),
      ),
    );
  }
}
