class MenuModel {
  final int id;
  final String name;
  final String description;
  final String price;
  final String? imageUrl;

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toString(),
      imageUrl: json['image_url'],
    );
  }
}
