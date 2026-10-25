import '../../../../core/errors/failures.dart';
import '../repositories/registration_repository.dart';

class DeleteRegistration {
  DeleteRegistration(this.repository);
  final RegistrationRepository repository;

  Future<(Failure?, bool)> call(int id) {
    return repository.deleteRegistration(id);
  }
}
