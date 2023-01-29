// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';

class ContributorViewModel {
  String name;
  String link;
  String imageUrl;
  String description;
  int sortRank;

  ContributorViewModel({
    required this.name,
    required this.link,
    required this.imageUrl,
    required this.description,
    required this.sortRank,
  });

  factory ContributorViewModel.fromRawJson(String str) =>
      ContributorViewModel.fromJson(json.decode(str));

  factory ContributorViewModel.fromJson(Map<String, dynamic> json) =>
      ContributorViewModel(
        name: readStringSafe(json, 'name'),
        link: readStringSafe(json, 'link'),
        imageUrl: readStringSafe(json, 'imageUrl'),
        description: readStringSafe(json, 'description'),
        sortRank: readIntSafe(json, 'sortRank'),
      );
}
