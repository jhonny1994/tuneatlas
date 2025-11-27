// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(count) =>
      "سيؤدي هذا إلى إزالة جميع ${count} محطة من مفضلاتك. لا يمكن التراجع عن هذا الإجراء.";

  static String m1(count) => "${count} دولة";

  static String m2(filterType, filterValue) => "${filterType}: ${filterValue}";

  static String m3(count) => "${count} لغة";

  static String m4(filterType) => "لا توجد محطات متاحة لهذا ${filterType}";

  static String m5(stationName) => "قيد التشغيل: ${stationName}";

  static String m6(count) => "${count} نتيجة";

  static String m7(stationName, deepLink) =>
      "استمع إلى ${stationName} على TuneAtlas! ${deepLink}";

  static String m8(stationName, country) => "${stationName}، ${country}";

  static String m9(count) => "${count} محطة";

  static String m10(countryCode) => "محطات في ${countryCode}";

  static String m11(count) => "${count} وسم";

  static String m12(count) => "+${count} أخرى";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addToFavoritesLabel": MessageLookupByLibrary.simpleMessage(
      "إضافة إلى المفضلة",
    ),
    "appName": MessageLookupByLibrary.simpleMessage("TuneAtlas"),
    "bitrate": MessageLookupByLibrary.simpleMessage("معدل البت"),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "clear": MessageLookupByLibrary.simpleMessage("مسح"),
    "clearFavorites": MessageLookupByLibrary.simpleMessage("مسح المفضلة"),
    "clearFavoritesConfirmMessage": m0,
    "clearFavoritesConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "مسح جميع المفضلات؟",
    ),
    "codec": MessageLookupByLibrary.simpleMessage("الترميز"),
    "countries": MessageLookupByLibrary.simpleMessage("الدول"),
    "countriesCount": m1,
    "discover": MessageLookupByLibrary.simpleMessage("استكشاف"),
    "emptyStateSemanticLabel": MessageLookupByLibrary.simpleMessage(
      "حالة فارغة",
    ),
    "enterStationName": MessageLookupByLibrary.simpleMessage(
      "أدخل اسم المحطة للبحث",
    ),
    "error": MessageLookupByLibrary.simpleMessage("خطأ"),
    "errorAccessDenied": MessageLookupByLibrary.simpleMessage(
      "الوصول مرفوض - يتطلب البث مصادقة",
    ),
    "errorConnectionTimeout": MessageLookupByLibrary.simpleMessage(
      "انتهت مهلة الاتصال - قد يكون البث غير متصل",
    ),
    "errorFailedToConnect": MessageLookupByLibrary.simpleMessage(
      "فشل الاتصال بالبث - يرجى المحاولة مرة أخرى",
    ),
    "errorFailedToPlay": MessageLookupByLibrary.simpleMessage(
      "فشل تشغيل المحطة",
    ),
    "errorFailedToResume": MessageLookupByLibrary.simpleMessage(
      "فشل استئناف التشغيل",
    ),
    "errorForbidden": MessageLookupByLibrary.simpleMessage(
      "الوصول إلى هذه المحطة مقيد",
    ),
    "errorFormat": MessageLookupByLibrary.simpleMessage("تنسيق صوتي غير مدعوم"),
    "errorLoadingStations": MessageLookupByLibrary.simpleMessage(
      "خطأ في تحميل المحطات",
    ),
    "errorNetwork": MessageLookupByLibrary.simpleMessage(
      "خطأ في الاتصال بالشبكة - تحقق من اتصالك بالإنترنت",
    ),
    "errorNetworkIssue": MessageLookupByLibrary.simpleMessage(
      "خطأ في الشبكة - تحقق من اتصالك",
    ),
    "errorNotFound": MessageLookupByLibrary.simpleMessage(
      "المحطة غير موجودة أو لم تعد متاحة",
    ),
    "errorPlayingStation": MessageLookupByLibrary.simpleMessage(
      "خطأ في تشغيل المحطة",
    ),
    "errorSearchingStations": MessageLookupByLibrary.simpleMessage(
      "خطأ في البحث عن المحطات",
    ),
    "errorSemanticLabel": MessageLookupByLibrary.simpleMessage("خطأ"),
    "errorStreamNotFound": MessageLookupByLibrary.simpleMessage(
      "البث غير موجود - قد تكون المحطة غير متصلة",
    ),
    "errorTimeout": MessageLookupByLibrary.simpleMessage(
      "انتهت مهلة الاتصال - قد تكون المحطة غير متصلة",
    ),
    "errorUnknown": MessageLookupByLibrary.simpleMessage("حدث خطأ غير متوقع"),
    "errorUnsupportedFormat": MessageLookupByLibrary.simpleMessage(
      "تنسيق صوتي غير مدعوم",
    ),
    "exploreDescription": MessageLookupByLibrary.simpleMessage(
      "اعثر على المحطات التي تتناسب مع تفضيلاتك واهتماماتك",
    ),
    "exploreTitle": MessageLookupByLibrary.simpleMessage(
      "استكشف حسب الدولة واللغة والوسوم",
    ),
    "failedToConnectToServers": MessageLookupByLibrary.simpleMessage(
      "فشل الاتصال بخوادم Radio Browser. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.",
    ),
    "failedToInitialize": MessageLookupByLibrary.simpleMessage("فشل التهيئة"),
    "failedToLoadMore": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل المزيد من النتائج",
    ),
    "failedToLoadStations": MessageLookupByLibrary.simpleMessage(
      "فشل تحميل المحطات",
    ),
    "favorites": MessageLookupByLibrary.simpleMessage("المفضلة"),
    "favoritesDescription": MessageLookupByLibrary.simpleMessage(
      "احفظ محطاتك المفضلة للوصول السريع في أي وقت",
    ),
    "favoritesTitle": MessageLookupByLibrary.simpleMessage("قم ببناء مجموعتك"),
    "filteredStationsBy": m2,
    "getStarted": MessageLookupByLibrary.simpleMessage("ابدأ الآن"),
    "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "hq": MessageLookupByLibrary.simpleMessage("عالي الجودة"),
    "initializingApp": MessageLookupByLibrary.simpleMessage(
      "جاري تهيئة التطبيق...",
    ),
    "language": MessageLookupByLibrary.simpleMessage("اللغة"),
    "languages": MessageLookupByLibrary.simpleMessage("اللغات"),
    "languagesCount": m3,
    "library": MessageLookupByLibrary.simpleMessage("المكتبة"),
    "liveRadio": MessageLookupByLibrary.simpleMessage("راديو مباشر"),
    "loading": MessageLookupByLibrary.simpleMessage("جاري التحميل..."),
    "loadingStation": MessageLookupByLibrary.simpleMessage(
      "جاري تحميل المحطة...",
    ),
    "loadingStations": MessageLookupByLibrary.simpleMessage(
      "جاري تحميل المحطات...",
    ),
    "localStations": MessageLookupByLibrary.simpleMessage("المحطات المحلية"),
    "moreOptions": MessageLookupByLibrary.simpleMessage("المزيد من الخيارات"),
    "moreOptionsLabel": MessageLookupByLibrary.simpleMessage(
      "المزيد من الخيارات",
    ),
    "next": MessageLookupByLibrary.simpleMessage("التالي"),
    "noCountriesTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد دول متاحة",
    ),
    "noData": MessageLookupByLibrary.simpleMessage("لا توجد بيانات متاحة"),
    "noFavoritesMessage": MessageLookupByLibrary.simpleMessage(
      "انقر على أيقونة القلب في أي محطة لإضافتها إلى مفضلاتك",
    ),
    "noFavoritesTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد مفضلات بعد",
    ),
    "noInternetConnection": MessageLookupByLibrary.simpleMessage(
      "لا يوجد اتصال بالإنترنت",
    ),
    "noLanguagesTitle": MessageLookupByLibrary.simpleMessage(
      "لا توجد لغات متاحة",
    ),
    "noSearchResultsMessage": MessageLookupByLibrary.simpleMessage(
      "جرب كلمات مفتاحية مختلفة أو تصفح حسب البلد",
    ),
    "noSearchResultsTitle": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على نتائج",
    ),
    "noStationsMessage": m4,
    "noStationsTitle": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على محطات",
    ),
    "noTagsTitle": MessageLookupByLibrary.simpleMessage("لا توجد وسوم متاحة"),
    "nowPlayingLabel": m5,
    "pause": MessageLookupByLibrary.simpleMessage("إيقاف مؤقت"),
    "pauseButtonLabel": MessageLookupByLibrary.simpleMessage("إيقاف مؤقت"),
    "paused": MessageLookupByLibrary.simpleMessage("متوقف مؤقتًا"),
    "play": MessageLookupByLibrary.simpleMessage("تشغيل"),
    "playButtonLabel": MessageLookupByLibrary.simpleMessage("تشغيل"),
    "playNow": MessageLookupByLibrary.simpleMessage("تشغيل الآن"),
    "playing": MessageLookupByLibrary.simpleMessage("قيد التشغيل"),
    "pullToRefresh": MessageLookupByLibrary.simpleMessage("اسحب للتحديث"),
    "radio": MessageLookupByLibrary.simpleMessage("راديو"),
    "ready": MessageLookupByLibrary.simpleMessage("جاهز!"),
    "removeFromFavoritesLabel": MessageLookupByLibrary.simpleMessage(
      "إزالة من المفضلة",
    ),
    "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "retryButtonLabel": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "search": MessageLookupByLibrary.simpleMessage("بحث"),
    "searchFailed": MessageLookupByLibrary.simpleMessage("فشل البحث"),
    "searchForStations": MessageLookupByLibrary.simpleMessage(
      "ابحث عن محطات الراديو",
    ),
    "searchResultsCount": m6,
    "searchStations": MessageLookupByLibrary.simpleMessage(
      "ابحث عن المحطات...",
    ),
    "shareButtonLabel": MessageLookupByLibrary.simpleMessage("مشاركة المحطة"),
    "shareMessage": m7,
    "shareStation": MessageLookupByLibrary.simpleMessage("مشاركة المحطة"),
    "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage("حدث خطأ ما"),
    "stationCardLabel": m8,
    "stationDetails": MessageLookupByLibrary.simpleMessage("تفاصيل المحطة"),
    "stationOptions": MessageLookupByLibrary.simpleMessage("خيارات المحطة"),
    "stations": MessageLookupByLibrary.simpleMessage("المحطات"),
    "stationsCount": m9,
    "stationsIn": m10,
    "stopButtonLabel": MessageLookupByLibrary.simpleMessage("إيقاف التشغيل"),
    "streamTimeoutError": MessageLookupByLibrary.simpleMessage(
      "انتهت مهلة الاتصال بالبث - الخادم لا يستجيب",
    ),
    "tags": MessageLookupByLibrary.simpleMessage("الوسوم"),
    "tagsCount": m11,
    "tagsOverflow": m12,
    "toggleThemeLabel": MessageLookupByLibrary.simpleMessage("تبديل المظهر"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "unknown": MessageLookupByLibrary.simpleMessage("غير معروف"),
    "visitWebsite": MessageLookupByLibrary.simpleMessage("زيارة الموقع"),
    "votes": MessageLookupByLibrary.simpleMessage("التصويتات"),
    "welcomeDescription": MessageLookupByLibrary.simpleMessage(
      "اكتشف واستمع إلى آلاف محطات الراديو من جميع أنحاء العالم",
    ),
    "welcomeTitle": MessageLookupByLibrary.simpleMessage(
      "مرحبًا بك في TuneAtlas",
    ),
  };
}
