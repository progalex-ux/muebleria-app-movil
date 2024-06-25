class Imagenes {
  final int id;
  final String image;
  final String title;
  final String description;

  Imagenes({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
  });

  factory Imagenes.fromJson(Map<String, dynamic> json) => Imagenes(
    id: json["id"],
    image: json["image"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "title": title,
    "description": description,
  };

  Imagenes copy() => Imagenes(
    id: id,
    image: image,
    title: title,
    description: description,
  );
}