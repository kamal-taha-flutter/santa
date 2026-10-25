import '../../../../core/errors/failures.dart';
import '../../../registrations/domain/entities/registration.dart';

abstract class ExportRepository {
  Future<(Failure?, String?)> exportToExcel(List<Registration> records);
}
