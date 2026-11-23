import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Halaman detail untuk menampilkan informasi lengkap sebuah proyek.
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  static const Map<String, String> _categoryLabels = {
    'competition': 'Competition',
    'community': 'Community',
    'academic': 'Academic',
    'personal': 'Personal Project',
  };

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final categoryLabel = _categoryLabels[project.category] ?? project.category;
    final hasThumbnail = project.thumbnail.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          project.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasThumbnail) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  project.thumbnail.trim(),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 160,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.broken_image_outlined, size: 40),
                          SizedBox(height: 8),
                          Text('Gagal memuat gambar proyek'),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
            ],
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                Chip(
                  avatar: const Icon(Icons.category_outlined, size: 18),
                  label: Text(categoryLabel),
                ),
                Chip(
                  avatar: Icon(
                    project.isStarred ? Icons.star : Icons.star_border,
                    size: 18,
                    color: Colors.amber.shade700,
                  ),
                  label: Text('${project.starCount} Stars'),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            if (project.startedAt != null)
              Text(
                'Periode: ${_formatDate(project.startedAt!)} - '
                '${project.endedAt != null ? _formatDate(project.endedAt!) : 'Masih Berlangsung'}',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey.shade700),
              ),
            const Divider(height: 28.0),
            Text(
              'Deskripsi',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              project.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
