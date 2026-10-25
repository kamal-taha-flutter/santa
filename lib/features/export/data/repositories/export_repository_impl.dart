import '../../../../core/errors/failures.dart';
import '../../../registrations/domain/entities/registration.dart';
import '../../domain/repositories/export_repository.dart';
import '../datasources/export_local_data_source.dart';

class ExportRepositoryImpl implements ExportRepository {
  ExportRepositoryImpl(this.dataSource);
  final ExportLocalDataSource dataSource;

  @override
  Future<(Failure?, String?)> exportToExcel(List<Registration> records) {
    return dataSource.export(records);
  }
}
