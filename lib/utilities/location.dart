import 'dart:developer';

import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверка, включена ли служба геолокации
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log('Служба местоположения отключена.');
      return;
    }

    // Проверка разрешений
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        log('Разрешение на доступ к местоположению отклонено.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      log('Разрешение на доступ к местоположению отклонено навсегда.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      latitude = position.latitude;
      longitude = position.longitude;
      log('Текущее местоположение: широта: $latitude, долгота: $longitude');
    } catch (e) {
      log('Что-то пошло не так: $e');
    }
  }
}