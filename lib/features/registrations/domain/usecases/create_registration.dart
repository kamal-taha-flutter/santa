import '../../../../core/errors/failures.dart';
import '../entities/registration.dart';
import '../repositories/registration_repository.dart';

class CreateRegistration {
  CreateRegistration(this.repository);
  final RegistrationRepository repository;

  Future<(Failure?, int?)> call(Registration registration) {
    return repository.createRegistration(registration);
  }
}
