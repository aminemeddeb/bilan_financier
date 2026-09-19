import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/project.dart';

class ProjectStorage {
  static const String _fileName = 'projects.json';

  Future<String> get _filePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_fileName';
  }

  Future<List<Project>> loadProjects() async {
    try {
      final file = File(await _filePath);

      if (!await file.exists()) {
        return [];
      }

      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        return [];
      }

      final decoded = jsonDecode(content);
      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((entry) => Project.fromJson(entry))
          .toList();
    } catch (error) {
      debugPrint('Unable to load projects: $error');
      return [];
    }
  }

  Future<void> saveProjects(List<Project> projects) async {
    try {
      final file = File(await _filePath);
      final payload = jsonEncode(
        projects.map((project) => project.toJson()).toList(),
      );

      await file.writeAsString(payload);
    } catch (error) {
      debugPrint('Unable to save projects: $error');
    }
  }
}
