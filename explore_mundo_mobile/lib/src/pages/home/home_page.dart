import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_app/src/models/travel_package.dart';
import 'package:my_app/src/repositories/travel_package_repository.dart';
import 'widgets/travel_package_card.dart';
import 'widgets/package_details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TravelPackageRepository _repository = TravelPackageRepository();
  late Future<List<TravelPackage>> _packagesFuture;
  final Set<String> _bookmarkedPackages = {};
  String _searchQuery = '';
  int _currentTabIndex = 1; // Começa na aba "Pacotes"

  @override
  void initState() {
    super.initState();
    _packagesFuture = _repository.getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Mundo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TravelPackageSearch(
                  _packagesFuture,
                  _bookmarkedPackages,
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TravelPackage>>(
        future: _packagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum pacote encontrado'));
          }

          final packages = snapshot.data!;

          return IndexedStack(
            index: _currentTabIndex,
            children: [
              // Tab Destinos
              _buildDestinationsTab(packages),

              // Tab Pacotes
              _buildPackagesTab(packages),

              // Tab Reservas
              _buildBookmarksTab(packages),

              // Tab Sobre Nós
              _buildAboutTab(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Destinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket),
            label: 'Pacotes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Reservas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Sobre'),
        ],
      ),
    );
  }

  Widget _buildDestinationsTab(List<TravelPackage> packages) {
    // Agrupa pacotes por região
    final regions = <String, List<TravelPackage>>{};
    for (var package in packages) {
      regions.putIfAbsent(package.relatedRegion, () => []);
      regions[package.relatedRegion]!.add(package);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Explore por Região',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...regions.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: entry.value.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final package = entry.value[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    PackageDetailsScreen(package: package),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: package.imageURL,
                              width: 280,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.error),
                                  ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  package.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPackagesTab(List<TravelPackage> packages) {
    final filteredPackages =
        packages.where((package) {
          return package.title.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              package.subtitle.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
        }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Pesquisar destinos...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child:
              filteredPackages.isEmpty
                  ? const Center(child: Text('Nenhum pacote encontrado'))
                  : ListView.builder(
                    itemCount: filteredPackages.length,
                    itemBuilder: (context, index) {
                      final package = filteredPackages[index];
                      final isBookmarked = _bookmarkedPackages.contains(
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
                                  (context) =>
                                      PackageDetailsScreen(package: package),
                            ),
                          );
                        },
                        onBookmarkPressed: () {
                          setState(() {
                            if (isBookmarked) {
                              _bookmarkedPackages.remove(package.destination);
                            } else {
                              _bookmarkedPackages.add(package.destination);
                            }
                          });
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  Widget _buildBookmarksTab(List<TravelPackage> packages) {
    final bookmarkedPackages =
        packages
            .where((p) => _bookmarkedPackages.contains(p.destination))
            .toList();

    return bookmarkedPackages.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Nenhuma reserva encontrada',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                'Toque no ícone de favoritos para adicionar pacotes',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemCount: bookmarkedPackages.length,
          itemBuilder: (context, index) {
            final package = bookmarkedPackages[index];
            return TravelPackageCard(
              package: package,
              isBookmarked: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PackageDetailsScreen(package: package),
                  ),
                );
              },
              onBookmarkPressed: () {
                setState(() {
                  _bookmarkedPackages.remove(package.destination);
                });
              },
            );
          },
        );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sobre a Explore Mundo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/logo_explore_mundo.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Nossa Missão',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'A Explore Mundo nasceu com o propósito de conectar pessoas a experiências '
            'únicas ao redor do mundo. Acreditamos que cada viagem é uma oportunidade '
            'de crescimento, aprendizado e criação de memórias inesquecíveis.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 24),
          const Text(
            'Nossos Valores',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AboutItem(
                icon: Icons.public,
                text: 'Sustentabilidade em nossas viagens',
              ),
              _AboutItem(
                icon: Icons.people,
                text: 'Respeito à diversidade cultural',
              ),
              _AboutItem(
                icon: Icons.thumb_up,
                text: 'Experiências autênticas e memoráveis',
              ),
              _AboutItem(icon: Icons.star, text: 'Excelência no atendimento'),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Contato',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AboutItem(
                icon: Icons.email,
                text: 'contato@exploremundo.com.br',
              ),
              _AboutItem(icon: Icons.phone, text: '(11) 1234-5678'),
              _AboutItem(
                icon: Icons.location_on,
                text: 'Av. Avenida, 1234 - Xiquexique/BA',
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _AboutItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AboutItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class TravelPackageSearch extends SearchDelegate<String> {
  final Future<List<TravelPackage>> packagesFuture;
  final Set<String> bookmarkedPackages;

  TravelPackageSearch(this.packagesFuture, this.bookmarkedPackages);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<TravelPackage>>(
      future: packagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        final results =
            snapshot.data!
                .where(
                  (p) => p.title.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final package = results[index];
            final isBookmarked = bookmarkedPackages.contains(
              package.destination,
            );

            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: package.imageURL,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(package.title),
              subtitle: Text(package.subtitle),
              trailing: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? Colors.amber : Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => PackageDetailsScreen(package: package),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<TravelPackage>>(
      future: packagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        final suggestions =
            snapshot.data!
                .where(
                  (p) => p.title.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final package = suggestions[index];
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: package.imageURL,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(package.title),
              subtitle: Text(package.subtitle),
              onTap: () {
                query = package.title;
                showResults(context);
              },
            );
          },
        );
      },
    );
  }
}
