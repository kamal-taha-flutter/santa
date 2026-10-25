import '../../../../core/errors/failures.dart';
import '../../../registrations/domain/repositories/registration_repository.dart';
import 'export_registrations.dart';

/// Exports every registration stored in the local database.
///
/// The records are loaded from the database at export time so the result never
/// depends on the current page, list scroll position, or active search filter.
class ExportAllRegistrations {
  ExportAllRegistrations({
    required this.registrationRepository,
    required this.exportRegistrations,
  });

  final RegistrationRepository registrationRepository;
  final ExportRegistrations exportRegistrations;

  Future<(Failure?, String?)> call() async {
    final result = await registrationRepository.getAllRegistrations();
    final failure = result.$1;
    final records = result.$2;
    if (failure != null) {
      return (failure, null);
    }
    if (records.isEmpty) {
      return (const ExportFailure('لا توجد سجلات للتصدير'), null);
    }
    return exportRegistrations(records);
  }
}
