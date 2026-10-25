import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/failures.dart';
import '../../../registrations/domain/entities/registration.dart';

class ExportLocalDataSource {
  Future<(Failure?, String?)> export(List<Registration> records) async {
    try {
      final excel = Excel.createExcel();
      final defaultSheet = excel['السجلات'];
      excel.setDefaultSheet('السجلات');

      defaultSheet.appendRow([
        TextCellValue('الاسم'),
        TextCellValue('رقم الهاتف'),
        TextCellValue('المحافظة'),
        TextCellValue('مركز / مدينة'),
        TextCellValue('قرية أو شارع'),
        TextCellValue('نوع النشاط'),
        TextCellValue('مساحة المزرعة'),
        TextCellValue('الرقم التسلسلي'),
        TextCellValue('تاريخ التسجيل'),
      ]);

      for (final record in records) {
        defaultSheet.appendRow([
          TextCellValue(record.fullName),
          TextCellValue(record.phone),
          TextCellValue(record.governorate),
          TextCellValue(record.district),
          TextCellValue(record.villageStreet),
          TextCellValue(record.businessType),
          TextCellValue('${record.farmArea} ${record.farmAreaUnit}'.trim()),
          record.id != null ? IntCellValue(record.id!) : TextCellValue(''),
          TextCellValue(record.createdAt?.toIso8601String() ?? ''),
        ]);
      }

      final fileBytes = excel.save();
      if (fileBytes == null) {
        return (const ExportFailure('فشل إنشاء ملف Excel'), null);
      }

      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final suggestedName = 'registrations_$date.xlsx';

      final FileSaveLocation? location = await getSaveLocation(
        suggestedName: suggestedName,
        acceptedTypeGroups: const [
          XTypeGroup(label: 'Excel', extensions: ['xlsx']),
        ],
      );

      if (location == null) {
        return (null, null);
      }

      final file = File(location.path);
      await file.writeAsBytes(fileBytes, flush: true);
      return (null, location.path);
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('permission') || msg.contains('Permission')) {
        return (const PermissionFailure('لا يوجد صلاحية لحفظ الملف'), null);
      }
      return (ExportFailure('فشل تصدير الملف: $msg'), null);
    }
  }
}
