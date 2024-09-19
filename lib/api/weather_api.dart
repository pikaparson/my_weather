import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/weather_forecast_daily.dart';
import '../utilities/constants.dart';
import '../utilities/location.dart';

class WeatherApi {
  Future<WeatherForecast> fetchWeatherForecast(
      {String? city, bool? isCity}) async {
    Location location = Location();
    await location.getCurrentLocation();
    Map<String, String?> parameters;
    var uri;
    if (isCity == true) {
      var params = {
        'q': city,
        'appid': Constants.WEATHER_APP_ID,
        'units': 'metric'
      };
      parameters = params;
      uri = Uri.https(Constants.WEATHER_BASE_URL_DOMAIN,
          Constants.WEATHER_FORECAST_PATH, parameters);
    } else {
      var params = {
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
        'appid': Constants.WEATHER_APP_ID,
        'units': 'metric',
      };
      parameters = params;
      uri = Uri.https(Constants.WEATHER_BASE_URL_DOMAIN,
          Constants.WEATHER_FORECAST_PATH_COORDINATES, parameters);
    }


    log('request: ${uri.toString()}');

    var response = await http.get(uri);

    // print('response: ${response.body}');
    log('response: ${response.body}');

    if (response.statusCode == 200) {
      return WeatherForecast.fromJson(json.decode(response.body));
    } else {
      return Future.error('Error response');
    }
  }
}