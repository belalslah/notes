// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق الملاحظات';

  @override
  String get welcomeBack => 'مرحباً بعودتك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ سجل الآن';

  @override
  String get name => 'الاسم';

  @override
  String get invalidEmailPassword => 'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get pleaseEnterName => 'الرجاء إدخال الاسم';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get myNotes => 'ملاحظاتي';

  @override
  String get noNotes => 'لا توجد ملاحظات';

  @override
  String get createFirstNote => 'اضغط على + لإنشاء أول ملاحظة';

  @override
  String get addNote => 'إضافة ملاحظة';

  @override
  String get editNote => 'تعديل الملاحظة';

  @override
  String get title => 'العنوان';

  @override
  String get content => 'المحتوى';

  @override
  String get noteColor => 'لون الملاحظة';

  @override
  String get pleaseEnterTitle => 'الرجاء إدخال العنوان';

  @override
  String get pleaseEnterContent => 'الرجاء إدخال المحتوى';

  @override
  String get delete => 'حذف';

  @override
  String get deleteNote => 'حذف الملاحظة';

  @override
  String get deleteNoteConfirm => 'هل أنت متأكد من حذف هذه الملاحظة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح';

  @override
  String get discardChanges => 'تجاهل التغييرات';

  @override
  String get discardChangesConfirm => 'هل أنت متأكد من تجاهل التغييرات؟';

  @override
  String get discard => 'تجاهل';

  @override
  String get sessionExpired => 'انتهت الجلسة. الرجاء تسجيل الدخول مرة أخرى';

  @override
  String get errorSavingNote => 'خطأ في حفظ الملاحظة';

  @override
  String get errorLoadingNotes => 'خطأ في تحميل الملاحظات';

  @override
  String get errorDeletingNote => 'خطأ في حذف الملاحظة';
}
