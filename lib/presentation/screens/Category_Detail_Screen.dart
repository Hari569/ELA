import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final Color categoryColor;
  final List<Plant> plants;

  CategoryDetailScreen({
    required this.categoryName,
    required this.categoryColor,
    required this.plants,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: categoryColor,
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return PlantCard(plant: plants[index]);
        },
      ),
    );
  }
}

class Plant {
  final String name;
  final String imageUrl;
  final double price;
  final String description;

  Plant({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
}

class PlantCard extends StatelessWidget {
  final Plant plant;

  const PlantCard({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: Image.network(
          plant.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(plant.name),
        subtitle: Text('\₹${plant.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('₹{plant.name} added to cart')),
            );
          },
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(plant.name),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Image.network(
                        plant.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      Text('Price: \₹${plant.price.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      Text(plant.description),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// IndoorPlantsScreen.dart
class IndoorPlantsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Plant> indoorPlants = [
      Plant(
        name: 'Snake Plant',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Spathiphyllum_cochlearispathum_RTBG.jpg/640px-Spathiphyllum_cochlearispathum_RTBG.jpg',
        price: 15.99,
        description: 'Low-maintenance plant that purifies air.',
      ),
      Plant(
        name: 'Pothos',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Spathiphyllum_cochlearispathum_RTBG.jpg/640px-Spathiphyllum_cochlearispathum_RTBG.jpg',
        price: 12.99,
        description: 'Fast-growing vine with heart-shaped leaves.',
      ),
      Plant(
        name: 'Peace Lily',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Spathiphyllum_cochlearispathum_RTBG.jpg/640px-Spathiphyllum_cochlearispathum_RTBG.jpg',
        price: 18.99,
        description:
            'Elegant plant with white flowers, great for air purification.',
      ),
    ];

    return CategoryDetailScreen(
      categoryName: 'Indoor Plants',
      categoryColor: Colors.green[100]!,
      plants: indoorPlants,
    );
  }
}

// OutdoorPlantsScreen.dart
class OutdoorPlantsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Plant> outdoorPlants = [
      Plant(
        name: 'Lavender',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Lavandula_angustifolia_002.JPG/640px-Lavandula_angustifolia_002.JPG',
        price: 9.99,
        description: 'Fragrant purple flowers, attracts butterflies.',
      ),
      Plant(
        name: 'Sunflower',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/40/Sunflower_sky_backdrop.jpg/640px-Sunflower_sky_backdrop.jpg',
        price: 7.99,
        description: 'Tall plant with large, yellow flowers.',
      ),
      Plant(
        name: 'Hydrangea',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Hydrangea_macrophylla_-_Bigleaf_hydrangea.jpg/640px-Hydrangea_macrophylla_-_Bigleaf_hydrangea.jpg',
        price: 14.99,
        description: 'Showy flowers that bloom in various colors.',
      ),
    ];

    return CategoryDetailScreen(
      categoryName: 'Outdoor Plants',
      categoryColor: Colors.blue[100]!,
      plants: outdoorPlants,
    );
  }
}

// SucculentsScreen.dart
class SucculentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Plant> succulents = [
      Plant(
        name: 'Echeveria',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Echeveria_pulidonis_2.jpg/640px-Echeveria_pulidonis_2.jpg',
        price: 8.99,
        description: 'Rosette-shaped succulent with colorful leaves.',
      ),
      Plant(
        name: 'Aloe Vera',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Aloe_vera_flower_inset.png/640px-Aloe_vera_flower_inset.png',
        price: 11.99,
        description: 'Medicinal plant with thick, fleshy leaves.',
      ),
      Plant(
        name: 'Jade Plant',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Crassula_ovata_17092015.jpg/640px-Crassula_ovata_17092015.jpg',
        price: 9.99,
        description: 'Easy-to-grow succulent with oval-shaped leaves.',
      ),
    ];

    return CategoryDetailScreen(
      categoryName: 'Succulents',
      categoryColor: Colors.orange[100]!,
      plants: succulents,
    );
  }
}

// HerbsScreen.dart
class HerbsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Plant> herbs = [
      Plant(
        name: 'Basil',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Basil-Basilico-Ocimum_basilicum-albahaca.jpg/640px-Basil-Basilico-Ocimum_basilicum-albahaca.jpg',
        price: 5.99,
        description: 'Aromatic herb used in many cuisines.',
      ),
      Plant(
        name: 'Mint',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Mentha_x_piperita_-_Köhler%E2%80%93s_Medizinal-Pflanzen-094.jpg/640px-Mentha_x_piperita_-_Köhler%E2%80%93s_Medizinal-Pflanzen-094.jpg',
        price: 4.99,
        description: 'Refreshing herb used in teas and cocktails.',
      ),
      Plant(
        name: 'Rosemary',
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/A_bundle_of_rosemary.jpg/640px-A_bundle_of_rosemary.jpg',
        price: 6.99,
        description: 'Fragrant herb used in cooking and aromatherapy.',
      ),
    ];

    return CategoryDetailScreen(
      categoryName: 'Herbs',
      categoryColor: Colors.purple[100]!,
      plants: herbs,
    );
  }
}

// FlowersScreen.dart
class FlowersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Plant> flowers = [
      Plant(
        name: 'Rose',
        imageUrl: 'https://example.com/rose.jpg',
        price: 100,
        description: 'Classic flower known for its beauty and fragrance.',
      ),
      Plant(
        name: 'Tulip',
        imageUrl: 'https://example.com/tulip.jpg',
        price: 90,
        description: 'Spring-blooming flower with cup-shaped blossoms.',
      ),
      Plant(
        name: 'Daisy',
        imageUrl: 'https://example.com/daisy.jpg',
        price: 70,
        description: 'Cheerful flower with white petals and yellow center.',
      ),
      // Add more flowers...
    ];

    return CategoryDetailScreen(
      categoryName: 'Flowers',
      categoryColor: Colors.pink[100]!,
      plants: flowers,
    );
  }
}

// TreesScreen.dart
class TreesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Plant> trees = [
      Plant(
        name: 'Maple Tree',
        imageUrl: 'https://example.com/maple_tree.jpg',
        price: 490,
        description: 'Deciduous tree known for its colorful autumn foliage.',
      ),
      Plant(
        name: 'Oak Tree',
        imageUrl: 'https://example.com/oak_tree.jpg',
        price: 590,
        description: 'Strong, long-lived tree that provides excellent shade.',
      ),
      Plant(
        name: 'Bonsai Tree',
        imageUrl: 'https://example.com/bonsai_tree.jpg',
        price: 390,
        description: 'Miniature tree grown in a container for decoration.',
      ),
      // Add more trees...
    ];

    return CategoryDetailScreen(
      categoryName: 'Trees',
      categoryColor: Colors.teal[100]!,
      plants: trees,
    );
  }
}

// SeedsScreen.dart
class SeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Plant> seeds = [
      Plant(
        name: 'Tomato Seeds',
        imageUrl: 'https://example.com/tomato_seeds.jpg',
        price: 30,
        description: 'Seeds for growing juicy, homegrown tomatoes.',
      ),
      Plant(
        name: 'Sunflower Seeds',
        imageUrl: 'https://example.com/sunflower_seeds.jpg',
        price: 20,
        description: 'Seeds for tall, sun-loving flowers.',
      ),
      Plant(
        name: 'Herb Seed Mix',
        imageUrl: 'https://example.com/herb_seed_mix.jpg',
        price: 50,
        description: 'Mix of seeds for growing various culinary herbs.',
      ),
      // Add more seeds...
    ];

    return CategoryDetailScreen(
      categoryName: 'Seeds',
      categoryColor: Colors.amber[100]!,
      plants: seeds,
    );
  }
}

// GardeningToolsScreen.dart
class GardeningToolsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Plant> tools = [
      Plant(
        name: 'Garden Trowel',
        imageUrl: 'https://example.com/garden_trowel.jpg',
        price: 120,
        description:
            'Hand tool for digging, applying, smoothing, or moving small amounts of materials.',
      ),
      Plant(
        name: 'Pruning Shears',
        imageUrl: 'https://example.com/pruning_shears.jpg',
        price: 190,
        description: 'Tool for trimming and shaping plants.',
      ),
      Plant(
        name: 'Watering Can',
        imageUrl: 'https://example.com/watering_can.jpg',
        price: 150,
        description:
            'Container for watering plants with a spout for directed watering.',
      ),
      // Add more gardening tools...
    ];

    return CategoryDetailScreen(
      categoryName: 'Gardening Tools',
      categoryColor: Colors.brown[100]!,
      plants: tools,
    );
  }
}
