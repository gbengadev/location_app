import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:location_app/constants/constants.dart';
import 'package:location_app/constants/styles.dart';
import 'package:location_app/full_screen_modal.dart';
import 'package:logger/web.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final Map<String, String>? country;
  final bool showCountry;

  const HomePage({super.key, this.country, required this.showCountry});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  var logger = Logger();
  Map<String, List<String>> allCountries = {};
  Map<String, List<String>> countries = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  //Show full screen modal
  void _showFullScreenModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor:
          Colors.transparent, // Make the modal background transparent
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: DraggableScrollableSheet(
            initialChildSize: 1.0,
            expand: false,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16.0)),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  child: SafeArea(
                      child: CountrySearchModal(
                    allCountries: allCountries,
                    scrollController: scrollController,
                    onCountrySelected: setCountry(),
                  )),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: Center(
          child: _loading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      const Image(
                        image: AssetImage('assets/location.png'),
                        height: 100,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Choose Your Country",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "Please select your country to help us give you a better experience",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: textColour, fontWeight: bold),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              _showFullScreenModal(context);
                            },
                            child: Card(
                              elevation: 4,
                              shadowColor: textColour,
                              child: widget.showCountry
                                  ? Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: [
                                          Image.network(
                                            widget.country!.values.elementAt(0),
                                            height: 30,
                                            width: 30,
                                          ),
                                          const SizedBox(width: 15),
                                          Text(widget.country!.keys
                                              .elementAt(0)),
                                          const Spacer(),
                                          const Image(
                                            image: AssetImage(
                                                'assets/right-arrow.png'),
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(14.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Select Country",
                                            style: TextStyle(
                                              color: textColour,
                                              fontWeight: bold,
                                            ),
                                          ),
                                          Image(
                                            image: AssetImage(
                                                'assets/right-arrow.png'),
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          )),
                      const SizedBox(
                        height: 180,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: widget.showCountry ? () {} : null,
                          child: const Text("Go ahead"),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            image: AssetImage('assets/google.png'),
                            height: 30,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(textColour)),
                            child: const Text("Continue with another Gmail"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

//Fetches all countries from 'https://freetestapi.com/api/v1/countries'
  Future<void> fetchCountries() async {
    if (allCountries.isEmpty) {
      final response = await http.get(Uri.parse(urlString));
      final List<dynamic> countryJson = json.decode(response.body);
// If the server returns a 200 OK response, parse the JSON
      if (response.statusCode == 200) {
        String? previousLetter;
        setState(() {
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

          _loading = false;
        });
      }
      //Throw an exception if another staus code is returned
      else {
        setState(() {
          _loading = false;
        });
        throw Exception('Failed to load list');
      }
    }
  }

  setCountry() {
    // if (mounted) {
    //   setState(() {});
    // }
  }
}
