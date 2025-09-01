// To parse this JSON data, do
//
//     final menuModel = menuModelFromJson(jsonString);

import 'dart:convert';

MenuModel menuModelFromJson(String str) => MenuModel.fromJson(json.decode(str));

String menuModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
  String? name;
  String? description;
  int? price;
  String? image;

  MenuModel({this.name, this.description, this.price, this.image});

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
    name: json["name"],
    description: json["description"],
    price: json["price"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "price": price,
    "image": image,
  };
}
