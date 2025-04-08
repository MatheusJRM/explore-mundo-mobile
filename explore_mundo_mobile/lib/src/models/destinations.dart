class Destination {
  final String name;
  final String destinationImageUrl;

  Destination({required this.name, required this.destinationImageUrl});

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(name: json['nome'], destinationImageUrl: json['imagem']);
  }
}
