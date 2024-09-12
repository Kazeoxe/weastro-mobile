import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:waestro_mobile/models/weather_icons_model.dart';
import 'package:waestro_mobile/services/weather_service.dart';
import 'package:waestro_mobile/models/weather_model.dart';
import 'package:waestro_mobile/components/weather_search_bar.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  //api key
  final _weatherService = WeatherService("ba77028036d04fc683174830241009");
  Weather? _weather;

  _fetchWeather() async {
    String coord = await _weatherService.getcurrentCity();
    print(coord);
    try {
      final weather = await _weatherService.getWeather(coord);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        // Ce container enveloppe tout le contenu du Scaffold et applique le fond en dégradé
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(-1, 1),
            colors: <Color>[
              Color(0xFF101010),
              Color.fromARGB(255, 38, 40, 55),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Stack(
          children: [
            // Contenu principal centré
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "wa.",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  LocationSearchBar(weatherService: _weatherService),
                  if (_weather != null)
                    Column(
                      children: <Widget>[
                        Text(
                          '${_weather!.cityName}',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          '${_weather!.temp}°C',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                        // Image.network('https:${_weather!.icon}'),
                        SizedBox(
                          height: screenHeight *
                              0.25,
                          child: Lottie.asset(
                              getCustomWeatherIcon(_weather!.condition)),
                        ),

                        Text(
                          DateFormat('dd MMMM, EEEE').format(_weather!.date),
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ],
                    ),
                  if (_weather == null) CircularProgressIndicator(),
                ],
              ),
            ),
            // Positionner l'icône en bas de la page
            Positioned(
              bottom: 20, // Distance du bas de la page
              left: 0,
              right: 0,
              child: Center(
                child: IconButton(
                  icon: Icon(Icons.search, size: 44, color: Colors.tealAccent),
                  onPressed: _fetchWeather,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}