import 'package:flutter/material.dart';
import 'package:my_app/src/widgets/package_details_screen.dart';
import '../models/travel_package.dart';
import 'travel_package_card.dart';

class RegionDestinationScreen extends StatefulWidget {
  final String regionName;
  final List<TravelPackage> packages;
  final Set<String> bookmarkedPackages;
  final Function(String) onBookmarkPressed;

  const RegionDestinationScreen({
    super.key,
    required this.regionName,
    required this.packages,
    required this.bookmarkedPackages,
    required this.onBookmarkPressed,
  });

  @override
  State<RegionDestinationScreen> createState() =>
      _RegionDestinationScreenState();
}

class _RegionDestinationScreenState extends State<RegionDestinationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pacotes em ${widget.regionName}')),
      body:
          widget.packages.isEmpty
              ? const Center(
                child: Text('Nenhum pacote encontrado para esta região'),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.packages.length,
                itemBuilder: (context, index) {
                  final package = widget.packages[index];
                  final isBookmarked = widget.bookmarkedPackages.contains(
                    package.destination,
                  );
                  return TravelPackageCard(
                    package: package,
                    isBookmarked: isBookmarked,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PackageDetailsScreen(
                                package: package,
                                isBookmarked: isBookmarked,
                                onBookmarkPressed: (destination) {
                                  widget.onBookmarkPressed(destination);
                                  setState(() {}); // Atualiza o estado local
                                },
                              ),
                        ),
                      );
                    },
                    onBookmarkPressed: () {
                      widget.onBookmarkPressed(package.destination);
                      setState(() {}); // Atualiza o estado local
                    },
                  );
                },
              ),
    );
  }
}
