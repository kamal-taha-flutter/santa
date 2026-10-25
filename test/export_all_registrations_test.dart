import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:santa/core/errors/failures.dart';
import 'package:santa/features/export/domain/usecases/export_all_registrations.dart';
import 'package:santa/features/export/domain/usecases/export_registrations.dart';
import 'package:santa/features/registrations/domain/entities/registration.dart';
import 'package:santa/features/registrations/domain/repositories/registration_repository.dart';

class _MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

class _MockExportRegistrations extends Mock implements ExportRegistrations {}

const _records = [
  Registration(
    id: 2,
    fullName: 'سجل ثان',
    phone: '01111111111',
    governorate: 'الجيزة',
    district: 'الدقي',
    villageStreet: 'شارع التحرير',
    businessType: 'موزع',
  ),
  Registration(
    id: 1,
    fullName: 'سجل أول',
    phone: '01000000000',
    governorate: 'القاهرة',
    district: 'مدينة نصر',
    villageStreet: 'شارع عباس العقاد',
    businessType: 'محل',
  ),
];

void main() {
  late _MockRegistrationRepository repository;
  late _MockExportRegistrations exportRegistrations;
  late ExportAllRegistrations exportAllRegistrations;

  setUpAll(() {
    registerFallbackValue(<Registration>[]);
  });

  setUp(() {
    repository = _MockRegistrationRepository();
    exportRegistrations = _MockExportRegistrations();
    exportAllRegistrations = ExportAllRegistrations(
      registrationRepository: repository,
      exportRegistrations: exportRegistrations,
    );
  });

  test('loads every stored record before exporting', () async {
    when(() => repository.getAllRegistrations())
        .thenAnswer((_) async => (null, _records));
    when(() => exportRegistrations(any()))
        .thenAnswer((_) async => (null, '/tmp/registrations.xlsx'));

    final result = await exportAllRegistrations();

    expect(result.$1, isNull);
    expect(result.$2, '/tmp/registrations.xlsx');
    verify(() => repository.getAllRegistrations()).called(1);
    verify(() => exportRegistrations(_records)).called(1);
  });

  test('reports an error without opening a save dialog when empty', () async {
    when(() => repository.getAllRegistrations())
        .thenAnswer((_) async => (null, const <Registration>[]));

    final result = await exportAllRegistrations();

    expect(result.$1, isA<ExportFailure>());
    expect(result.$2, isNull);
    verifyNever(() => exportRegistrations(any()));
  });
}
