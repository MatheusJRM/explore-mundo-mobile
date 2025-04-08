// lib/src/repositories/destination_repository.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:my_app/src/models/destinations.dart';

class DestinationRepository {
  Future<List<Destination>> getDestinations() async {
    final String response = await rootBundle.loadString(
      'assets/data/destinations.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Destination.fromJson(json)).toList();
  }
}
