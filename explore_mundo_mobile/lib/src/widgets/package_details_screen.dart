import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/travel_package.dart';

class PackageDetailsScreen extends StatefulWidget {
  final TravelPackage package;
  final bool isBookmarked;
  final Function(String) onBookmarkPressed;
  final VoidCallback? onNavigateToReservations;

  const PackageDetailsScreen({
    super.key,
    required this.package,
    required this.isBookmarked,
    required this.onBookmarkPressed,
    this.onNavigateToReservations,
  });

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  late bool _isBookmarked;
  late TravelPackage _package;

  @override
  void initState() {
    super.initState();
    _package = widget.package;
    _isBookmarked = widget.isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: _package.imageURL,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
              ),
            ),
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Implementar compartilhamento
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _package.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _package.subtitle,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text(' ${_package.rating}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.message,
                        label: 'Contactar',
                        onPressed: () {
                          // Implementar contato
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.directions,
                        label: 'Rota',
                        onPressed: () {
                          // Implementar rota
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.share,
                        label: 'Compartilhar',
                        onPressed: () {
                          // Implementar compartilhamento
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sobre este destino',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _package.description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isBookmarked
                                  ? 'Reserva cancelada'
                                  : 'Pacote reservado com sucesso!',
                              style: const TextStyle(color: Colors.white),
                            ),
                            action: SnackBarAction(
                              label: 'Ver Reservas',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.popUntil(
                                  context,
                                  (route) => route.settings.name == '/home',
                                );
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  widget.onNavigateToReservations?.call();
                                });
                              },
                            ),
                          ),
                        );

                        setState(() {
                          _isBookmarked = !_isBookmarked;
                        });

                        widget.onBookmarkPressed(_package.destination);
                      },
                      child: Text(
                        !_isBookmarked
                            ? 'Reservar por ${_package.price}'
                            : 'Cancelar reserva',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onPressed,
}) {
  return Column(
    children: [
      IconButton(icon: Icon(icon, size: 32), onPressed: onPressed),
      Text(label),
    ],
  );
}
