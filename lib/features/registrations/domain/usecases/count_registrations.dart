import '../../../../core/errors/failures.dart';
import '../repositories/registration_repository.dart';

class CountRegistrations {
  CountRegistrations(this.repository);
  final RegistrationRepository repository;

  Future<(Failure?, int)> call() {
    return repository.countRegistrations();
  }
}
