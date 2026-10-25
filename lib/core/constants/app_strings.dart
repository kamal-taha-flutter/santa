class AppStrings {
  AppStrings._();

  static const appName = 'Santa';
  static const appTagline = 'SANTA IMPORT & EXPORT';
  static const appDescription = 'إدارة بيانات الأنشطة التجارية';
  static const close = 'إغلاق';

  // Navigation
  static const navNewRegistration = 'تسجيل جديد';
  static const navRecords = 'سجل الأعمال';
  static const navExport = 'تصدير Excel';
  static const navigation = 'التنقل';

  // Form
  static const registrationPageTitle = 'تسجيل جديد';
  static const registrationPageSubtitle =
      'أضف بيانات النشاط التجاري الجديد، ثم احفظ التسجيل للانتقال إلى السجل التالي.';
  static const fullName = 'الاسم';
  static const phone = 'رقم الهاتف';
  static const governorate = 'المحافظة';
  static const district = 'مركز / مدينة';
  static const villageStreet = 'قرية أو شارع';
  static const businessType = 'نوع النشاط';
  static const businessTypes = ['مزرعة', 'محل', 'موزع', 'مزارع'];
  static const farmBusinessType = 'مزرعة';
  static const farmArea = 'مساحة المزرعة';
  static const farmAreaHint = 'أدخل مساحة المزرعة';
  static const farmAreaUnits = ['', 'فدان', 'أكر'];
  static const farmAreaDefaultUnit = 'فدان';
  static const formTitle = 'بيانات النشاط';
  static const formSubtitleCreate =
      'أدخل بيانات السجل الجديد ثم اضغط حفظ. جميع الحقول مطلوبة.';
  static const formSubtitleEdit =
      'عدّل البيانات المطلوبة ثم احفظ التغييرات. جميع الحقول مطلوبة.';
  static const fullNameHint = 'الاسم الكامل';
  static const phoneHint = '01xxxxxxxxx';
  static const governorateHint = 'اسم المحافظة';
  static const districtHint = 'اسم المركز أو المدينة';
  static const villageStreetHint = 'اسم القرية أو الشارع';
  static const businessTypeHint = 'اختر النشاط';
  static const newRecord = 'سجل جديد';
  static const editMode = 'وضع التعديل';
  static const allFieldsRequired = 'جميع الحقول مطلوبة';

  // Records
  static const recordsTitle = 'سجل الأعمال';
  static const recordsPageSubtitle =
      'تصفّح السجلات المحفوظة، وابحث فيها، وعدّل أو احذف ما تحتاج إليه.';
  static const recordsSubtitle = 'البيانات المسجلة في قاعدة البيانات';
  static const actions = 'الإجراءات';
  static const record = 'سجل';
  static const result = 'نتيجة';
  static const searchHint = 'ابحث بالاسم أو رقم الهاتف أو الشركة أو العنوان';
  static const noRecordsTitle = 'لا توجد سجلات بعد';
  static const noRecordsBody =
      'ابدأ بإضافة أول سجل من صفحة تسجيل جديد لعرضه هنا.';
  static const noResultsTitle = 'لا توجد نتائج مطابقة';
  static const noResultsBody =
      'جرّب كلمات بحث أخرى أو امسح البحث لعرض جميع السجلات.';
  static const loadingRecords = 'جار تحميل السجلات...';
  static const addFirstRecord = 'إضافة أول سجل';
  static const addRecord = 'إضافة سجل';

  // Actions
  static const addNewRecord = 'إضافة سجل جديد';
  static const save = 'حفظ';
  static const saveRegistration = 'حفظ ';
  static const cancel = 'إلغاء';
  static const edit = 'تعديل';
  static const delete = 'حذف';
  static const search = 'بحث';
  static const clearSearch = 'مسح البحث';
  static const exportExcel = 'تصدير إلى Excel';
  static const refreshing = 'جاري التحديث...';
  static const refresh = 'تحديث';
  static const retry = 'إعادة المحاولة';
  static const resetForm = 'مسح';
  static const cancelEdit = 'إلغاء التعديل';
  static const exporting = 'جار التصدير...';
  static const noExportRecords = 'لا توجد سجلات للتصدير';

  // Export
  static const exportPageTitle = 'تصدير Excel';
  static const exportPageSubtitle =
      'أنشئ نسخة Excel من السجلات المحفوظة في قاعدة البيانات المحلية.';
  static const exportCardTitle = 'تصدير جميع السجلات';
  static const exportCardBody =
      'سيتم إنشاء ملف Excel واحد يحتوي على جميع السجلات المحفوظة محلياً، مع إتاحة اختيار مكان الحفظ عبر نافذة النظام.';
  static const exportAllRecordsNote =
      'يشمل التصدير جميع السجلات الموجودة في قاعدة البيانات، وليس فقط نتائج البحث أو الصفحة المعروضة.';
  static const exportFileFormat = 'ملف Excel ‎(.xlsx)‎';
  static const exportRecordsCount = 'إجمالي السجلات المحفوظة';
  static const exportCountLoading = 'جار تحميل العدد...';
  static const exportCancelTitle = 'تم إلغاء التصدير';
  static const exportCancelled = 'تم إلغاء التصدير، ولم يتم إنشاء أي ملف.';
  static const exportPathLabel = 'مسار الملف';

  // Validation and feedback
  static const requiredField = 'هذا الحقل مطلوب';
  static const phoneRequired = 'رقم الهاتف مطلوب';
  static const saveSuccess = 'تم حفظ السجل بنجاح';
  static const saveAnother = 'إضافة سجل آخر';
  static const deleteConfirmTitle = 'تأكيد الحذف';
  static const deleteConfirmBody =
      'هل أنت متأكد من حذف هذا السجل؟ لا يمكن التراجع عن هذا الإجراء.';
  static const deleteSuccess = 'تم حذف السجل بنجاح';
  static const deleteFailed = 'تعذر حذف السجل';
  static const editLoaded = 'تم تحميل بيانات السجل للتعديل';
  static const exportSuccess = 'تم تصدير الملف بنجاح';
  static const noRecords = 'لا توجد سجلات';
  static const noResults = 'لا توجد نتائج مطابقة للبحث';
  static const totalRecords = 'إجمالي السجلات';
  static const loading = 'جار التحميل...';
  static const errorOccurred = 'حدث خطأ';
  static const saveInProgress = 'جاري الحفظ...';
}
