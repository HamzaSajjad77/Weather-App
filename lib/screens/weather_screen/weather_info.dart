import 'package:flutter/material.dart';

import '/constants/text_styles.dart';
import '/extensions/double.dart';
import '/models/weather.dart';

class WeatherInfo extends StatelessWidget {
  const WeatherInfo({
    super.key,
    required this.weather,
  });

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WeatherInfoTile(
            title: 'Temp',
            value: '${weather.main.temp}°',
            imagePath: 'assets/icons/temperature.png', // Temp image
          ),
          WeatherInfoTile(
            title: 'Wind',
            value: '${weather.wind.speed.kmh} km/h',
            imagePath: 'assets/icons/windspeed.png', // Wind image
          ),
          WeatherInfoTile(
            title: 'Humidity',
            value: '${weather.main.humidity}%',
            imagePath: 'assets/icons/humidity.png', // Humidity image
          ),
        ],
      ),
    );
  }
}

class WeatherInfoTile extends StatelessWidget {
  const WeatherInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.imagePath, // Image path for the icon
  }) : super();

  final String title;
  final String value;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image/Icon for weather information
        Image.asset(
          imagePath,
          width: 40,  // Adjust the size as needed
          height: 40,
        ),
        const SizedBox(height: 10),
        // Title
        Text(
          title,
          style: TextStyles.subtitleText,
        ),
        const SizedBox(height: 10),
        // Value
        Text(
          value,
          style: TextStyles.h3,
        ),
      ],
    );
  }
}
