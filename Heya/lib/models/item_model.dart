import 'package:flutter/material.dart';

class Item {
  const Item(this.name, this.icon);
  final String name;
  final Icon icon;
}

class States {
  const States(this.name, this.id, this.cities);
  final String name;
  final int id;
  final List<City> cities;
}

class City {
  const City(this.name, this.id);
  final String name;
  final int id;
}

List<States> getLocations() {
  List<States> states = List();
  List<String> cities = [
    "Tunis",
    "Nabeul",
    "Mannouba",
    "Gabes",
    "Sfax",
    "Tataouin",
    "Beja",
    "Bizerte",
  ];
  int c = -1;
  cities.forEach((e) {
    c++;
    States s = States(e, c, loadCities(c, 5));
    states.add(s);
  });
  return states;
}

List<City> loadCities(int index, int n) {
  List<City> cities = List();
  if (index > 0) {
    index = n * index;
  }
  for (int i = index; i < index + n; i++) {
    cities.add(City("city ${i + 1}", i));
  }
  return cities;
}
