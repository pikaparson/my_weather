import 'package:flutter/material.dart';
import 'package:my_weather/api/weather_api.dart';
import 'package:my_weather/models/weather_forecast_daily.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_weather/screens/city_screen.dart';
import 'package:my_weather/widgets/bottom_list_view.dart';
import 'package:my_weather/widgets/city_view.dart';
import 'package:my_weather/widgets/detail_view.dart';

import '../widgets/temp_view.dart';

class WeatherForecastScreen extends StatefulWidget {
  const WeatherForecastScreen({super.key});

  @override
  State<WeatherForecastScreen> createState() => _WeatherForecastScreenState();
}

class _WeatherForecastScreenState extends State<WeatherForecastScreen> {
  late Future<WeatherForecast> forecastObject;
  String _cityName = 'Tomsk';
  //String _cityName = '';


  @override
  void initState() {
    super.initState();
    forecastObject = WeatherApi().fetchWeatherForecastWithCity(cityName: _cityName);
   // forecastObject.then((weather) {
   //   print(weather.list![0].weather![0].main);
   // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('openweathermap.org', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.my_location, color: Colors.white,)
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                var tappedName = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CityScreen();
                }));
                if (tappedName != null) {
                  _cityName = tappedName;
                  forecastObject = WeatherApi().fetchWeatherForecastWithCity(cityName: _cityName);
                }
              },
              icon: Icon(Icons.location_city, color: Colors.white)
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: FutureBuilder<WeatherForecast>(
                future: forecastObject,
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        SizedBox(height: 50),
                        CityView(snapshot: snapshot),
                        SizedBox(height: 50),
                        TempView(snapshot: snapshot),
                        SizedBox(height: 50),
                        DetailView(snapshot: snapshot),
                        SizedBox(height: 50),
                        BottomListView(snapshot: snapshot),
                      ],
                    );
                  } else {
                    return const Center(
                      child: SpinKitDoubleBounce(
                        color: Colors.black87,
                        size: 100,
                      ),
                    );
                  }
                },
            ),
          )
        ],
      ),
    );
  }
}
