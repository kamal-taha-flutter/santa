import 'package:flutter/material.dart';

import 'features/export/data/datasources/export_local_data_source.dart';
import 'features/export/data/repositories/export_repository_impl.dart';
import 'features/export/domain/repositories/export_repository.dart';
import 'features/export/domain/usecases/export_all_registrations.dart';
import 'features/export/domain/usecases/export_registrations.dart';
import 'features/export/presentation/cubit/export_cubit.dart';
import 'features/registrations/data/datasources/registration_local_data_source.dart';
import 'features/registrations/data/repositories/registration_repository_impl.dart';
import 'features/registrations/domain/repositories/registration_repository.dart';
import 'features/registrations/domain/usecases/count_registrations.dart';
import 'features/registrations/domain/usecases/create_registration.dart';
import 'features/registrations/domain/usecases/delete_registration.dart';
import 'features/registrations/domain/usecases/get_all_registrations.dart';
import 'features/registrations/domain/usecases/search_registrations.dart';
import 'features/registrations/domain/usecases/update_registration.dart';
import 'features/registrations/presentation/cubit/registration_form_cubit.dart';
import 'features/registrations/presentation/cubit/registrations_list_cubit.dart';

class AppInjection extends InheritedWidget {
  const AppInjection({
    super.key,
    required super.child,
    required this.registrationRepository,
    required this.exportRepository,
    required this.createRegistration,
    required this.getAllRegistrations,
    required this.countRegistrations,
    required this.searchRegistrations,
    required this.updateRegistration,
    required this.deleteRegistration,
    required this.exportRegistrations,
    required this.exportAllRegistrations,
    required this.formCubit,
    required this.listCubit,
    required this.exportCubit,
  });

  final RegistrationRepository registrationRepository;
  final ExportRepository exportRepository;
  final CreateRegistration createRegistration;
  final GetAllRegistrations getAllRegistrations;
  final CountRegistrations countRegistrations;
  final SearchRegistrations searchRegistrations;
  final UpdateRegistration updateRegistration;
  final DeleteRegistration deleteRegistration;
  final ExportRegistrations exportRegistrations;
  final ExportAllRegistrations exportAllRegistrations;
  final RegistrationFormCubit formCubit;
  final RegistrationsListCubit listCubit;
  final ExportCubit exportCubit;

  static AppInjection of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppInjection>();
    assert(widget != null, 'AppInjection not found in context');
    return widget!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class AppCompositionRoot {
  static Future<AppInjection> create({required Widget child}) async {
    final localDataSource = RegistrationLocalDataSource.instance;
    // Ensure DB initialized once
    await localDataSource.database;

    final registrationRepository = RegistrationRepositoryImpl(localDataSource);
    final exportDataSource = ExportLocalDataSource();
    final exportRepository = ExportRepositoryImpl(exportDataSource);

    final createRegistration = CreateRegistration(registrationRepository);
    final getAllRegistrations = GetAllRegistrations(registrationRepository);
    final countRegistrations = CountRegistrations(registrationRepository);
    final searchRegistrations = SearchRegistrations(registrationRepository);
    final updateRegistration = UpdateRegistration(registrationRepository);
    final deleteRegistration = DeleteRegistration(registrationRepository);
    final exportRegistrations = ExportRegistrations(exportRepository);
    final exportAllRegistrations = ExportAllRegistrations(
      registrationRepository: registrationRepository,
      exportRegistrations: exportRegistrations,
    );

    final formCubit = RegistrationFormCubit(
      createRegistration: createRegistration,
      updateRegistration: updateRegistration,
    );
    final listCubit = RegistrationsListCubit(
      getAllRegistrations: getAllRegistrations,
      countRegistrations: countRegistrations,
      searchRegistrations: searchRegistrations,
      deleteRegistration: deleteRegistration,
    );
    final exportCubit = ExportCubit(exportAllRegistrations);

    return AppInjection(
      registrationRepository: registrationRepository,
      exportRepository: exportRepository,
      createRegistration: createRegistration,
      getAllRegistrations: getAllRegistrations,
      countRegistrations: countRegistrations,
      searchRegistrations: searchRegistrations,
      updateRegistration: updateRegistration,
      deleteRegistration: deleteRegistration,
      exportRegistrations: exportRegistrations,
      exportAllRegistrations: exportAllRegistrations,
      formCubit: formCubit,
      listCubit: listCubit,
      exportCubit: exportCubit,
      child: child,
    );
  }
}
