import 'package:flutter/material.dart';
import 'package:weather_application/services/weather_service.dart';
import 'package:weather_application/weather_model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _weatherService = WetherService('cdfa508872a75d894916e89ca9f3e555');
  Weather? _weather;
  int _selectedIndex = 0; // Assuming _onItemTapped function exists

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  void _fetchWeatherForLocation(String location) async {
    try {
      final weather = await _weatherService.getWeather(location);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
      // Handle errors or display a message indicating the location was not found
    }
  }

  void _onItemTapped(int index) {
    // Define the logic for different forecast options
    setState(() {
      _selectedIndex = index;
    });
    // Further logic based on the selected index...
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            // Search and Forecast Options
            Container(
              color: Colors.black12.withOpacity(0.5),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search location',
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.5),
                    ),
                    onSubmitted: (value) {
                      _fetchWeatherForLocation(
                          value); // Fetch weather for the entered location
                      // Call search function here using _weatherService
                    },
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 50,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _onItemTapped(0), // Replace with your logic
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Today',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: _selectedIndex == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _onItemTapped(1), // Replace with your logic
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Tomorrow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: _selectedIndex == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    _onItemTapped(2), // Replace with your logic
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '10 Days',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: _selectedIndex == 2
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AnimatedPositioned(
                          top: 48,
                          left: _selectedIndex *
                              (MediaQuery.of(context).size.width / 3),
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            height: 2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Weather Display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_weather?.cityName ?? "loading city.."),
                    Text('${_weather?.temperature.round()}°C'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
