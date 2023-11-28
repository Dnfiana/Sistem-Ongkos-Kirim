import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../../../data/models/city_model.dart';

class Kota extends GetView<HomeController> {
  const Kota({
    Key? key,
    required this.provId,
    required this.tipe,
  }) : super(key: key);

  final int provId;
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        label: tipe == "asal"
            ? "kabupaten / Kota Asal"
            : "Kabupaten / kota Tujuan",
        showClearButton: true,
        onFind: (String filter) async {
          Uri url = Uri.parse(
              "https://api.rajaongkir.com/starter/city?province=$provId");

          try {
            final response = await http.get(
              url,
              headers: {"key": "6278f08a91c9fb78c982e3a273a20a4b"},
            );
            var data = json.decode(response.body) as Map<String, dynamic>;
            var statusCode = data["rajaongkir"]["status"]["code"];
            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }
            var listAllCity = data["rajaongkir"]["results"] as List<dynamic>;
            var models = City.fromJsonList(listAllCity);
            return models;
          } catch (err) {
            // ignore: avoid_print
            print(err);
            return List<City>.empty();
          }
        },
        onChanged: (cityValue) {
          if (cityValue != null) {
            if (tipe == "asal") {
              controller.kotaAsalId.value = int.parse(cityValue.cityId!);
            } else {
              controller.kotaTujuanId.value = int.parse(cityValue.cityId!);
            }
            controller.showButton();
          } else {
            if (tipe == "asal") {
              print("Tidak memilih Kota / Kabupaten asal manapun");
              controller.kotaAsalId.value = 0;
            } else {
              print("Tidak memilih Kota / Kabupaten tujuan manapun");
              controller.kotaTujuanId.value = 0;
            }
          }
          controller.showButton();
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          hintText: "Cari Kota / Kabupaten",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item.type} ${item.cityName}",
              style: TextStyle(fontSize: 18),
            ),
          );
        },
        itemAsString: (item) => "${item.type} ${item.cityName}",
      ),
    );
  }
}
