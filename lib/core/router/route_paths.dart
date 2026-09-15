/// Standardized path constants.
///
/// Note: StatefulShellRoute branches use top-level absolute paths
/// (each branch root must start with '/').
abstract final class AppRoutePaths {
  static const String root = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String verifyOtp = '/verify-otp';

  // Parent Tab Paths — top-level absolute paths for StatefulShellRoute branches
  static const String parent = '/parent';
  static const String parentDashboard = '/parent/dashboard';
  static const String parentClasses = '/parent/classes';
  static const String parentAssignments = '/parent/assignments';
  static const String parentInvoices = '/parent/invoices';
  static const String parentProfile = '/parent/profile';

  // Detail Paths
  static const String myChildren = '/parent/children';
  static const String classDetails = '/parent/classes/:classId';
  static const String classPreview = '/parent/classes/:classId/preview';
  static const String joiningClass = '/parent/classes/:classId/joining';
  static const String liveClassroom = '/parent/classes/:classId/live';
  static const String classSummary = '/parent/classes/:classId/summary';
  static const String currentProgram = '/parent/classes/program';
  static const String topicDetail = '/parent/classes/program/topic';
  static const String assignmentDetails = '/parent/assignments/:assignmentId';
  static const String assignmentSubmission = '/parent/assignments/:assignmentId/submission';
  static const String assignmentSubmitted = '/parent/assignments/:assignmentId/submitted';
  static const String invoiceDetails = '/parent/invoices/:invoiceId';
  static const String notifications = '/parent/notifications';
  static const String accountSettings = '/parent/settings';
  static const String parentSecurityPrivacy = '/parent/security-privacy';
  static const String parentLoginMethods = '/parent/security/login-methods';
  static const String parentLoginDevices = '/parent/security/login-devices';
  static const String paymentSuccessful = '/parent/payment-successful';
  static const String parentMessages = '/parent/messages';
  static const String achievements = '/parent/achievements';
  static const String learningProgress = '/parent/progress';
  static const String teacherFeedback = '/parent/teacher-feedback';
}
