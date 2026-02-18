// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class L10nId extends L10n {
  L10nId([String locale = 'id']) : super(locale);

  @override
  String get networkErrorDnsFailureUser =>
      'Tidak dapat terhubung ke server.\n• Periksa koneksi internet Anda\n• Matikan VPN/DNS jika aktif\n• Coba lagi dalam beberapa saat';

  @override
  String get networkErrorConnectionUser =>
      'Koneksi terputus.\n• Periksa koneksi internet Anda\n• Pastikan WiFi/data aktif\n• Coba lagi dalam beberapa saat';

  @override
  String get networkErrorTimeoutUser =>
      'Koneksi timeout.\n• Periksa kecepatan internet Anda\n• Coba lagi dalam beberapa saat\n• Hubungi admin jika masalah berlanjut';

  @override
  String get networkErrorReceiveTimeoutUser =>
      'Server terlalu lama merespons.\n• Koneksi internet Anda mungkin lambat\n• Coba lagi dalam beberapa saat\n• Hubungi admin jika masalah berlanjut';

  @override
  String get networkErrorServerUser =>
      'Terjadi kesalahan pada server.\n• Coba lagi dalam beberapa saat\n• Hubungi admin jika masalah berlanjut';

  @override
  String get networkErrorServer502User =>
      'Server sedang tidak dapat dijangkau.\n• Server mungkin sedang maintenance\n• Coba lagi dalam beberapa saat\n• Hubungi admin jika masalah berlanjut';

  @override
  String get networkErrorServer503User =>
      'Layanan sedang dalam pemeliharaan.\n• Tunggu beberapa saat\n• Coba lagi nanti\n• Hubungi admin untuk info lebih lanjut';

  @override
  String get networkErrorServer504User =>
      'Server terlalu lama merespons.\n• Server sedang sibuk\n• Coba lagi dalam beberapa saat\n• Hubungi admin jika masalah berlanjut';

  @override
  String get networkErrorHtmlResponse =>
      'Server mengembalikan HTML, bukan JSON. Periksa konfigurasi endpoint API.';

  @override
  String get networkErrorFileDownloaded => 'File berhasil diunduh';

  @override
  String get networkErrorUnknown => 'Terjadi kesalahan yang tidak diketahui';

  @override
  String get timeAgoJustNow => 'baru saja';

  @override
  String timeAgoMinute(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count menit yang lalu',
      one: '1 menit yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeAgoHour(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jam yang lalu',
      one: '1 jam yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeAgoDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari yang lalu',
      one: '1 hari yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeAgoMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bulan yang lalu',
      one: '1 bulan yang lalu',
    );
    return '$_temp0';
  }

  @override
  String timeAgoYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tahun yang lalu',
      one: '1 tahun yang lalu',
    );
    return '$_temp0';
  }

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'Mei';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Agu';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Okt';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Des';

  @override
  String get dayMon => 'Senin';

  @override
  String get dayTue => 'Selasa';

  @override
  String get dayWed => 'Rabu';

  @override
  String get dayThu => 'Kamis';

  @override
  String get dayFri => 'Jumat';

  @override
  String get daySat => 'Sabtu';

  @override
  String get daySun => 'Minggu';

  @override
  String get currencyBillionSuffix => 'M';

  @override
  String get currencyMillionSuffix => 'jt';

  @override
  String get currencyThousandSuffix => 'rb';

  @override
  String get enumSortOrderAsc => 'Naik (Asc)';

  @override
  String get enumSortOrderDesc => 'Turun (Desc)';

  @override
  String get enumCategorySortByCategoryCode => 'Kode Kategori';

  @override
  String get enumCategorySortByName => 'Nama';

  @override
  String get enumCategorySortByCategoryName => 'Nama Kategori';

  @override
  String get enumCategorySortByCreatedAt => 'Tanggal Dibuat';

  @override
  String get enumCategorySortByUpdatedAt => 'Tanggal Diperbarui';

  @override
  String get enumLocationSortByLocationCode => 'Kode Lokasi';

  @override
  String get enumLocationSortByName => 'Nama';

  @override
  String get enumLocationSortByLocationName => 'Nama Lokasi';

  @override
  String get enumLocationSortByBuilding => 'Gedung';

  @override
  String get enumLocationSortByFloor => 'Lantai';

  @override
  String get enumLocationSortByCreatedAt => 'Tanggal Dibuat';

  @override
  String get enumLocationSortByUpdatedAt => 'Tanggal Diperbarui';

  @override
  String get enumNotificationSortByType => 'Tipe';

  @override
  String get enumNotificationSortByIsRead => 'Status Dibaca';

  @override
  String get enumNotificationSortByCreatedAt => 'Tanggal Diterima';

  @override
  String get enumNotificationSortByTitle => 'Judul';

  @override
  String get enumNotificationSortByMessage => 'Pesan';

  @override
  String get enumScanLogSortByScanTimestamp => 'Waktu Pindai';

  @override
  String get enumScanLogSortByScannedValue => 'Nilai Terpindai';

  @override
  String get enumScanLogSortByScanMethod => 'Metode Pindai';

  @override
  String get enumScanLogSortByScanResult => 'Hasil Pindai';

  @override
  String get enumAssetSortByAssetTag => 'Tag Aset';

  @override
  String get enumAssetSortByAssetName => 'Nama Aset';

  @override
  String get enumAssetSortByBrand => 'Merek';

  @override
  String get enumAssetSortByModel => 'Model';

  @override
  String get enumAssetSortBySerialNumber => 'Nomor Seri';

  @override
  String get enumAssetSortByPurchaseDate => 'Tanggal Beli';

  @override
  String get enumAssetSortByPurchasePrice => 'Harga Beli';

  @override
  String get enumAssetSortByVendorName => 'Nama Vendor';

  @override
  String get enumAssetSortByWarrantyEnd => 'Garansi Berakhir';

  @override
  String get enumAssetSortByStatus => 'Status';

  @override
  String get enumAssetSortByConditionStatus => 'Kondisi';

  @override
  String get enumAssetSortByCreatedAt => 'Tanggal Dibuat';

  @override
  String get enumAssetSortByUpdatedAt => 'Tanggal Diperbarui';

  @override
  String get enumAssetMovementSortByMovementDate => 'Tanggal Pindah';

  @override
  String get enumAssetMovementSortByMovementdate => 'Tanggal Pindah';

  @override
  String get enumAssetMovementSortByCreatedAt => 'Tanggal Dibuat';

  @override
  String get enumAssetMovementSortByCreatedat => 'Tanggal Dibuat';

  @override
  String get enumAssetMovementSortByUpdatedAt => 'Tanggal Diperbarui';

  @override
  String get enumAssetMovementSortByUpdatedat => 'Tanggal Diperbarui';

  @override
  String get enumIssueReportSortByReportedDate => 'Tanggal Lapor';

  @override
  String get enumIssueReportSortByResolvedDate => 'Tanggal Selesai';

  @override
  String get enumIssueReportSortByIssueType => 'Tipe Masalah';

  @override
  String get enumIssueReportSortByPriority => 'Prioritas';

  @override
  String get enumIssueReportSortByStatus => 'Status';

  @override
  String get enumIssueReportSortByTitle => 'Judul';

  @override
  String get enumIssueReportSortByDescription => 'Deskripsi';

  @override
  String get enumIssueReportSortByCreatedAt => 'Tanggal Dibuat';

  @override
  String get enumIssueReportSortByUpdatedAt => 'Tanggal Diperbarui';

  @override
  String get enumMaintenanceScheduleSortByNextScheduledDate =>
      'Jadwal Berikutnya';

  @override
  String get enumMaintenanceScheduleSortByMaintenanceType => 'Tipe Perawatan';

  @override
  String get enumMaintenanceScheduleSortByState => 'Status Jadwal';

  @override
  String get enumMaintenanceScheduleSortByCreatedAt => 'Tanggal Dibuat';

  @override
  String get enumMaintenanceScheduleSortByUpdatedAt => 'Tanggal Diperbarui';

  @override
  String get enumMaintenanceRecordSortByMaintenanceDate => 'Tanggal Perawatan';

  @override
  String get enumMaintenanceRecordSortByActualCost => 'Biaya Aktual';

  @override
  String get enumMaintenanceRecordSortByTitle => 'Judul';

  @override
  String get enumMaintenanceRecordSortByCreatedAt => 'Tanggal Dibuat';

  @override
  String get enumMaintenanceRecordSortByUpdatedAt => 'Tanggal Diperbarui';

  @override
  String get enumUserSortByName => 'Nama';

  @override
  String get enumUserSortByFullName => 'Nama Lengkap';

  @override
  String get enumUserSortByEmail => 'Email';

  @override
  String get enumUserSortByRole => 'Peran';

  @override
  String get enumUserSortByEmployeeId => 'ID Karyawan';

  @override
  String get enumUserSortByIsActive => 'Status Aktif';

  @override
  String get enumUserSortByCreatedAt => 'Tanggal Bergabung';

  @override
  String get enumUserSortByUpdatedAt => 'Tanggal Diperbarui';

  @override
  String get enumExportFormatPdf => 'PDF';

  @override
  String get enumExportFormatExcel => 'Excel';

  @override
  String get enumMutationTypeCreate => 'Buat';

  @override
  String get enumMutationTypeUpdate => 'Ubah';

  @override
  String get enumMutationTypeDelete => 'Hapus';

  @override
  String get enumLanguageEnglish => 'Inggris';

  @override
  String get enumLanguageJapanese => 'Jepang';

  @override
  String get enumLanguageIndonesian => 'Indonesia';

  @override
  String get enumUserRoleAdmin => 'Admin';

  @override
  String get enumUserRoleUser => 'Pengguna';

  @override
  String get enumAssetStatusActive => 'Aktif';

  @override
  String get enumAssetStatusMaintenance => 'Perbaikan';

  @override
  String get enumAssetStatusDisposed => 'Dibuang';

  @override
  String get enumAssetStatusLost => 'Hilang';

  @override
  String get enumAssetConditionGood => 'Baik';

  @override
  String get enumAssetConditionFair => 'Cukup';

  @override
  String get enumAssetConditionPoor => 'Buruk';

  @override
  String get enumAssetConditionDamaged => 'Rusak';

  @override
  String get enumNotificationTypeMaintenance => 'Perbaikan';

  @override
  String get enumNotificationTypeWarranty => 'Garansi';

  @override
  String get enumNotificationTypeIssue => 'Masalah';

  @override
  String get enumNotificationTypeMovement => 'Perpindahan';

  @override
  String get enumNotificationTypeStatusChange => 'Perubahan Status';

  @override
  String get enumNotificationTypeLocationChange => 'Perubahan Lokasi';

  @override
  String get enumNotificationTypeCategoryChange => 'Perubahan Kategori';

  @override
  String get enumNotificationPriorityLow => 'Rendah';

  @override
  String get enumNotificationPriorityNormal => 'Normal';

  @override
  String get enumNotificationPriorityHigh => 'Tinggi';

  @override
  String get enumNotificationPriorityUrgent => 'Mendesak';

  @override
  String get enumScanMethodTypeDataMatrix => 'Data Matrix';

  @override
  String get enumScanMethodTypeManualInput => 'Input Manual';

  @override
  String get enumScanResultTypeSuccess => 'Berhasil';

  @override
  String get enumScanResultTypeInvalidID => 'ID Tidak Valid';

  @override
  String get enumScanResultTypeAssetNotFound => 'Aset Tidak Ditemukan';

  @override
  String get enumMaintenanceScheduleTypePreventive => 'Preventif';

  @override
  String get enumMaintenanceScheduleTypeCorrective => 'Korektif';

  @override
  String get enumMaintenanceScheduleTypeInspection => 'Inspeksi';

  @override
  String get enumMaintenanceScheduleTypeCalibration => 'Kalibrasi';

  @override
  String get enumScheduleStateActive => 'Aktif';

  @override
  String get enumScheduleStatePaused => 'Ditunda';

  @override
  String get enumScheduleStateStopped => 'Dihentikan';

  @override
  String get enumScheduleStateCompleted => 'Selesai';

  @override
  String get enumIntervalUnitDays => 'Hari';

  @override
  String get enumIntervalUnitWeeks => 'Minggu';

  @override
  String get enumIntervalUnitMonths => 'Bulan';

  @override
  String get enumIntervalUnitYears => 'Tahun';

  @override
  String get enumIssuePriorityLow => 'Rendah';

  @override
  String get enumIssuePriorityMedium => 'Sedang';

  @override
  String get enumIssuePriorityHigh => 'Tinggi';

  @override
  String get enumIssuePriorityCritical => 'Kritis';

  @override
  String get enumIssueStatusOpen => 'Terbuka';

  @override
  String get enumIssueStatusInProgress => 'Sedang Diproses';

  @override
  String get enumIssueStatusResolved => 'Teratasi';

  @override
  String get enumIssueStatusClosed => 'Ditutup';

  @override
  String get enumMaintenanceResultSuccess => 'Berhasil';

  @override
  String get enumMaintenanceResultPartial => 'Sebagian';

  @override
  String get enumMaintenanceResultFailed => 'Gagal';

  @override
  String get enumMaintenanceResultRescheduled => 'Dijadwalkan Ulang';

  @override
  String get adminShellBottomNavDashboard => 'Dasbor';

  @override
  String get adminShellBottomNavScanAsset => 'Pindai Aset';

  @override
  String get adminShellBottomNavProfile => 'Profil';

  @override
  String get userShellBottomNavHome => 'Beranda';

  @override
  String get userShellBottomNavScanAsset => 'Pindai Aset';

  @override
  String get userShellBottomNavProfile => 'Profil';

  @override
  String get appEndDrawerTitle => 'Yoshida Motors';

  @override
  String get appEndDrawerPleaseLoginFirst => 'Silakan login terlebih dahulu';

  @override
  String get appEndDrawerTheme => 'Tema';

  @override
  String get appEndDrawerLanguage => 'Bahasa';

  @override
  String get appEndDrawerLogout => 'Keluar';

  @override
  String get appEndDrawerManagementSection => 'Manajemen';

  @override
  String get appEndDrawerMaintenanceSection => 'Pemeliharaan';

  @override
  String get appEndDrawerEnglish => 'English';

  @override
  String get appEndDrawerIndonesian => 'Indonesia';

  @override
  String get appEndDrawerJapanese => '日本語';

  @override
  String get appEndDrawerMyAssets => 'Aset Saya';

  @override
  String get appEndDrawerNotifications => 'Notifikasi';

  @override
  String get appEndDrawerMyIssueReports => 'Laporan Masalah Saya';

  @override
  String get appEndDrawerAssets => 'Aset';

  @override
  String get appEndDrawerAssetMovements => 'Perpindahan Aset';

  @override
  String get appEndDrawerCategories => 'Kategori';

  @override
  String get appEndDrawerLocations => 'Lokasi';

  @override
  String get appEndDrawerUsers => 'Pengguna';

  @override
  String get appEndDrawerMaintenanceSchedules => 'Jadwal Pemeliharaan';

  @override
  String get appEndDrawerMaintenanceRecords => 'Catatan Pemeliharaan';

  @override
  String get appEndDrawerReports => 'Laporan';

  @override
  String get appEndDrawerIssueReports => 'Laporan Masalah';

  @override
  String get appEndDrawerScanLogs => 'Log Pemindaian';

  @override
  String get appEndDrawerScanAsset => 'Pindai Aset';

  @override
  String get appEndDrawerDashboard => 'Dasbor';

  @override
  String get appEndDrawerHome => 'Beranda';

  @override
  String get appEndDrawerProfile => 'Profil';

  @override
  String get customAppBarTitle => 'Yoshida Motors';

  @override
  String get customAppBarOpenMenu => 'Buka Menu';

  @override
  String get appDropdownSelectOption => 'Pilih opsi';

  @override
  String get appSearchFieldHint => 'Cari...';

  @override
  String get appSearchFieldClear => 'Hapus';

  @override
  String get appSearchFieldNoResultsFound => 'Tidak ada hasil ditemukan';

  @override
  String get staffShellBottomNavDashboard => 'Dasbor';

  @override
  String get staffShellBottomNavScanAsset => 'Pindai Aset';

  @override
  String get staffShellBottomNavProfile => 'Profil';

  @override
  String get shellDoubleBackToExitApp =>
      'Tekan kembali sekali lagi untuk keluar';

  @override
  String get sharedValidationErrors => 'Kesalahan Validasi';

  @override
  String sharedMaxFilesAllowed(int count) {
    return 'Maksimum $count file diizinkan';
  }

  @override
  String sharedFileTooLarge(String name, int size) {
    return 'File $name melebihi batas ${size}MB';
  }

  @override
  String get sharedFailedToPickFiles => 'Gagal memilih file';

  @override
  String get sharedChooseFiles => 'Pilih file';

  @override
  String get sharedUnableToPreviewImage =>
      'Tidak dapat melihat pratinjau gambar';

  @override
  String get sharedVideoPreviewNotImplemented =>
      'Pratinjau video belum diimplementasikan';

  @override
  String get sharedPreviewNotAvailable =>
      'Pratinjau tidak tersedia untuk jenis file ini';

  @override
  String get sharedDelete => 'Hapus';

  @override
  String get sharedEdit => 'Ubah';

  @override
  String get sharedOptions => 'Opsi';

  @override
  String get sharedCreate => 'Buat';

  @override
  String get sharedAddNewItem => 'Tambah item baru';

  @override
  String get sharedSelectMany => 'Pilih Banyak';

  @override
  String get sharedSelectItemsToDelete => 'Pilih beberapa item untuk dihapus';

  @override
  String get sharedFilterAndSort => 'Filter & Urutkan';

  @override
  String get sharedCustomizeDisplay => 'Sesuaikan tampilan';

  @override
  String get sharedExport => 'Ekspor';

  @override
  String get sharedExportDataToFile => 'Ekspor data ke file';

  @override
  String get sharedTimePlaceholder => 'JJ:MM';

  @override
  String get sharedRetry => 'Coba Lagi';
}
