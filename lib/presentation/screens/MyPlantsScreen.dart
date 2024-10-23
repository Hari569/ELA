import 'package:flutter/material.dart';
import '/models/plant_model.dart';
import 'PlantDetailScreen.dart';

class MyPlantsScreen extends StatefulWidget {
  const MyPlantsScreen({Key? key}) : super(key: key);

  @override
  _MyPlantsScreenState createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {
  List<Plant> plants = [];

  // Simulated database of plant care details
  final Map<String, Map<String, String>> plantCareDatabase = {
    'Rose': {
      'sunlight': 'Full sun',
      'water': 'Every 2-3 days',
      'fertilization': 'Monthly',
      'pruning': 'Annually',
    },
    'Cactus': {
      'sunlight': 'Direct sun',
      'water': 'Every 2-3 weeks',
      'fertilization': 'Quarterly',
      'pruning': 'Rarely needed',
    },
    // Add more species as needed
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plants'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: plants.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.add_circle, color: Colors.green),
                title: const Text('Add a new plant',
                    style: TextStyle(color: Colors.green)),
                onTap: () => _addNewPlant(context),
              ),
            );
          } else {
            final plant = plants[index - 1];
            return Card(
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.eco, color: Colors.green),
                title: Text(plant.name),
                subtitle: Text(plant.species),
                trailing: Text('${plant.growthPhotos.length} photos'),
                onTap: () => _navigateToPlantDetail(context, plant),
              ),
            );
          }
        },
      ),
    );
  }

  void _addNewPlant(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String species = '';

        return AlertDialog(
          title: const Text('Add a new plant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) => name = value,
                decoration: const InputDecoration(hintText: "Plant Name"),
              ),
              TextField(
                onChanged: (value) => species = value,
                decoration: const InputDecoration(hintText: "Species"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (name.isNotEmpty && species.isNotEmpty) {
                  setState(() {
                    plants.add(_createPlantWithDetails(name, species));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter both name and species')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Plant _createPlantWithDetails(String name, String species) {
    Map<String, String> careDetails = plantCareDatabase[species] ??
        {
          'sunlight': 'Unknown',
          'water': 'Unknown',
          'fertilization': 'Unknown',
          'pruning': 'Unknown',
        };

    return Plant(
      name: name,
      species: species,
      sunlight: careDetails['sunlight']!,
      water: careDetails['water']!,
      fertilization: careDetails['fertilization']!,
      pruning: careDetails['pruning']!,
      growthPhotos: [],
    );
  }

  void _navigateToPlantDetail(BuildContext context, Plant plant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlantDetailScreen(plant: plant),
      ),
    ).then((_) {
      setState(() {});
    });
  }
}
