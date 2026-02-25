class ApiConstant {
  // Private constructor
  ApiConstant._();

  // * Base URL
  static const String baseUrl =
      'https://yoshida-motors-admin.fts.biz.id/api/v1';
  static const String baseMediaUrl =
      'https://yoshida-motors-admin.fts.biz.id/storage/';

  static String resolveUrl(String path) {
    if (path.startsWith('http')) return path;
    return '$baseMediaUrl$path';
  }

  // * Timeouts
  static const int defaultReceiveTimeout = 180000; // 3 minutes
  static const int defaultConnectTimeout = 30000; // 30 seconds
  static const int longOperationTimeout = 300000; // 5 minutes (for uploads)

  // * PREFIXES
  static const String authPrefix = '$baseUrl/auth';
  static const String appraisalPrefix = '$baseUrl/appraisals';

  // * AUTHENTICATION - Phone OTP
  // POST /auth/phone (Combined login/register)
  static const String authPhone = '$authPrefix/phone';
  // POST /auth/register
  static const String authRegister = '$authPrefix/register';
  // POST /auth/login
  static const String authLogin = '$authPrefix/login';
  // * AUTHENTICATION - Email & Password
  // POST /auth/register/email
  static const String authRegisterEmail = '$authPrefix/register/email';
  // POST /auth/login/email
  static const String authLoginEmail = '$authPrefix/login/email';
  // * AUTHENTICATION - Google Sign-In
  // POST /auth/login/google
  static const String authLoginGoogle = '$authPrefix/login/google';
  // GET & PUT /auth/profile
  static const String authProfile = '$authPrefix/profile';
  // POST /auth/logout
  static const String authLogout = '$authPrefix/logout';

  // * APPRAISALS (CRUD)
  // GET /appraisals (List)
  static const String getAppraisals = appraisalPrefix;
  // GET /appraisals/latest (Latest)
  static const String getLatestAppraisal = '$appraisalPrefix/latest';
  // POST /appraisals (Create)
  static const String createAppraisal = appraisalPrefix;
  // GET /appraisals/{id} (Detail)
  static String getAppraisalById(String id) => '$appraisalPrefix/$id';
  // PUT /appraisals/{id} (Update)
  static String updateAppraisal(String id) => '$appraisalPrefix/$id';
  // DELETE /appraisals/{id} (Delete)
  static String deleteAppraisal(String id) => '$appraisalPrefix/$id';

  // * SHORTCUTS
  // POST /appraisals/{id}/submit
  static String submitAppraisal(String id) => '$appraisalPrefix/$id/submit';

  // * NOTIFICATIONS
  static const String notificationPrefix = '$baseUrl/notifications';
  // GET /notifications
  static const String getNotifications = notificationPrefix;
  // PUT /notifications/{id}/mark-read
  static String markNotificationRead(String id) =>
      '$notificationPrefix/$id/mark-read';
  // PUT /notifications/mark-all-read
  static const String markAllNotificationsRead =
      '$notificationPrefix/mark-all-read';
}
