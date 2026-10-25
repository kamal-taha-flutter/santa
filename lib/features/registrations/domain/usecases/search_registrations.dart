import '../../../../core/errors/failures.dart';
import '../entities/registration.dart';
import '../repositories/registration_repository.dart';

class SearchRegistrations {
  SearchRegistrations(this.repository);
  final RegistrationRepository repository;

  Future<(Failure?, List<Registration>)> call(String query) {
    return repository.searchRegistrations(query);
  }
}
