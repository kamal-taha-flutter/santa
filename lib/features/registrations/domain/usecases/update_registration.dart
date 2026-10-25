import '../../../../core/errors/failures.dart';
import '../entities/registration.dart';
import '../repositories/registration_repository.dart';

class UpdateRegistration {
  UpdateRegistration(this.repository);
  final RegistrationRepository repository;

  Future<(Failure?, bool)> call(Registration registration) {
    return repository.updateRegistration(registration);
  }
}
