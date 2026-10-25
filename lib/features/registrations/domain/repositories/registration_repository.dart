import '../../../../core/errors/failures.dart';
import '../entities/registration.dart';

abstract class RegistrationRepository {
  Future<(Failure?, int?)> createRegistration(Registration registration);
  Future<(Failure?, List<Registration>)> getAllRegistrations();
  Future<(Failure?, int)> countRegistrations();
  Future<(Failure?, List<Registration>)> searchRegistrations(String query);
  Future<(Failure?, Registration?)> getRegistrationById(int id);
  Future<(Failure?, bool)> updateRegistration(Registration registration);
  Future<(Failure?, bool)> deleteRegistration(int id);
}
