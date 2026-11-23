/// Kumpulan fungsi validasi modular untuk formulir tambah pengalaman.
/// Disesuaikan dengan aturan model Experience pada backend Django.
class ExperienceValidators {
  /// Memvalidasi judul pengalaman: wajib diisi dan maksimal 255 karakter.
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul pengalaman tidak boleh kosong!';
    }
    if (value.trim().length > 255) {
      return 'Judul pengalaman maksimal 255 karakter!';
    }
    return null;
  }

  /// Memvalidasi deskripsi pengalaman: wajib diisi dan tidak hanya spasi.
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deskripsi pengalaman tidak boleh kosong!';
    }
    return null;
  }

  /// Memvalidasi URL thumbnail (opsional).
  /// Jika diisi, harus menggunakan skema http atau https dengan host yang valid.
  static String? validateThumbnailUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(value.trim());
    final isValidScheme =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    if (!isValidScheme) {
      return 'Masukkan URL valid yang diawali http:// atau https://';
    }
    return null;
  }

  /// Memvalidasi tanggal mulai: wajib dipilih.
  static String? validateStartDate(DateTime? startDate) {
    if (startDate == null) {
      return 'Tanggal mulai tidak boleh kosong!';
    }
    return null;
  }

  /// Memvalidasi tanggal selesai berdasarkan status sedang berlangsung
  /// dan memastikan tanggal selesai tidak mendahului tanggal mulai.
  static String? validateEndDate({
    required DateTime? endDate,
    required DateTime? startDate,
    required bool isOngoing,
  }) {
    if (isOngoing) {
      return null;
    }
    if (endDate == null) {
      return 'Pilih tanggal selesai atau aktifkan status masih berlangsung!';
    }
    if (startDate != null && endDate.isBefore(startDate)) {
      return 'Tanggal selesai tidak boleh lebih awal dari tanggal mulai!';
    }
    return null;
  }
}
