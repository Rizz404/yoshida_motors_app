// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get networkErrorDnsFailureUser =>
      'サーバーに接続できません。\n• インターネット接続を確認してください\n• VPN/DNSが有効な場合は無効にしてください\n• しばらくしてから再試行してください';

  @override
  String get networkErrorConnectionUser =>
      '接続が切れました。\n• インターネット接続を確認してください\n• WiFi/データが有効であることを確認してください\n• しばらくしてから再試行してください';

  @override
  String get networkErrorTimeoutUser =>
      '接続タイムアウト。\n• インターネット速度を確認してください\n• しばらくしてから再試行してください\n• 問題が解決しない場合は管理者に連絡してください';

  @override
  String get networkErrorReceiveTimeoutUser =>
      'サーバーの応答時間が長すぎます。\n• インターネット接続が遅い可能性があります\n• しばらくしてから再試行してください\n• 問題が解決しない場合は管理者に連絡してください';

  @override
  String get networkErrorServerUser =>
      'サーバーエラーが発生しました。\n• しばらくしてから再試行してください\n• 問題が解決しない場合は管理者に連絡してください';

  @override
  String get networkErrorServer502User =>
      'サーバーに到達できません。\n• サーバーがメンテナンス中の可能性があります\n• しばらくしてから再試行してください\n• 問題が解決しない場合は管理者に連絡してください';

  @override
  String get networkErrorServer503User =>
      'サービスはメンテナンス中です。\n• しばらくお待ちください\n• 後で再試行してください\n• 詳細については管理者に連絡してください';

  @override
  String get networkErrorServer504User =>
      'サーバータイムアウト。\n• サーバーが混雑しています\n• しばらくしてから再試行してください\n• 問題が解決しない場合は管理者に連絡してください';

  @override
  String get networkErrorHtmlResponse =>
      'サーバーがJSONではなくHTMLを返しました。APIエンドポイント設定を確認してください。';

  @override
  String get networkErrorFileDownloaded => 'ファイルが正常にダウンロードされました';

  @override
  String get networkErrorUnknown => '不明なエラーが発生しました';

  @override
  String get timeAgoJustNow => 'たった今';

  @override
  String timeAgoMinute(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count分前',
      one: '1分前',
    );
    return '$_temp0';
  }

  @override
  String timeAgoHour(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count時間前',
      one: '1時間前',
    );
    return '$_temp0';
  }

  @override
  String timeAgoDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日前',
      one: '1日前',
    );
    return '$_temp0';
  }

  @override
  String timeAgoMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countヶ月前',
      one: '1ヶ月前',
    );
    return '$_temp0';
  }

  @override
  String timeAgoYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count年前',
      one: '1年前',
    );
    return '$_temp0';
  }

  @override
  String get monthJan => '1月';

  @override
  String get monthFeb => '2月';

  @override
  String get monthMar => '3月';

  @override
  String get monthApr => '4月';

  @override
  String get monthMay => '5月';

  @override
  String get monthJun => '6月';

  @override
  String get monthJul => '7月';

  @override
  String get monthAug => '8月';

  @override
  String get monthSep => '9月';

  @override
  String get monthOct => '10月';

  @override
  String get monthNov => '11月';

  @override
  String get monthDec => '12月';

  @override
  String get dayMon => '月曜日';

  @override
  String get dayTue => '火曜日';

  @override
  String get dayWed => '水曜日';

  @override
  String get dayThu => '木曜日';

  @override
  String get dayFri => '金曜日';

  @override
  String get daySat => '土曜日';

  @override
  String get daySun => '日曜日';

  @override
  String get currencyBillionSuffix => '十億';

  @override
  String get currencyMillionSuffix => '百万';

  @override
  String get currencyThousandSuffix => '千';

  @override
  String get enumSortOrderAsc => '昇順';

  @override
  String get enumSortOrderDesc => '降順';

  @override
  String get enumCategorySortByCategoryCode => 'カテゴリコード';

  @override
  String get enumCategorySortByName => '名前';

  @override
  String get enumCategorySortByCategoryName => 'カテゴリ名';

  @override
  String get enumCategorySortByCreatedAt => '作成日時';

  @override
  String get enumCategorySortByUpdatedAt => '更新日時';

  @override
  String get enumLocationSortByLocationCode => 'ロケーションコード';

  @override
  String get enumLocationSortByName => '名前';

  @override
  String get enumLocationSortByLocationName => 'ロケーション名';

  @override
  String get enumLocationSortByBuilding => '建物';

  @override
  String get enumLocationSortByFloor => '階';

  @override
  String get enumLocationSortByCreatedAt => '作成日時';

  @override
  String get enumLocationSortByUpdatedAt => '更新日時';

  @override
  String get enumNotificationSortByType => 'タイプ';

  @override
  String get enumNotificationSortByIsRead => '既読状態';

  @override
  String get enumNotificationSortByCreatedAt => '受信日時';

  @override
  String get enumNotificationSortByTitle => 'タイトル';

  @override
  String get enumNotificationSortByMessage => 'メッセージ';

  @override
  String get enumScanLogSortByScanTimestamp => 'スキャン日時';

  @override
  String get enumScanLogSortByScannedValue => 'スキャン値';

  @override
  String get enumScanLogSortByScanMethod => 'スキャン方法';

  @override
  String get enumScanLogSortByScanResult => 'スキャン結果';

  @override
  String get enumAssetSortByAssetTag => '資産タグ';

  @override
  String get enumAssetSortByAssetName => '資産名';

  @override
  String get enumAssetSortByBrand => 'ブランド';

  @override
  String get enumAssetSortByModel => 'モデル';

  @override
  String get enumAssetSortBySerialNumber => 'シリアル番号';

  @override
  String get enumAssetSortByPurchaseDate => '購入日';

  @override
  String get enumAssetSortByPurchasePrice => '購入価格';

  @override
  String get enumAssetSortByVendorName => 'ベンダー名';

  @override
  String get enumAssetSortByWarrantyEnd => '保証終了日';

  @override
  String get enumAssetSortByStatus => 'ステータス';

  @override
  String get enumAssetSortByConditionStatus => 'コンディション';

  @override
  String get enumAssetSortByCreatedAt => '作成日時';

  @override
  String get enumAssetSortByUpdatedAt => '更新日時';

  @override
  String get enumAssetMovementSortByMovementDate => '移動日';

  @override
  String get enumAssetMovementSortByMovementdate => '移動日';

  @override
  String get enumAssetMovementSortByCreatedAt => '作成日時';

  @override
  String get enumAssetMovementSortByCreatedat => '作成日時';

  @override
  String get enumAssetMovementSortByUpdatedAt => '更新日時';

  @override
  String get enumAssetMovementSortByUpdatedat => '更新日時';

  @override
  String get enumIssueReportSortByReportedDate => '報告日';

  @override
  String get enumIssueReportSortByResolvedDate => '解決日';

  @override
  String get enumIssueReportSortByIssueType => '問題タイプ';

  @override
  String get enumIssueReportSortByPriority => '優先度';

  @override
  String get enumIssueReportSortByStatus => 'ステータス';

  @override
  String get enumIssueReportSortByTitle => 'タイトル';

  @override
  String get enumIssueReportSortByDescription => '説明';

  @override
  String get enumIssueReportSortByCreatedAt => '作成日時';

  @override
  String get enumIssueReportSortByUpdatedAt => '更新日時';

  @override
  String get enumMaintenanceScheduleSortByNextScheduledDate => '次回予定日';

  @override
  String get enumMaintenanceScheduleSortByMaintenanceType => 'メンテナンスタイプ';

  @override
  String get enumMaintenanceScheduleSortByState => '状態';

  @override
  String get enumMaintenanceScheduleSortByCreatedAt => '作成日時';

  @override
  String get enumMaintenanceScheduleSortByUpdatedAt => '更新日時';

  @override
  String get enumMaintenanceRecordSortByMaintenanceDate => 'メンテナンス日';

  @override
  String get enumMaintenanceRecordSortByActualCost => '実費用';

  @override
  String get enumMaintenanceRecordSortByTitle => 'タイトル';

  @override
  String get enumMaintenanceRecordSortByCreatedAt => '作成日時';

  @override
  String get enumMaintenanceRecordSortByUpdatedAt => '更新日時';

  @override
  String get enumUserSortByName => '名前';

  @override
  String get enumUserSortByFullName => '氏名';

  @override
  String get enumUserSortByEmail => 'メールアドレス';

  @override
  String get enumUserSortByRole => '役割';

  @override
  String get enumUserSortByEmployeeId => '社員ID';

  @override
  String get enumUserSortByIsActive => '有効状態';

  @override
  String get enumUserSortByCreatedAt => '登録日時';

  @override
  String get enumUserSortByUpdatedAt => '更新日時';

  @override
  String get enumExportFormatPdf => 'PDF';

  @override
  String get enumExportFormatExcel => 'Excel';

  @override
  String get enumMutationTypeCreate => '作成';

  @override
  String get enumMutationTypeUpdate => '更新';

  @override
  String get enumMutationTypeDelete => '削除';

  @override
  String get enumLanguageEnglish => '英語';

  @override
  String get enumLanguageJapanese => '日本語';

  @override
  String get enumLanguageIndonesian => 'インドネシア語';

  @override
  String get enumUserRoleAdmin => '管理者';

  @override
  String get enumUserRoleUser => 'ユーザー';

  @override
  String get enumAssetStatusActive => 'アクティブ';

  @override
  String get enumAssetStatusMaintenance => 'メンテナンス中';

  @override
  String get enumAssetStatusDisposed => '廃棄済み';

  @override
  String get enumAssetStatusLost => '紛失';

  @override
  String get enumAssetConditionGood => '良好';

  @override
  String get enumAssetConditionFair => '普通';

  @override
  String get enumAssetConditionPoor => '悪い';

  @override
  String get enumAssetConditionDamaged => '破損';

  @override
  String get enumNotificationTypeMaintenance => 'メンテナンス';

  @override
  String get enumNotificationTypeWarranty => '保証';

  @override
  String get enumNotificationTypeIssue => '問題';

  @override
  String get enumNotificationTypeMovement => '移動';

  @override
  String get enumNotificationTypeStatusChange => 'ステータス変更';

  @override
  String get enumNotificationTypeLocationChange => '場所変更';

  @override
  String get enumNotificationTypeCategoryChange => 'カテゴリ変更';

  @override
  String get enumNotificationPriorityLow => '低';

  @override
  String get enumNotificationPriorityNormal => '中';

  @override
  String get enumNotificationPriorityHigh => '高';

  @override
  String get enumNotificationPriorityUrgent => '緊急';

  @override
  String get enumScanMethodTypeDataMatrix => 'データマトリックス';

  @override
  String get enumScanMethodTypeManualInput => '手動入力';

  @override
  String get enumScanResultTypeSuccess => '成功';

  @override
  String get enumScanResultTypeInvalidID => '無効なID';

  @override
  String get enumScanResultTypeAssetNotFound => '資産が見つかりません';

  @override
  String get enumMaintenanceScheduleTypePreventive => '予防';

  @override
  String get enumMaintenanceScheduleTypeCorrective => '事後';

  @override
  String get enumMaintenanceScheduleTypeInspection => '点検';

  @override
  String get enumMaintenanceScheduleTypeCalibration => '校正';

  @override
  String get enumScheduleStateActive => '有効';

  @override
  String get enumScheduleStatePaused => '一時停止';

  @override
  String get enumScheduleStateStopped => '停止';

  @override
  String get enumScheduleStateCompleted => '完了';

  @override
  String get enumIntervalUnitDays => '日';

  @override
  String get enumIntervalUnitWeeks => '週';

  @override
  String get enumIntervalUnitMonths => '月';

  @override
  String get enumIntervalUnitYears => '年';

  @override
  String get enumIssuePriorityLow => '低';

  @override
  String get enumIssuePriorityMedium => '中';

  @override
  String get enumIssuePriorityHigh => '高';

  @override
  String get enumIssuePriorityCritical => 'クリティカル';

  @override
  String get enumIssueStatusOpen => '未対応';

  @override
  String get enumIssueStatusInProgress => '対応中';

  @override
  String get enumIssueStatusResolved => '解決済み';

  @override
  String get enumIssueStatusClosed => '完了';

  @override
  String get enumMaintenanceResultSuccess => '成功';

  @override
  String get enumMaintenanceResultPartial => '部分的';

  @override
  String get enumMaintenanceResultFailed => '失敗';

  @override
  String get enumMaintenanceResultRescheduled => '再スケジュール';

  @override
  String get vehicleInfoTitle => '車両情報';

  @override
  String get vehicleInfoBrandLabel => '車両ブランド';

  @override
  String get vehicleInfoBrandPlaceholder => 'トヨタ、ホンダ、スズキ...';

  @override
  String get vehicleInfoModelLabel => '車両モデル';

  @override
  String get vehicleInfoModelPlaceholder => 'アバンザ、ブリオ、エルティガ...';

  @override
  String get vehicleInfoYearLabel => '製造年';

  @override
  String get vehicleInfoYearPlaceholder => '2020';

  @override
  String get vehicleInfoLicensePlateLabel => 'ナンバープレート（任意）';

  @override
  String get vehicleInfoMileageLabel => '走行距離（任意）';

  @override
  String get vehicleInfoNotesLabel => '追加メモ（任意）';

  @override
  String get vehicleInfoNotesPlaceholder => '状態、改造など';

  @override
  String get vehicleInfoNextButton => '次へ：写真を撮る';

  @override
  String get photoCategoryTitle => '写真を撮る';

  @override
  String get photoCategoryWarning =>
      '警告：写真が鮮明で、ぼやけておらず、必要な部分をすべてカバーしていることを確認してください。';

  @override
  String get photoCategoryAddNewPhoto => '新しい写真を追加';

  @override
  String get photoCategoryCamera => 'カメラ';

  @override
  String get photoCategoryUpload => 'アップロード';

  @override
  String get photoCategoryUploadedPhotos => 'アップロードされた写真';

  @override
  String get photoCategoryEmpty => 'まだ写真がアップロードされていません';

  @override
  String get photoCategoryContinueButton => 'サマリーに続く';

  @override
  String get photoCategoryErrorNoPhotos => '少なくとも1枚の写真を追加してください。';

  @override
  String get photoCategoryErrorCategoryRequired => 'すべての写真のカテゴリ名を入力してください。';

  @override
  String get photoCategorySuccessCreated => '査定が正常に作成されました！';

  @override
  String get photoCategoryMaxPhotos => '最大7枚の写真に達しました。';

  @override
  String cameraCaptureTitle(String category) {
    return '写真を撮る：$category';
  }

  @override
  String get cameraCaptureOpeningCamera => 'カメラを開いています...';

  @override
  String get cameraCaptureOpenCameraButton => 'カメラを開く';

  @override
  String get cameraCaptureRetake => '撮り直し';

  @override
  String get cameraCaptureUsePhoto => 'この写真を使用';

  @override
  String get cameraCaptureDialogTitle => 'カテゴリ名を入力';

  @override
  String get cameraCaptureDialogCategoryLabel => 'カテゴリ名';

  @override
  String get cameraCaptureDialogCategoryPlaceholder => '例：右エンジン、フロントインテリア';

  @override
  String get cameraCaptureDialogCancel => 'キャンセル';

  @override
  String get cameraCaptureDialogSave => '保存';

  @override
  String get cameraCapturePhotoAdded => '写真が追加されました';

  @override
  String get summaryTitle => '確認して提出';

  @override
  String get summaryVehicleInfoSection => '車両情報';

  @override
  String get summaryBrand => 'ブランド';

  @override
  String get summaryModel => 'モデル';

  @override
  String get summaryYear => '年';

  @override
  String get summaryLicensePlate => 'ナンバープレート';

  @override
  String get summaryMileage => '走行距離';

  @override
  String get summaryNotes => 'メモ';

  @override
  String summaryPhotosSection(int count) {
    return '写真（$count枚）';
  }

  @override
  String get summaryNoPhotos => 'まだ写真がアップロードされていません。';

  @override
  String get summaryDisclaimer => '提出することで、提供された情報が正確であることに同意します。';

  @override
  String get summarySubmitButton => '査定を提出';

  @override
  String get summaryFailedToLoad => '読み込みに失敗しました';

  @override
  String get summarySubmissionFailed => '提出に失敗しました';

  @override
  String get summarySubmitSuccess => '査定が正常に提出されました！';

  @override
  String get appraisalResultTitle => '査定結果';

  @override
  String get appraisalResultFailedToLoad => '査定の読み込みに失敗しました';

  @override
  String get appraisalResultNextStepsSection => '次のステップ';

  @override
  String get appraisalResultAdminNotesSection => '管理者メモ';

  @override
  String get appraisalResultVehicleDetailsSection => '車両詳細';

  @override
  String get appraisalResultStatusCompleteTitle => '審査完了！';

  @override
  String get appraisalResultStatusUnderReviewTitle => '審査中';

  @override
  String get appraisalResultStatusCompleteSubtitle => '査定が審査され、価格が設定されました。';

  @override
  String get appraisalResultStatusUnderReviewSubtitle => '審査が完了したらお知らせします。';

  @override
  String get appraisalResultOfferedPrice => '提示購入価格';

  @override
  String appraisalResultValidUntil(String date) {
    return '有効期限：$date';
  }

  @override
  String get appraisalResultContactUs => 'お問い合わせ';

  @override
  String get appraisalResultEditAppraisal => '査定を編集';

  @override
  String get appraisalResultNextStepComplete1 => '提示価格をよく確認してください。';

  @override
  String get appraisalResultNextStepComplete2 => 'チームに連絡して承認または交渉してください。';

  @override
  String get appraisalResultNextStepComplete3 => '車両を持参して実地検査を受けてください。';

  @override
  String get appraisalResultNextStepComplete4 => '取引と書類を完了させてください。';

  @override
  String get appraisalResultNextStepPending1 => 'チームが提出物を審査します。';

  @override
  String get appraisalResultNextStepPending2 => '完了したら通知が届きます。';

  @override
  String get appraisalResultNextStepPending3 => 'いつでも更新情報についてご連絡いただけます。';

  @override
  String get appraisalResultBrandLabel => 'ブランド';

  @override
  String get appraisalResultModelLabel => 'モデル';

  @override
  String get appraisalResultYearLabel => '年';

  @override
  String get appraisalResultLicensePlateLabel => 'ナンバープレート';

  @override
  String get appraisalResultMileageLabel => '走行距離';

  @override
  String get appraisalResultNotesLabel => 'メモ';

  @override
  String get listAppraisalsTitle => '私の査定';

  @override
  String get listAppraisalsFailedToLoad => '査定の読み込みに失敗しました';

  @override
  String get listAppraisalsEmpty => '査定が見つかりません';

  @override
  String get listAppraisalsViewDetails => '詳細を見る';

  @override
  String get editAppraisalTitle => '査定を編集';

  @override
  String get editAppraisalVehicleInfoSection => '車両情報';

  @override
  String editAppraisalPhotosSection(int count) {
    return '写真（$count/7）';
  }

  @override
  String get editAppraisalAddPhoto => '写真を追加';

  @override
  String get editAppraisalNoPhotos => 'まだ写真が追加されていません';

  @override
  String get editAppraisalSaveButton => '変更を保存';

  @override
  String get editAppraisalSuccess => '査定が正常に更新されました！';

  @override
  String get editAppraisalFailedToLoad => '詳細の読み込みに失敗しました';

  @override
  String get editAppraisalErrorMinPhotos => '少なくとも1枚の写真を追加してください。';

  @override
  String get editAppraisalErrorCategoryRequired => 'すべての新しい写真のカテゴリ名を入力してください。';

  @override
  String get loginTitle => 'おかえりなさい';

  @override
  String get loginSubtitle => 'アカウントにサインイン';

  @override
  String get loginTabEmail => 'メール';

  @override
  String get loginTabPhoneOtp => '電話OTP';

  @override
  String get loginEmailLabel => 'メールアドレス';

  @override
  String get loginPasswordLabel => 'パスワード';

  @override
  String get loginButton => 'ログイン';

  @override
  String get loginContinueWithGoogle => 'Googleで続ける';

  @override
  String get loginOr => 'または';

  @override
  String get loginNoAccount => 'アカウントをお持ちでないですか？ ';

  @override
  String get loginRegisterLink => '登録';

  @override
  String get loginPhoneDisabledTitle => '電話OTPは一時的に無効です';

  @override
  String get loginPhoneDisabledSubtitle => 'メールまたはGoogleサインインをご利用ください。';

  @override
  String get loginSuccess => 'ログイン成功';

  @override
  String get loginFailed => 'ログイン失敗';

  @override
  String get registerTitle => 'アカウントを作成';

  @override
  String get registerSubtitle => '始めるために登録してください';

  @override
  String get registerTabEmail => 'メール';

  @override
  String get registerTabPhoneOtp => '電話OTP';

  @override
  String get registerEmailLabel => 'メールアドレス';

  @override
  String get registerPasswordLabel => 'パスワード';

  @override
  String get registerConfirmPasswordLabel => 'パスワードの確認';

  @override
  String get registerFullNameOptional => '氏名（任意）';

  @override
  String get registerAddressOptional => '住所（任意）';

  @override
  String get registerButton => '登録';

  @override
  String get registerContinueWithGoogle => 'Googleで続ける';

  @override
  String get registerOr => 'または';

  @override
  String get registerAlreadyAccount => 'すでにアカウントをお持ちですか？ ';

  @override
  String get registerLoginLink => 'ログイン';

  @override
  String get registerPhoneDisabledTitle => '電話OTPは一時的に無効です';

  @override
  String get registerPhoneDisabledSubtitle => 'メールまたはGoogleサインインをご利用ください。';

  @override
  String get registerSuccess => '登録成功';

  @override
  String get registerFailed => '登録失敗';

  @override
  String homeGreeting(String name) {
    return 'こんにちは、$nameさん！';
  }

  @override
  String get homeReadyForAppraisal => '査定の準備はできていますか？';

  @override
  String get homeLatestAppraisal => '最新の査定';

  @override
  String get homeRefresh => '更新';

  @override
  String get homeSeeAll => 'すべて見る';

  @override
  String get homeStartNewAppraisal => '新しい査定を開始';

  @override
  String get homeViewDetails => '詳細を見る';

  @override
  String get homeIncompleteProfileError => '新しい査定を開始する前に、プロフィールを完了してください。';

  @override
  String get listNotificationsTitle => '通知';

  @override
  String get listNotificationsMarkAllRead => 'すべて既読にする';

  @override
  String get listNotificationsFailedToLoad => '通知の読み込みに失敗しました';

  @override
  String get listNotificationsEmpty => 'まだ通知はありません';

  @override
  String get profileFailedToLoad => 'プロフィールの読み込みに失敗しました';

  @override
  String get profileUpdatePhotoLabel => 'プロフィール写真を更新';

  @override
  String get profileUpdatePhotoHint => '画像を選択';

  @override
  String get profileFullNameLabel => '氏名';

  @override
  String get profileFullNamePlaceholder => '山田太郎';

  @override
  String get profileEmailLabel => 'メールアドレス';

  @override
  String get profileEmailPlaceholder => 'yamada@example.com';

  @override
  String get profileAddressLabel => '住所';

  @override
  String get profileAddressPlaceholder => '東京都渋谷区';

  @override
  String get profileSaveButton => 'プロフィールを保存';

  @override
  String get profileSaveSuccess => 'プロフィールが正常に保存されました';

  @override
  String get profileSaveFailed => 'プロフィールの保存に失敗しました';

  @override
  String get profilePhoneLabel => '電話番号';

  @override
  String get profilePhonePlaceholder => '+819012345678';

  @override
  String get profileGenderLabel => '性別';

  @override
  String get profileGenderPlaceholder => '性別を選択';

  @override
  String get profileBirthDateLabel => '生年月日';

  @override
  String get profileGenderMale => '男性';

  @override
  String get profileGenderFemale => '女性';

  @override
  String get profileGenderOther => 'その他';

  @override
  String get adminShellBottomNavDashboard => 'ダッシュボード';

  @override
  String get adminShellBottomNavScanAsset => '資産をスキャン';

  @override
  String get adminShellBottomNavProfile => 'プロフィール';

  @override
  String get userShellBottomNavHome => 'ホーム';

  @override
  String get userShellBottomNavScanAsset => '資産をスキャン';

  @override
  String get userShellBottomNavProfile => 'プロフィール';

  @override
  String get appEndDrawerTitle => 'Yoshida Motors';

  @override
  String get appEndDrawerPleaseLoginFirst => 'まずログインしてください';

  @override
  String get appEndDrawerTheme => 'テーマ';

  @override
  String get appEndDrawerLanguage => '言語';

  @override
  String get appEndDrawerLogout => 'ログアウト';

  @override
  String get appEndDrawerManagementSection => '管理';

  @override
  String get appEndDrawerMaintenanceSection => 'メンテナンス';

  @override
  String get appEndDrawerEnglish => 'English';

  @override
  String get appEndDrawerIndonesian => 'Indonesia';

  @override
  String get appEndDrawerJapanese => '日本語';

  @override
  String get appEndDrawerMyAssets => '私の資産';

  @override
  String get appEndDrawerNotifications => '通知';

  @override
  String get appEndDrawerMyIssueReports => '私の問題報告';

  @override
  String get appEndDrawerAssets => '資産';

  @override
  String get appEndDrawerAssetMovements => '資産移動';

  @override
  String get appEndDrawerCategories => 'カテゴリ';

  @override
  String get appEndDrawerLocations => '場所';

  @override
  String get appEndDrawerUsers => 'ユーザー';

  @override
  String get appEndDrawerMaintenanceSchedules => 'メンテナンススケジュール';

  @override
  String get appEndDrawerMaintenanceRecords => 'メンテナンス記録';

  @override
  String get appEndDrawerReports => 'レポート';

  @override
  String get appEndDrawerIssueReports => '問題報告';

  @override
  String get appEndDrawerScanLogs => 'スキャンログ';

  @override
  String get appEndDrawerScanAsset => '資産をスキャン';

  @override
  String get appEndDrawerDashboard => 'ダッシュボード';

  @override
  String get appEndDrawerHome => 'ホーム';

  @override
  String get appEndDrawerProfile => 'プロフィール';

  @override
  String get customAppBarTitle => 'Yoshida Motors';

  @override
  String get customAppBarOpenMenu => 'メニューを開く';

  @override
  String get appDropdownSelectOption => 'オプションを選択';

  @override
  String get appSearchFieldHint => '検索...';

  @override
  String get appSearchFieldClear => 'クリア';

  @override
  String get appSearchFieldNoResultsFound => '結果が見つかりません';

  @override
  String get staffShellBottomNavDashboard => 'ダッシュボード';

  @override
  String get staffShellBottomNavScanAsset => '資産をスキャン';

  @override
  String get staffShellBottomNavProfile => 'プロフィール';

  @override
  String get shellDoubleBackToExitApp => 'もう一度戻るボタンを押して終了';

  @override
  String get sharedValidationErrors => '検証エラー';

  @override
  String sharedMaxFilesAllowed(int count) {
    return '最大$countファイルまで許可されています';
  }

  @override
  String sharedFileTooLarge(String name, int size) {
    return 'ファイル$nameは${size}MBの制限を超えています';
  }

  @override
  String get sharedFailedToPickFiles => 'ファイルの選択に失敗しました';

  @override
  String get sharedChooseFiles => 'ファイルを選択';

  @override
  String get sharedUnableToPreviewImage => '画像のプレビューを表示できません';

  @override
  String get sharedVideoPreviewNotImplemented => '動画のプレビューはまだ実装されていません';

  @override
  String get sharedPreviewNotAvailable => 'このファイルタイプのプレビューは利用できません';

  @override
  String get sharedDelete => '削除';

  @override
  String get sharedEdit => '編集';

  @override
  String get sharedOptions => 'オプション';

  @override
  String get sharedCreate => '作成';

  @override
  String get sharedAddNewItem => '新しいアイテムを追加';

  @override
  String get sharedSelectMany => '複数選択';

  @override
  String get sharedSelectItemsToDelete => '削除するアイテムを複数選択';

  @override
  String get sharedFilterAndSort => 'フィルタと並べ替え';

  @override
  String get sharedCustomizeDisplay => '表示をカスタマイズ';

  @override
  String get sharedExport => 'エクスポート';

  @override
  String get sharedExportDataToFile => 'データをファイルにエクスポート';

  @override
  String get sharedTimePlaceholder => 'HH:MM';

  @override
  String get sharedRetry => '再試行';
}
