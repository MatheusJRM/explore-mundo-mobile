# 🌍 Explore Mundo - App de Pacotes de Viagens

Aplicativo Flutter para explorar pacotes de viagens, com funcionalidades de pesquisa e reserva.

## ✨ Funcionalidades

- **Exploração por Destino**  
  Visualize pacotes agrupados por região geográfica

- **Sistema de Reservas**  
  Salve pacotes favoritos para consulta posterior

- **Busca Inteligente**  
  Filtre pacotes por título, destino ou características

- **Detalhes Completos**  
  Tela dedicada com informações detalhadas de cada pacote

## 🛠️ Tecnologias Utilizadas

| Tecnologia            | Finalidade                          |
|-----------------------|-------------------------------------|
| Flutter 3.29.2        | Framework cross-platform            |
| Dart 3.7.2            | Linguagem de programação            |
| Cached Network Image  | Cache de imagens remotas            |

## Estrutura do Projeto

lib/
├── src/
      ├── models/ # Modelos de dados
│         ├── travel_package.dart
│         └── destination.dart
|     ├── repositories/ # Fontes de dados
│         ├── destinations_repository.dart
│         └── travel_package_repository.dart
|     ├── pages/ # Telas do app
|           ├── home/
|                 ├── home_page.dart
│           ├── landing/
|                 ├── landing-page.dart
|     ├── widgets/ # Componentes reutilizáveis
|           ├── destinations_card.dart
|           ├── package_details_screen.dart
|           ├── region_destination_screen.dart
|           └── travel_package_card.dart
└── main.dart # Ponto de entrada
