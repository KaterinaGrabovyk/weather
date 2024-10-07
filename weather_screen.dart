import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/cities.dart';

//weather page
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  List<String> cities = ['Київ', 'Львів', 'Одеса', 'Дніпро'];
  String city = 'Київ';
  String temperature = "";
  String condition = "";
  String iconUrl = "";
  bool isLoading = true;
  Color? color;
  final TextEditingController cityController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=2af684c624330f93d27e7d31a272f32b&units=metric&#39;'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        temperature = "${data['main']['temp']}°C";
        condition = data['weather'][0]['description'];
        iconUrl =
            "http://openweathermap.org/img/w/${data['weather'][0]['icon']}.png";
        isLoading = false;
        if (data['main']['temp'] > 30) {
          color = Colors.amber;
        } else if (data['main']['temp'] > 20) {
          color = const Color.fromARGB(255, 213, 246, 50);
        } else if (data['main']['temp'] > 10) {
          color = const Color.fromARGB(255, 53, 249, 243);
        } else {
          color = const Color.fromARGB(173, 53, 249, 242);
        }
      });
    } else {
      setState(() {
        temperature = "Не вдалося отримати погоду";
        condition = "";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        title: Text('Погода в $city'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconUrl.isNotEmpty)
                      Image.network(iconUrl, width: 100, height: 100),
                    const SizedBox(height: 20),
                    Text(
                      temperature,
                      style: const TextStyle(
                          fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      condition,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    CitySelector(
                      cities: cities,
                      selectedCity: city,
                      onCitySelected: (newCity) {
                        setState(() {
                          city = newCity;
                          fetchWeather();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color.fromRGBO(255, 255, 255, 0.666),
                          labelText: 'Місто...',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.text,
                        controller: cityController,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 251, 255, 0),
                            textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color.fromARGB(255, 0, 0, 0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                        onPressed: () {
                          city = cityController.text;
                          fetchWeather();
                        },
                        child: const Text('Знайти місто')),
                  ],
                ),
              ),
      ),
    );
  }
}
