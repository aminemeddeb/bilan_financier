import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/transaction.dart';
import '../widgets/project_card.dart';
import 'bilan_financier_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final List<Project> projects = [/*
    Project(
      id: '1',
      name: 'Projet Maison',
      transactions: [
        Transaction(
          id: '1',
          description: 'Achat matériaux',
          amount: 1200,
          date: DateTime.now(),
        ),
        Transaction(
          id: '2',
          description: 'Main d’œuvre',
          amount: 800,
          date: DateTime.now(),
        ),
      ],
    ),
    Project(
      id: '2',
      name: 'Projet Bureau',
    ),*/
  ];

  void _addProject() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nouveau projet'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nom du projet',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isEmpty) return;

                setState(() {
                  projects.add(
                    Project(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: controller.text.trim(),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes projets'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];

          return ProjectCard(
            project: project,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BilanFinancierScreen(
                    project: project,
                  ),
                ),
              ).then((_) {
                setState(() {});
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProject,
        child: const Icon(Icons.add),
      ),
    );
  }
}
