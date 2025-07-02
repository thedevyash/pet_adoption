class Pet {
  List<Breeds> breeds; // List of Breeds objects
  String id; // Pet ID
  String url; // Pet image URL
  int width; // Image width
  int height; // Image height

  Pet({
    required this.breeds,
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      breeds: json['breeds'] != null
          ? (json['breeds'] as List).map((v) => Breeds.fromJson(v)).toList()
          : [],
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['breeds'] = breeds.map((v) => v.toJson()).toList();
    data['id'] = id;
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class Breeds {
  String id; // Breed ID
  String name; // Breed name
  String description; // Breed description

  Breeds({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Breeds.fromJson(Map<String, dynamic> json) {
    return Breeds(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
