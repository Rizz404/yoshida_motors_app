// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get networkErrorDnsFailureUser =>
      'Cannot connect to server.\n• Check your internet connection\n• Disable VPN/DNS if active\n• Try again in a moment';

  @override
  String get networkErrorConnectionUser =>
      'Connection lost.\n• Check your internet connection\n• Ensure WiFi/data is active\n• Try again in a moment';

  @override
  String get networkErrorTimeoutUser =>
      'Connection timeout.\n• Check your internet speed\n• Try again in a moment\n• Contact admin if problem persists';

  @override
  String get networkErrorReceiveTimeoutUser =>
      'Server took too long to respond.\n• Your internet connection might be slow\n• Try again in a moment\n• Contact admin if problem persists';

  @override
  String get networkErrorServerUser =>
      'Server error occurred.\n• Try again in a moment\n• Contact admin if problem persists';

  @override
  String get networkErrorServer502User =>
      'Server unreachable.\n• Server might be under maintenance\n• Try again in a moment\n• Contact admin if problem persists';

  @override
  String get networkErrorServer503User =>
      'Service under maintenance.\n• Wait a moment\n• Try again later\n• Contact admin for more info';

  @override
  String get networkErrorServer504User =>
      'Server timeout.\n• Server is busy\n• Try again in a moment\n• Contact admin if problem persists';

  @override
  String get networkErrorHtmlResponse =>
      'Server returned HTML instead of JSON. Check API endpoint configuration.';

  @override
  String get networkErrorFileDownloaded => 'File downloaded successfully';

  @override
  String get networkErrorUnknown => 'Unknown error occurred';

  @override
  String get timeAgoJustNow => 'just now';

  @override
  String timeAgoMinute(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String timeAgoHour(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String timeAgoDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String timeAgoMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count months ago',
      one: '1 month ago',
    );
    return '$_temp0';
  }

  @override
  String timeAgoYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
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
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get dayMon => 'Monday';

  @override
  String get dayTue => 'Tuesday';

  @override
  String get dayWed => 'Wednesday';

  @override
  String get dayThu => 'Thursday';

  @override
  String get dayFri => 'Friday';

  @override
  String get daySat => 'Saturday';

  @override
  String get daySun => 'Sunday';

  @override
  String get currencyBillionSuffix => 'B';

  @override
  String get currencyMillionSuffix => 'M';

  @override
  String get currencyThousandSuffix => 'K';

  @override
  String get enumSortOrderAsc => 'Ascending';

  @override
  String get enumSortOrderDesc => 'Descending';

  @override
  String get enumCategorySortByCategoryCode => 'Category Code';

  @override
  String get enumCategorySortByName => 'Name';

  @override
  String get enumCategorySortByCategoryName => 'Category Name';

  @override
  String get enumCategorySortByCreatedAt => 'Created Date';

  @override
  String get enumCategorySortByUpdatedAt => 'Updated Date';

  @override
  String get enumLocationSortByLocationCode => 'Location Code';

  @override
  String get enumLocationSortByName => 'Name';

  @override
  String get enumLocationSortByLocationName => 'Location Name';

  @override
  String get enumLocationSortByBuilding => 'Building';

  @override
  String get enumLocationSortByFloor => 'Floor';

  @override
  String get enumLocationSortByCreatedAt => 'Created Date';

  @override
  String get enumLocationSortByUpdatedAt => 'Updated Date';

  @override
  String get enumNotificationSortByType => 'Type';

  @override
  String get enumNotificationSortByIsRead => 'Read Status';

  @override
  String get enumNotificationSortByCreatedAt => 'Received Date';

  @override
  String get enumNotificationSortByTitle => 'Title';

  @override
  String get enumNotificationSortByMessage => 'Message';

  @override
  String get enumScanLogSortByScanTimestamp => 'Scan Time';

  @override
  String get enumScanLogSortByScannedValue => 'Scanned Value';

  @override
  String get enumScanLogSortByScanMethod => 'Scan Method';

  @override
  String get enumScanLogSortByScanResult => 'Scan Result';

  @override
  String get enumAssetSortByAssetTag => 'Asset Tag';

  @override
  String get enumAssetSortByAssetName => 'Asset Name';

  @override
  String get enumAssetSortByBrand => 'Brand';

  @override
  String get enumAssetSortByModel => 'Model';

  @override
  String get enumAssetSortBySerialNumber => 'Serial Number';

  @override
  String get enumAssetSortByPurchaseDate => 'Purchase Date';

  @override
  String get enumAssetSortByPurchasePrice => 'Purchase Price';

  @override
  String get enumAssetSortByVendorName => 'Vendor Name';

  @override
  String get enumAssetSortByWarrantyEnd => 'Warranty End Date';

  @override
  String get enumAssetSortByStatus => 'Status';

  @override
  String get enumAssetSortByConditionStatus => 'Condition';

  @override
  String get enumAssetSortByCreatedAt => 'Created Date';

  @override
  String get enumAssetSortByUpdatedAt => 'Updated Date';

  @override
  String get enumAssetMovementSortByMovementDate => 'Movement Date';

  @override
  String get enumAssetMovementSortByMovementdate => 'Movement Date';

  @override
  String get enumAssetMovementSortByCreatedAt => 'Created Date';

  @override
  String get enumAssetMovementSortByCreatedat => 'Created Date';

  @override
  String get enumAssetMovementSortByUpdatedAt => 'Updated Date';

  @override
  String get enumAssetMovementSortByUpdatedat => 'Updated Date';

  @override
  String get enumIssueReportSortByReportedDate => 'Reported Date';

  @override
  String get enumIssueReportSortByResolvedDate => 'Resolved Date';

  @override
  String get enumIssueReportSortByIssueType => 'Issue Type';

  @override
  String get enumIssueReportSortByPriority => 'Priority';

  @override
  String get enumIssueReportSortByStatus => 'Status';

  @override
  String get enumIssueReportSortByTitle => 'Title';

  @override
  String get enumIssueReportSortByDescription => 'Description';

  @override
  String get enumIssueReportSortByCreatedAt => 'Created Date';

  @override
  String get enumIssueReportSortByUpdatedAt => 'Updated Date';

  @override
  String get enumMaintenanceScheduleSortByNextScheduledDate =>
      'Next Scheduled Date';

  @override
  String get enumMaintenanceScheduleSortByMaintenanceType => 'Maintenance Type';

  @override
  String get enumMaintenanceScheduleSortByState => 'State';

  @override
  String get enumMaintenanceScheduleSortByCreatedAt => 'Created Date';

  @override
  String get enumMaintenanceScheduleSortByUpdatedAt => 'Updated Date';

  @override
  String get enumMaintenanceRecordSortByMaintenanceDate => 'Maintenance Date';

  @override
  String get enumMaintenanceRecordSortByActualCost => 'Actual Cost';

  @override
  String get enumMaintenanceRecordSortByTitle => 'Title';

  @override
  String get enumMaintenanceRecordSortByCreatedAt => 'Created Date';

  @override
  String get enumMaintenanceRecordSortByUpdatedAt => 'Updated Date';

  @override
  String get enumUserSortByName => 'Name';

  @override
  String get enumUserSortByFullName => 'Full Name';

  @override
  String get enumUserSortByEmail => 'Email';

  @override
  String get enumUserSortByRole => 'Role';

  @override
  String get enumUserSortByEmployeeId => 'Employee ID';

  @override
  String get enumUserSortByIsActive => 'Active Status';

  @override
  String get enumUserSortByCreatedAt => 'Joined Date';

  @override
  String get enumUserSortByUpdatedAt => 'Updated Date';

  @override
  String get enumExportFormatPdf => 'PDF';

  @override
  String get enumExportFormatExcel => 'Excel';

  @override
  String get enumMutationTypeCreate => 'Create';

  @override
  String get enumMutationTypeUpdate => 'Update';

  @override
  String get enumMutationTypeDelete => 'Delete';

  @override
  String get enumLanguageEnglish => 'English';

  @override
  String get enumLanguageJapanese => 'Japanese';

  @override
  String get enumLanguageIndonesian => 'Indonesian';

  @override
  String get enumUserRoleAdmin => 'Admin';

  @override
  String get enumUserRoleUser => 'User';

  @override
  String get enumAssetStatusActive => 'Active';

  @override
  String get enumAssetStatusMaintenance => 'Maintenance';

  @override
  String get enumAssetStatusDisposed => 'Disposed';

  @override
  String get enumAssetStatusLost => 'Lost';

  @override
  String get enumAssetConditionGood => 'Good';

  @override
  String get enumAssetConditionFair => 'Fair';

  @override
  String get enumAssetConditionPoor => 'Poor';

  @override
  String get enumAssetConditionDamaged => 'Damaged';

  @override
  String get enumNotificationTypeMaintenance => 'Maintenance';

  @override
  String get enumNotificationTypeWarranty => 'Warranty';

  @override
  String get enumNotificationTypeIssue => 'Issue';

  @override
  String get enumNotificationTypeMovement => 'Movement';

  @override
  String get enumNotificationTypeStatusChange => 'Status Change';

  @override
  String get enumNotificationTypeLocationChange => 'Location Change';

  @override
  String get enumNotificationTypeCategoryChange => 'Category Change';

  @override
  String get enumNotificationPriorityLow => 'Low';

  @override
  String get enumNotificationPriorityNormal => 'Normal';

  @override
  String get enumNotificationPriorityHigh => 'High';

  @override
  String get enumNotificationPriorityUrgent => 'Urgent';

  @override
  String get enumScanMethodTypeDataMatrix => 'Data Matrix';

  @override
  String get enumScanMethodTypeManualInput => 'Manual Input';

  @override
  String get enumScanResultTypeSuccess => 'Success';

  @override
  String get enumScanResultTypeInvalidID => 'Invalid ID';

  @override
  String get enumScanResultTypeAssetNotFound => 'Asset Not Found';

  @override
  String get enumMaintenanceScheduleTypePreventive => 'Preventive';

  @override
  String get enumMaintenanceScheduleTypeCorrective => 'Corrective';

  @override
  String get enumMaintenanceScheduleTypeInspection => 'Inspection';

  @override
  String get enumMaintenanceScheduleTypeCalibration => 'Calibration';

  @override
  String get enumScheduleStateActive => 'Active';

  @override
  String get enumScheduleStatePaused => 'Paused';

  @override
  String get enumScheduleStateStopped => 'Stopped';

  @override
  String get enumScheduleStateCompleted => 'Completed';

  @override
  String get enumIntervalUnitDays => 'Days';

  @override
  String get enumIntervalUnitWeeks => 'Weeks';

  @override
  String get enumIntervalUnitMonths => 'Months';

  @override
  String get enumIntervalUnitYears => 'Years';

  @override
  String get enumIssuePriorityLow => 'Low';

  @override
  String get enumIssuePriorityMedium => 'Medium';

  @override
  String get enumIssuePriorityHigh => 'High';

  @override
  String get enumIssuePriorityCritical => 'Critical';

  @override
  String get enumIssueStatusOpen => 'Open';

  @override
  String get enumIssueStatusInProgress => 'In Progress';

  @override
  String get enumIssueStatusResolved => 'Resolved';

  @override
  String get enumIssueStatusClosed => 'Closed';

  @override
  String get enumMaintenanceResultSuccess => 'Success';

  @override
  String get enumMaintenanceResultPartial => 'Partial';

  @override
  String get enumMaintenanceResultFailed => 'Failed';

  @override
  String get enumMaintenanceResultRescheduled => 'Rescheduled';

  @override
  String get vehicleInfoTitle => 'Vehicle Information';

  @override
  String get vehicleInfoBrandLabel => 'Vehicle Brand';

  @override
  String get vehicleInfoBrandPlaceholder => 'Toyota, Honda, Suzuki...';

  @override
  String get vehicleInfoModelLabel => 'Vehicle Model';

  @override
  String get vehicleInfoModelPlaceholder => 'Avanza, Brio, Ertiga...';

  @override
  String get vehicleInfoYearLabel => 'Year of Manufacture';

  @override
  String get vehicleInfoYearPlaceholder => '2020';

  @override
  String get vehicleInfoLicensePlateLabel => 'License Plate (Optional)';

  @override
  String get vehicleInfoMileageLabel => 'Mileage (Optional)';

  @override
  String get vehicleInfoNotesLabel => 'Additional Notes (Optional)';

  @override
  String get vehicleInfoNotesPlaceholder => 'Condition, modifications, etc.';

  @override
  String get vehicleInfoNextButton => 'Next: Take Photos';

  @override
  String get photoCategoryTitle => 'Take Photos';

  @override
  String get photoCategoryWarning =>
      'Warning: Ensure the photos taken are clear, not blurry, and cover all necessary parts.';

  @override
  String get photoCategoryAddNewPhoto => 'Add New Photo';

  @override
  String get photoCategoryCamera => 'Camera';

  @override
  String get photoCategoryUpload => 'Upload';

  @override
  String get photoCategoryUploadedPhotos => 'Uploaded Photos';

  @override
  String get photoCategoryEmpty => 'No photos uploaded yet';

  @override
  String get photoCategoryContinueButton => 'Continue to Summary';

  @override
  String get photoCategoryErrorNoPhotos => 'Please add at least one photo.';

  @override
  String get photoCategoryErrorCategoryRequired =>
      'Please enter a category name for all photos.';

  @override
  String get photoCategorySuccessCreated => 'Appraisal created successfully!';

  @override
  String get photoCategoryMaxPhotos => 'Maximum 7 photos reached.';

  @override
  String cameraCaptureTitle(String category) {
    return 'Take Photo: $category';
  }

  @override
  String get cameraCaptureOpeningCamera => 'Opening camera...';

  @override
  String get cameraCaptureOpenCameraButton => 'Open Camera';

  @override
  String get cameraCaptureRetake => 'Retake';

  @override
  String get cameraCaptureUsePhoto => 'Use This Photo';

  @override
  String get cameraCaptureDialogTitle => 'Enter Category Name';

  @override
  String get cameraCaptureDialogCategoryLabel => 'Category Name';

  @override
  String get cameraCaptureDialogCategoryPlaceholder =>
      'e.g., Right Engine, Front Interior';

  @override
  String get cameraCaptureDialogCancel => 'Cancel';

  @override
  String get cameraCaptureDialogSave => 'Save';

  @override
  String get cameraCapturePhotoAdded => 'Photo added';

  @override
  String get summaryTitle => 'Review & Submit';

  @override
  String get summaryVehicleInfoSection => 'Vehicle Information';

  @override
  String get summaryBrand => 'Brand';

  @override
  String get summaryModel => 'Model';

  @override
  String get summaryYear => 'Year';

  @override
  String get summaryLicensePlate => 'License Plate';

  @override
  String get summaryMileage => 'Mileage';

  @override
  String get summaryNotes => 'Notes';

  @override
  String summaryPhotosSection(int count) {
    return 'Photos ($count)';
  }

  @override
  String get summaryNoPhotos => 'No photos uploaded yet.';

  @override
  String get summaryDisclaimer =>
      'By submitting, you agree that the information provided is accurate.';

  @override
  String get summarySubmitButton => 'Submit Appraisal';

  @override
  String get summaryFailedToLoad => 'Failed to load';

  @override
  String get summarySubmissionFailed => 'Submission failed';

  @override
  String get summarySubmitSuccess => 'Appraisal submitted successfully!';

  @override
  String get appraisalResultTitle => 'Appraisal Result';

  @override
  String get appraisalResultFailedToLoad => 'Failed to load appraisal';

  @override
  String get appraisalResultNextStepsSection => 'Next Steps';

  @override
  String get appraisalResultAdminNotesSection => 'Admin Notes';

  @override
  String get appraisalResultVehicleDetailsSection => 'Vehicle Details';

  @override
  String get appraisalResultStatusCompleteTitle => 'Review Complete!';

  @override
  String get appraisalResultStatusUnderReviewTitle => 'Under Review';

  @override
  String get appraisalResultStatusCompleteSubtitle =>
      'Your appraisal has been reviewed and a price has been set.';

  @override
  String get appraisalResultStatusUnderReviewSubtitle =>
      'We\'ll notify you once the review is complete.';

  @override
  String get appraisalResultOfferedPrice => 'Offered Purchase Price';

  @override
  String appraisalResultValidUntil(String date) {
    return 'Valid until: $date';
  }

  @override
  String get appraisalResultContactUs => 'Contact Us';

  @override
  String get appraisalResultEditAppraisal => 'Edit Appraisal';

  @override
  String get appraisalResultNextStepComplete1 =>
      'Review the offered price carefully.';

  @override
  String get appraisalResultNextStepComplete2 =>
      'Contact our team to accept or negotiate.';

  @override
  String get appraisalResultNextStepComplete3 =>
      'Bring your vehicle for a physical inspection.';

  @override
  String get appraisalResultNextStepComplete4 =>
      'Complete the transaction and documentation.';

  @override
  String get appraisalResultNextStepPending1 =>
      'Our team will review your submission.';

  @override
  String get appraisalResultNextStepPending2 =>
      'You will receive a notification when done.';

  @override
  String get appraisalResultNextStepPending3 =>
      'You can contact us for updates at any time.';

  @override
  String get appraisalResultBrandLabel => 'Brand';

  @override
  String get appraisalResultModelLabel => 'Model';

  @override
  String get appraisalResultYearLabel => 'Year';

  @override
  String get appraisalResultLicensePlateLabel => 'License Plate';

  @override
  String get appraisalResultMileageLabel => 'Mileage';

  @override
  String get appraisalResultNotesLabel => 'Notes';

  @override
  String get listAppraisalsTitle => 'My Appraisals';

  @override
  String get listAppraisalsFailedToLoad => 'Failed to load appraisals';

  @override
  String get listAppraisalsEmpty => 'No appraisals found';

  @override
  String get listAppraisalsViewDetails => 'View Details';

  @override
  String get editAppraisalTitle => 'Edit Appraisal';

  @override
  String get editAppraisalVehicleInfoSection => 'Vehicle Information';

  @override
  String editAppraisalPhotosSection(int count) {
    return 'Photos ($count/7)';
  }

  @override
  String get editAppraisalAddPhoto => 'Add Photo';

  @override
  String get editAppraisalNoPhotos => 'No photos added yet';

  @override
  String get editAppraisalSaveButton => 'Save Changes';

  @override
  String get editAppraisalSuccess => 'Appraisal updated successfully!';

  @override
  String get editAppraisalFailedToLoad => 'Failed to load detail';

  @override
  String get editAppraisalErrorMinPhotos => 'Please add at least one photo.';

  @override
  String get editAppraisalErrorCategoryRequired =>
      'Please enter a category name for all new photos.';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to your account';

  @override
  String get loginTabEmail => 'Email';

  @override
  String get loginTabPhoneOtp => 'Phone OTP';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get loginContinueWithGoogle => 'Continue with Google';

  @override
  String get loginOr => 'OR';

  @override
  String get loginNoAccount => 'Don\'t have an account? ';

  @override
  String get loginRegisterLink => 'Register';

  @override
  String get loginPhoneDisabledTitle => 'Phone OTP Temporarily Disabled';

  @override
  String get loginPhoneDisabledSubtitle =>
      'Please use Email or Google Sign-In to continue.';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Register to get started';

  @override
  String get registerTabEmail => 'Email';

  @override
  String get registerTabPhoneOtp => 'Phone OTP';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerConfirmPasswordLabel => 'Confirm Password';

  @override
  String get registerFullNameOptional => 'Full Name (Optional)';

  @override
  String get registerAddressOptional => 'Address (Optional)';

  @override
  String get registerButton => 'Register';

  @override
  String get registerContinueWithGoogle => 'Continue with Google';

  @override
  String get registerOr => 'OR';

  @override
  String get registerAlreadyAccount => 'Already have an account? ';

  @override
  String get registerLoginLink => 'Login';

  @override
  String get registerPhoneDisabledTitle => 'Phone OTP Temporarily Disabled';

  @override
  String get registerPhoneDisabledSubtitle =>
      'Please use Email or Google Sign-In to continue.';

  @override
  String get registerSuccess => 'Registration successful';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name!';
  }

  @override
  String get homeReadyForAppraisal => 'Ready for your appraisal?';

  @override
  String get homeLatestAppraisal => 'Latest Appraisal';

  @override
  String get homeRefresh => 'Refresh';

  @override
  String get homeSeeAll => 'See All';

  @override
  String get homeStartNewAppraisal => 'Start New Appraisal';

  @override
  String get homeViewDetails => 'View Details';

  @override
  String get homeIncompleteProfileError =>
      'Please complete your profile before starting a new appraisal.';

  @override
  String get listNotificationsTitle => 'Notifications';

  @override
  String get listNotificationsMarkAllRead => 'Mark All Read';

  @override
  String get listNotificationsFailedToLoad => 'Failed to load notifications';

  @override
  String get listNotificationsEmpty => 'No notifications yet';

  @override
  String get profileFailedToLoad => 'Failed to load profile';

  @override
  String get profileUpdatePhotoLabel => 'Update Profile Photo';

  @override
  String get profileUpdatePhotoHint => 'Select an image';

  @override
  String get profileFullNameLabel => 'Full Name';

  @override
  String get profileFullNamePlaceholder => 'John Doe';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileEmailPlaceholder => 'john@example.com';

  @override
  String get profileAddressLabel => 'Address';

  @override
  String get profileAddressPlaceholder => 'South Jakarta';

  @override
  String get profileSaveButton => 'Save Profile';

  @override
  String get profileSaveSuccess => 'Profile saved successfully';

  @override
  String get profileSaveFailed => 'Failed to save profile';

  @override
  String get adminShellBottomNavDashboard => 'Dashboard';

  @override
  String get adminShellBottomNavScanAsset => 'Scan Asset';

  @override
  String get adminShellBottomNavProfile => 'Profile';

  @override
  String get userShellBottomNavHome => 'Home';

  @override
  String get userShellBottomNavScanAsset => 'Scan Asset';

  @override
  String get userShellBottomNavProfile => 'Profile';

  @override
  String get appEndDrawerTitle => 'Yoshida Motors';

  @override
  String get appEndDrawerPleaseLoginFirst => 'Please login first';

  @override
  String get appEndDrawerTheme => 'Theme';

  @override
  String get appEndDrawerLanguage => 'Language';

  @override
  String get appEndDrawerLogout => 'Logout';

  @override
  String get appEndDrawerManagementSection => 'Management';

  @override
  String get appEndDrawerMaintenanceSection => 'Maintenance';

  @override
  String get appEndDrawerEnglish => 'English';

  @override
  String get appEndDrawerIndonesian => 'Indonesia';

  @override
  String get appEndDrawerJapanese => '日本語';

  @override
  String get appEndDrawerMyAssets => 'My Assets';

  @override
  String get appEndDrawerNotifications => 'Notifications';

  @override
  String get appEndDrawerMyIssueReports => 'My Issue Reports';

  @override
  String get appEndDrawerAssets => 'Assets';

  @override
  String get appEndDrawerAssetMovements => 'Asset Movements';

  @override
  String get appEndDrawerCategories => 'Categories';

  @override
  String get appEndDrawerLocations => 'Locations';

  @override
  String get appEndDrawerUsers => 'Users';

  @override
  String get appEndDrawerMaintenanceSchedules => 'Maintenance Schedules';

  @override
  String get appEndDrawerMaintenanceRecords => 'Maintenance Records';

  @override
  String get appEndDrawerReports => 'Reports';

  @override
  String get appEndDrawerIssueReports => 'Issue Reports';

  @override
  String get appEndDrawerScanLogs => 'Scan Logs';

  @override
  String get appEndDrawerScanAsset => 'Scan Asset';

  @override
  String get appEndDrawerDashboard => 'Dashboard';

  @override
  String get appEndDrawerHome => 'Home';

  @override
  String get appEndDrawerProfile => 'Profile';

  @override
  String get customAppBarTitle => 'Yoshida Motors';

  @override
  String get customAppBarOpenMenu => 'Open Menu';

  @override
  String get appDropdownSelectOption => 'Select option';

  @override
  String get appSearchFieldHint => 'Search...';

  @override
  String get appSearchFieldClear => 'Clear';

  @override
  String get appSearchFieldNoResultsFound => 'No results found';

  @override
  String get staffShellBottomNavDashboard => 'Dashboard';

  @override
  String get staffShellBottomNavScanAsset => 'Scan Asset';

  @override
  String get staffShellBottomNavProfile => 'Profile';

  @override
  String get shellDoubleBackToExitApp => 'Press back again to exit';

  @override
  String get sharedValidationErrors => 'Validation Errors';

  @override
  String sharedMaxFilesAllowed(int count) {
    return 'Maximum $count files allowed';
  }

  @override
  String sharedFileTooLarge(String name, int size) {
    return 'File $name exceeds ${size}MB limit';
  }

  @override
  String get sharedFailedToPickFiles => 'Failed to pick files';

  @override
  String get sharedChooseFiles => 'Choose file(s)';

  @override
  String get sharedUnableToPreviewImage => 'Unable to preview image';

  @override
  String get sharedVideoPreviewNotImplemented =>
      'Video preview not implemented yet';

  @override
  String get sharedPreviewNotAvailable =>
      'Preview not available for this file type';

  @override
  String get sharedDelete => 'Delete';

  @override
  String get sharedEdit => 'Edit';

  @override
  String get sharedOptions => 'Options';

  @override
  String get sharedCreate => 'Create';

  @override
  String get sharedAddNewItem => 'Add a new item';

  @override
  String get sharedSelectMany => 'Select Many';

  @override
  String get sharedSelectItemsToDelete => 'Select multiple items to delete';

  @override
  String get sharedFilterAndSort => 'Filter & Sort';

  @override
  String get sharedCustomizeDisplay => 'Customize display';

  @override
  String get sharedExport => 'Export';

  @override
  String get sharedExportDataToFile => 'Export data to file';

  @override
  String get sharedTimePlaceholder => 'HH:MM';

  @override
  String get sharedRetry => 'Retry';
}
