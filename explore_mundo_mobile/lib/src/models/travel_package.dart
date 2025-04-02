class TravelPackage {
  final String relatedRegion;
  final String destination;
  final double rating;
  final int totalRatings;
  final String price;
  final String title;
  final String subtitle;
  final String description;
  final String imageURL;

  TravelPackage({
    required this.relatedRegion,
    required this.destination,
    required this.rating,
    required this.totalRatings,
    required this.price,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageURL,
  });

  factory TravelPackage.fromJson(Map<String, dynamic> json) {
    return TravelPackage(
      relatedRegion: json['regiaoRelacionada'],
      destination: json['destino'],
      rating: double.parse(json['mediaAvaliacao']),
      totalRatings: int.parse(json['totalAvaliacao']),
      price: json['preco'],
      title: json['titulo'],
      subtitle: json['subtitulo'],
      description: json['descricao'],
      imageURL: json["imagem"],
    );
  }
}
