import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/utils/experience_validators.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

/// Halaman formulir untuk menambahkan data pengalaman baru (Experience).
/// Menggunakan StatefulWidget untuk mengelola input teks, dropdown kategori,
/// pemilih tanggal, dan status sedang berlangsung.
class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field teks dan tampilan tanggal agar mudah di-reset
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String _category = 'full-time';
  DateTime? _startedAt;
  DateTime? _endedAt;
  bool _isOngoing = false;

  // Pilihan kategori sesuai Experience.EXPERIENCE_CHOICES di Django
  static const Map<String, String> _experienceCategories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  /// Memformat objek DateTime menjadi string dd/MM/yyyy.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Membuka date picker untuk memilih tanggal mulai pengalaman.
  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startedAt ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal Mulai',
    );
    if (picked != null) {
      setState(() {
        _startedAt = picked;
        _startDateController.text = _formatDate(picked);
      });
    }
  }

  /// Membuka date picker untuk memilih tanggal selesai pengalaman.
  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endedAt ?? _startedAt ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Pilih Tanggal Selesai',
    );
    if (picked != null) {
      setState(() {
        _endedAt = picked;
        _endDateController.text = _formatDate(picked);
      });
    }
  }

  /// Mengatur ulang seluruh isian formulir ke kondisi awal.
  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _thumbnailController.clear();
    _startDateController.clear();
    _endDateController.clear();
    setState(() {
      _category = 'full-time';
      _startedAt = null;
      _endedAt = null;
      _isOngoing = false;
    });
  }

  /// Memvalidasi formulir dan menampilkan ringkasan data dalam AlertDialog.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final categoryLabel = _experienceCategories[_category] ?? _category;
      final thumbnailText = _thumbnailController.text.trim().isEmpty
          ? '-'
          : _thumbnailController.text.trim();
      final endDateText = _isOngoing
          ? 'Masih Berlangsung'
          : _formatDate(_endedAt!);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Pengalaman Berhasil Disimpan!'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSummaryRow('Judul', _titleController.text.trim()),
                  _buildSummaryRow('Kategori', categoryLabel),
                  _buildSummaryRow(
                    'Deskripsi',
                    _descriptionController.text.trim(),
                  ),
                  _buildSummaryRow('Thumbnail', thumbnailText),
                  _buildSummaryRow('Mulai', _formatDate(_startedAt!)),
                  _buildSummaryRow('Selesai', endDateText),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    }
  }

  /// Helper widget untuk menampilkan baris label-nilai pada dialog ringkasan.
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14.0),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Pengalaman',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // === Judul Pengalaman ===
              TextFormField(
                controller: _titleController,
                maxLength: 255,
                decoration: InputDecoration(
                  labelText: 'Judul Pengalaman',
                  hintText: 'Contoh: Software Engineer Intern di Fasilkom UI',
                  prefixIcon: const Icon(Icons.work_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: ExperienceValidators.validateTitle,
              ),
              const SizedBox(height: 12.0),

              // === Kategori Pengalaman ===
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: 'Kategori Pengalaman',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                items: _experienceCategories.entries
                    .map(
                      (entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _category = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0),

              // === Deskripsi Pengalaman ===
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Deskripsi Pengalaman',
                  hintText: 'Jelaskan peran, tanggung jawab, dan pencapaianmu',
                  alignLabelWithHint: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60.0),
                    child: Icon(Icons.description_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: ExperienceValidators.validateDescription,
              ),
              const SizedBox(height: 16.0),

              // === URL Thumbnail (Opsional) ===
              TextFormField(
                controller: _thumbnailController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'URL Thumbnail (Opsional)',
                  hintText: 'https://example.com/gambar.png',
                  prefixIcon: const Icon(Icons.link),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: ExperienceValidators.validateThumbnailUrl,
              ),
              const SizedBox(height: 16.0),

              // === Tanggal Mulai ===
              TextFormField(
                controller: _startDateController,
                readOnly: true,
                onTap: _pickStartDate,
                decoration: InputDecoration(
                  labelText: 'Tanggal Mulai',
                  hintText: 'Pilih tanggal mulai',
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  suffixIcon: const Icon(Icons.arrow_drop_down),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (_) =>
                    ExperienceValidators.validateStartDate(_startedAt),
              ),
              const SizedBox(height: 8.0),

              // === Switch Status Masih Berlangsung (Fitur Ekstra UX) ===
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Masih berlangsung saat ini'),
                subtitle: const Text(
                  'Aktifkan jika pengalaman belum memiliki tanggal selesai',
                ),
                value: _isOngoing,
                onChanged: (bool value) {
                  setState(() {
                    _isOngoing = value;
                    if (_isOngoing) {
                      _endedAt = null;
                      _endDateController.clear();
                    }
                  });
                },
              ),
              const SizedBox(height: 8.0),

              // === Tanggal Selesai (Aktif jika tidak sedang berlangsung) ===
              if (!_isOngoing) ...[
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  onTap: _pickEndDate,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Selesai',
                    hintText: 'Pilih tanggal selesai',
                    prefixIcon: const Icon(Icons.event_available_outlined),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (_) => ExperienceValidators.validateEndDate(
                    endDate: _endedAt,
                    startDate: _startedAt,
                    isOngoing: _isOngoing,
                  ),
                ),
                const SizedBox(height: 20.0),
              ] else
                const SizedBox(height: 12.0),

              // === Tombol Aksi (Reset & Simpan) ===
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
