import '../../../../core/errors/failures.dart';
import '../../../registrations/domain/entities/registration.dart';
import '../repositories/export_repository.dart';

class ExportRegistrations {
  ExportRegistrations(this.repository);
  final ExportRepository repository;

  Future<(Failure?, String?)> call(List<Registration> records) {
    return repository.exportToExcel(records);
  }
}
