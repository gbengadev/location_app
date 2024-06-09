// import 'dart:convert';

// import '../constants/constants.dart';
// import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';
import '../constants/constants.dart';
import '../exceptions.dart';

var logger = Logger();

class LocationService {
//Fetches all countries from 'https://freetestapi.com/api/v1/countries'
  Future<List<dynamic>> getCountriesInJson() async {
    try {
      final response = await http.get(Uri.parse(urlString));
      if (response.statusCode == 200) {
        final List<dynamic> countryJson = json.decode(response.body);
        return countryJson;
      } else {
        throw StatusCodeException();
      }
    } catch (_) {
      throw NetworkErrorException();
    }
  }

  void addCountriesToMap(
      List<dynamic> countryJson, Map<String, List<String>> allCountries) {
    String? previousLetter;
    for (var country in countryJson) {
      String countryName = country['name'];
      String firstLetter = countryName[0].toUpperCase();
      if (firstLetter != previousLetter) {
        allCountries[countryName] = [country['flag'], firstLetter];
        previousLetter = firstLetter;
      } else {
        allCountries[countryName] = [country['flag'], ""];
      }
    }
  }

  void shoWSnackBarMessage(String message, BuildContext context) {
    SnackBar snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleExceptions(Object e, BuildContext context) {
    String? message;
    if (e is NetworkErrorException) {
      message = 'Unable to fetch countries.Please check your network';
      shoWSnackBarMessage(message, context);
    } else if (e is StatusCodeException) {
      message = ('Unable to fetch countries at the moment.');
      shoWSnackBarMessage(message, context);
    }
  }

  Future<void> fetchCountries(
      Map<String, List<String>> allCountries, BuildContext context) async {
    try {
      final List<dynamic> countryJson = await getCountriesInJson();
      addCountriesToMap(countryJson, allCountries);
    } catch (e) {
      handleExceptions(e, context);
    }
  }
}
