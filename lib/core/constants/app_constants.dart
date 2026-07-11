class AppConstants {
  static const String appName = 'IKN Forest Parks';
  static const String appSlogan = 'Menghubungkan Masyarakat dengan Jantung Hijau Nusantara';
  
  // API Endpoints (Laravel Backend)
  // Gunakan 10.0.2.2 untuk emulator Android default, atau gunakan domain API live Anda
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  static const String loginUrl = '/login';
  static const String registerUrl = '/register';
  static const String logoutUrl = '/logout';
  static const String profileUrl = '/profile';
  static const String parksUrl = '/parks';
  static const String checkInUrl = '/parks/{id}/check-in';
  static const String postsUrl = '/posts';
  static const String commentsUrl = '/posts/{id}/comments';
  static const String likeUrl = '/posts/{id}/like';

  // Shared Preferences Keys
  static const String prefTokenKey = 'auth_token';
  static const String prefUserKey = 'auth_user';

  // Error Messages
  static const String errorGeneric = 'Terjadi kesalahan sistem. Silakan coba beberapa saat lagi.';
  static const String errorNetwork = 'Koneksi internet bermasalah. Pastikan Anda terhubung.';
  static const String errorUnauthorized = 'Sesi Anda telah berakhir. Silakan login kembali.';
}
