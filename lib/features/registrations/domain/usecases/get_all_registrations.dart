import '../../../../core/errors/failures.dart';
import '../entities/registration.dart';
import '../repositories/registration_repository.dart';

class GetAllRegistrations {
  GetAllRegistrations(this.repository);
  final RegistrationRepository repository;

  Future<(Failure?, List<Registration>)> call() {
    return repository.getAllRegistrations();
  }
}
