import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/transaction.dart';
import '../services/project_storage.dart';
import '../widgets/project_card.dart';
import 'bilan_financier_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final ProjectStorage _storage = ProjectStorage();
  final List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final storedProjects = await _storage.loadProjects();

    if (!mounted) return;

    setState(() {
      projects
        ..clear()
        ..addAll(storedProjects);
    });
  }

  Future<void> _saveProjects() async {
    await _storage.saveProjects(projects);
  }

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

                _saveProjects();
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
                    onProjectUpdated: (updatedProject) {
                      setState(() {
                        final index = projects.indexWhere(
                          (candidate) => candidate.id == updatedProject.id,
                        );

                        if (index != -1) {
                          projects[index] = updatedProject;
                        }
                      });
                      _saveProjects();
                    },
                  ),
                ),
              );
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
