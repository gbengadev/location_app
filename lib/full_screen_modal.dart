import 'package:flutter/material.dart';
import 'package:location_app/constants/styles.dart';
import 'package:logger/logger.dart';
import 'homepage.dart';

class CountrySearchModal extends StatefulWidget {
  final Map<String, List<String>> allCountries;
  final ScrollController scrollController;

  const CountrySearchModal({
    super.key,
    required this.allCountries,
    required this.scrollController,
  });

  @override
  State<CountrySearchModal> createState() => _CountrySearchModalState();
}

class _CountrySearchModalState extends State<CountrySearchModal> {
  final TextEditingController searchController = TextEditingController();
  var logger = Logger();
  Map<String, List<String>> countries = {};

  @override
  void initState() {
    super.initState();
    searchController.addListener(queryListner);
  }

  @override
  void dispose() {
    searchController.removeListener(queryListner);
    searchController.dispose();
    super.dispose();
  }

//Listens for keyboard input from the user and filter search based on input.
  void queryListner() {
    searchCountry(searchController.text);
  }

//Searches for countries that match the users input
  void searchCountry(String name) {
    if (name.isEmpty) {
      setState(() {
        countries = widget.allCountries;
      });
    } else {
      setState(() {
        countries = {
          for (var key in widget.allCountries.keys.where(
            (element) => element.toLowerCase().contains(name.toLowerCase()),
          ))
            key: widget.allCountries[key]!
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Select Country",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          SearchBar(
            hintText: "Search Country",
            controller: searchController,
            leading: const Icon(Icons.search),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                controller: widget.scrollController,
                itemCount: countries.isEmpty
                    ? widget.allCountries.length
                    : countries.length,
                itemBuilder: (context, index) {
                  countries =
                      countries.isEmpty ? widget.allCountries : countries;
                  final country = countries.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    showCountry: true,
                                    country: {country: countries[country]![0]},
                                  )));
                    },
                    child: SizedBox(
                      height: 40,
                      child: Row(children: [
                        Image.network(
                          countries[country]![0],
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          country,
                          style: const TextStyle(
                              color: textColour, fontWeight: bold),
                        ),
                        const Spacer(),
                        Text(
                          countries[country]![1],
                          style: const TextStyle(color: textColour),
                        )
                      ]),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
