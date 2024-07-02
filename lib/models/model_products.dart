class Imagenes {
  final int id;
  final String image;

  Imagenes({
    required this.id,
    required this.image,
  });

  factory Imagenes.fromJson(Map<String, dynamic> json)=> Imagenes(
    id: json["id"], 
    image: json["image"], 
    );

    Map<String,dynamic> toJson() => {
      "id" : id,
      "image" : image,
    };

    Imagenes copy() => Imagenes(
      id : id,
      image : image,
    );
}