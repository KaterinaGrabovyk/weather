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
  Color color = const Color.fromARGB(255, 0, 0, 0);
  Color color2 = const Color.fromARGB(255, 0, 0, 0);

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
      switch (data['weather'][0]['icon']) {
        case '01d' || '01n':
          color2 = const Color.fromARGB(255, 195, 239, 243);
        case '02d' || '02n':
          color2 = const Color.fromARGB(255, 219, 252, 252);
        case '03d' || '03n':
          color2 = const Color.fromARGB(228, 255, 255, 255);
        case '04d' || '04n':
          color2 = const Color.fromARGB(255, 71, 71, 71);
        case '09d' || '09n':
          color2 = const Color.fromARGB(255, 56, 69, 133);
        case '10d' || '10n':
          color2 = const Color.fromARGB(255, 37, 45, 84);
        case '11d' || '11n':
          color2 = const Color.fromARGB(255, 20, 31, 44);
        case '13d' || '13n':
          color2 = const Color.fromARGB(255, 255, 255, 255);
        case '50d' || '50n':
          color2 = const Color.fromARGB(255, 159, 159, 159);
      }
    } else {
      setState(() {
        temperature = "Не вдалося отримати погоду";
        condition = "";
        iconUrl = "";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Погода в $city'),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(begin: Alignment.topLeft, colors: [color2, color]),
        ),
        child: Center(
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
                        textAlign: TextAlign.center,
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
                                  const Color.fromARGB(255, 45, 1, 87),
                              foregroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              textStyle: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
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
      ),
    );
  }
}
