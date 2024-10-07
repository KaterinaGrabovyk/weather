import 'package:flutter/material.dart';

class CitySelector extends StatelessWidget {
  final List<String> cities;
  final String selectedCity;
  final Function(String) onCitySelected;

  const CitySelector({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cities.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              onCitySelected(cities[index]);
            },
            child: Container(
              width: 100,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: selectedCity == cities[index]
                    ? const Color.fromARGB(255, 31, 50, 59)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                cities[index],
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
