class AppApiUtils {
  static String baseUrl = "http://18.220.106.62:3000/";
  static String adminloginUrl = "${baseUrl}admin_login";
  static String signUpUrl = "${baseUrl}sign_up";
  static String getuserCountUrl = "${baseUrl}getUsersCount";
  static String allusersUrl = "${baseUrl}fetchUsersByRole ";
  static String deleteUserAccount = "${baseUrl}admin/delete-user";
  static String totalanalyticsuser = "${baseUrl}totalUsersAnalytics";
  static String higestratinguser = "${baseUrl}getUsersWithHighRating";
  static String showReport = "${baseUrl}showMessages";
  static String sendResponse = "${baseUrl}messages";
  static String blockUnblock = "${baseUrl}update-status";

}