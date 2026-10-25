import '../../../../core/errors/failures.dart';
import '../../domain/entities/registration.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_local_data_source.dart';
import '../models/registration_model.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  RegistrationRepositoryImpl(this.localDataSource);
  final RegistrationLocalDataSource localDataSource;

  @override
  Future<(Failure?, int?)> createRegistration(Registration registration) async {
    try {
      final model = RegistrationModel.fromEntity(registration);
      final id = await localDataSource.insertRegistration(model);
      if (id <= 0) {
        return (const DatabaseFailure('فشل حفظ السجل'), null);
      }
      return (null, id);
    } catch (e) {
      return (DatabaseFailure('فشل حفظ السجل: ${e.toString()}'), null);
    }
  }

  @override
  Future<(Failure?, List<Registration>)> getAllRegistrations() async {
    try {
      final list = await localDataSource.getAllRegistrations();
      return (null, list);
    } catch (e) {
      return (
        DatabaseFailure('فشل تحميل السجلات: ${e.toString()}'),
        <Registration>[],
      );
    }
  }

  @override
  Future<(Failure?, int)> countRegistrations() async {
    try {
      final count = await localDataSource.countRegistrations();
      return (null, count);
    } catch (e) {
      return (DatabaseFailure('فشل حساب عدد السجلات: ${e.toString()}'), 0);
    }
  }

  @override
  Future<(Failure?, List<Registration>)> searchRegistrations(
    String query,
  ) async {
    try {
      final list = await localDataSource.searchRegistrations(query);
      return (null, list);
    } catch (e) {
      return (DatabaseFailure('فشل البحث: ${e.toString()}'), <Registration>[]);
    }
  }

  @override
  Future<(Failure?, Registration?)> getRegistrationById(int id) async {
    try {
      final item = await localDataSource.getRegistrationById(id);
      return (null, item);
    } catch (e) {
      return (DatabaseFailure('فشل تحميل السجل: ${e.toString()}'), null);
    }
  }

  @override
  Future<(Failure?, bool)> updateRegistration(Registration registration) async {
    try {
      if (registration.id == null) {
        return (const ValidationFailure('معرف السجل مطلوب للتعديل'), false);
      }
      final model = RegistrationModel.fromEntity(registration);
      final count = await localDataSource.updateRegistration(model);
      return (null, count > 0);
    } catch (e) {
      return (DatabaseFailure('فشل تعديل السجل: ${e.toString()}'), false);
    }
  }

  @override
  Future<(Failure?, bool)> deleteRegistration(int id) async {
    try {
      final count = await localDataSource.deleteRegistration(id);
      return (null, count > 0);
    } catch (e) {
      return (DatabaseFailure('فشل حذف السجل: ${e.toString()}'), false);
    }
  }
}
