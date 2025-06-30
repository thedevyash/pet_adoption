class Pet {
  final String id;
  final String name;
  final String imageUrl;
  final String breed;
  final String age;
  final double distance; // km away
  final String description;
  final String price; // for details page

  Pet(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.breed,
      required this.age,
      required this.distance,
      required this.description,
      required this.price});

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      price: (json['distance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'breed': breed,
      'age': age,
      'distance': distance,
      'description': description,
      'price': price
    };
  }
}
