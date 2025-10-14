// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'TuneAtlas';

  @override
  String get codec => 'الترميز';

  @override
  String get bitrate => 'معدل البت';

  @override
  String get hq => 'عالي الجودة';

  @override
  String get votes => 'التصويتات';

  @override
  String get playNow => 'تشغيل الآن';

  @override
  String get moreOptions => 'المزيد من الخيارات';

  @override
  String get shareStation => 'مشاركة المحطة';

  @override
  String get stationDetails => 'تفاصيل المحطة';

  @override
  String get visitWebsite => 'زيارة الموقع';

  @override
  String get stationOptions => 'خيارات المحطة';

  @override
  String tagsOverflow(int count) {
    return '+$count أخرى';
  }

  @override
  String get localStations => 'المحطات المحلية';

  @override
  String get pullToRefresh => 'اسحب للتحديث';

  @override
  String get loadingStations => 'جاري تحميل المحطات...';

  @override
  String get errorLoadingStations => 'خطأ في تحميل المحطات';

  @override
  String get library => 'المكتبة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get clearFavorites => 'مسح المفضلة';

  @override
  String get clearFavoritesConfirmTitle => 'مسح جميع المفضلات؟';

  @override
  String clearFavoritesConfirmMessage(int count) {
    return 'سيؤدي هذا إلى إزالة جميع $count محطة من مفضلاتك. لا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get clear => 'مسح';

  @override
  String get noFavoritesTitle => 'لا توجد مفضلات بعد';

  @override
  String get noFavoritesMessage =>
      'انقر على أيقونة القلب في أي محطة لإضافتها إلى مفضلاتك';

  @override
  String get search => 'بحث';

  @override
  String get searchStations => 'ابحث عن المحطات...';

  @override
  String searchResultsCount(int count) {
    return '$count نتيجة';
  }

  @override
  String get noSearchResultsTitle => 'لم يتم العثور على نتائج';

  @override
  String get noSearchResultsMessage =>
      'جرب كلمات مفتاحية مختلفة أو تصفح حسب البلد';

  @override
  String get errorSearchingStations => 'خطأ في البحث عن المحطات';

  @override
  String get discover => 'استكشاف';

  @override
  String get countries => 'الدول';

  @override
  String get languages => 'اللغات';

  @override
  String get tags => 'الوسوم';

  @override
  String countriesCount(int count) {
    return '$count دولة';
  }

  @override
  String languagesCount(int count) {
    return '$count لغة';
  }

  @override
  String tagsCount(int count) {
    return '$count وسم';
  }

  @override
  String stationsCount(int count) {
    return '$count محطة';
  }

  @override
  String get noCountriesTitle => 'لا توجد دول متاحة';

  @override
  String get noLanguagesTitle => 'لا توجد لغات متاحة';

  @override
  String get noTagsTitle => 'لا توجد وسوم متاحة';

  @override
  String filteredStationsBy(String filterType, String filterValue) {
    return '$filterType: $filterValue';
  }

  @override
  String get noStationsTitle => 'لم يتم العثور على محطات';

  @override
  String noStationsMessage(String filterType) {
    return 'لا توجد محطات متاحة لهذا $filterType';
  }

  @override
  String get welcomeTitle => 'مرحبًا بك في TuneAtlas';

  @override
  String get welcomeDescription =>
      'اكتشف واستمع إلى آلاف محطات الراديو من جميع أنحاء العالم';

  @override
  String get exploreTitle => 'استكشف حسب الدولة واللغة والوسوم';

  @override
  String get exploreDescription =>
      'اعثر على المحطات التي تتناسب مع تفضيلاتك واهتماماتك';

  @override
  String get favoritesTitle => 'قم ببناء مجموعتك';

  @override
  String get favoritesDescription =>
      'احفظ محطاتك المفضلة للوصول السريع في أي وقت';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get initializingApp => 'جاري تهيئة التطبيق...';

  @override
  String get failedToInitialize => 'فشل التهيئة';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get loadingStation => 'جاري تحميل المحطة...';

  @override
  String get errorPlayingStation => 'خطأ في تشغيل المحطة';

  @override
  String get errorTimeout => 'انتهت مهلة الاتصال - قد تكون المحطة غير متصلة';

  @override
  String get errorNotFound => 'المحطة غير موجودة أو لم تعد متاحة';

  @override
  String get errorForbidden => 'الوصول إلى هذه المحطة مقيد';

  @override
  String get errorNetwork =>
      'خطأ في الاتصال بالشبكة - تحقق من اتصالك بالإنترنت';

  @override
  String get errorFormat => 'تنسيق صوتي غير مدعوم';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get unknown => 'غير معروف';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get searchForStations => 'ابحث عن محطات الراديو';

  @override
  String get enterStationName => 'أدخل اسم المحطة للبحث';

  @override
  String get playing => 'قيد التشغيل';

  @override
  String get paused => 'متوقف مؤقتًا';

  @override
  String get ready => 'جاهز!';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get play => 'تشغيل';

  @override
  String get home => 'الرئيسية';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get errorFailedToConnect =>
      'فشل الاتصال بالبث - يرجى المحاولة مرة أخرى';

  @override
  String get errorConnectionTimeout =>
      'انتهت مهلة الاتصال - قد يكون البث غير متصل';

  @override
  String get errorStreamNotFound => 'البث غير موجود - قد تكون المحطة غير متصلة';

  @override
  String get errorAccessDenied => 'الوصول مرفوض - يتطلب البث مصادقة';

  @override
  String get errorNetworkIssue => 'خطأ في الشبكة - تحقق من اتصالك';

  @override
  String get errorUnsupportedFormat => 'تنسيق صوتي غير مدعوم';

  @override
  String get errorFailedToPlay => 'فشل تشغيل المحطة';

  @override
  String get errorFailedToResume => 'فشل استئناف التشغيل';

  @override
  String stationsIn(String countryCode) {
    return 'محطات في $countryCode';
  }

  @override
  String get stations => 'المحطات';

  @override
  String get emptyStateSemanticLabel => 'حالة فارغة';

  @override
  String get errorSemanticLabel => 'خطأ';

  @override
  String get language => 'اللغة';
}
