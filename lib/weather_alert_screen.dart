import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherAlertScreen extends StatefulWidget {
  const WeatherAlertScreen({super.key});

  @override
  _WeatherAlertScreenState createState() => _WeatherAlertScreenState();
}

class _WeatherAlertScreenState extends State<WeatherAlertScreen> {
  String apiKey = '9d6fb52e238d73b5c1ff8e955839e6f3';
  String location = 'Cagayan de Oro';
  List<String> alerts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherAlerts();
  }

  Future<void> fetchWeatherAlerts() async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey'
    );
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    setState(() {
      alerts.clear();
      alerts.add('Weather: ${data['weather'][0]['description']}');
      alerts.add('Temperature: ${(data['main']['temp'] - 273.15).toStringAsFixed(1)}°C');
      alerts.add('Humidity: ${data['main']['humidity']}%');
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weather Alerts")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(Icons.cloud),
                title: Text(alerts[index]),
              ),
            ),
    );
  }
}
