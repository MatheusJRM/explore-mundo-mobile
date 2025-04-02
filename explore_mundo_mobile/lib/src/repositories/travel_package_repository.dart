import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../models/travel_package.dart';

class TravelPackageRepository {
  Future<List<TravelPackage>> getPackages() async {
    final String response = await rootBundle.loadString('assets/data/packages.json');
    final data = await json.decode(response) as List;
    return data.map((json) => TravelPackage.fromJson(json)).toList();
  }
}