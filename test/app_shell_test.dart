import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:santa/app/shell/app_shell.dart';
import 'package:santa/app/theme/app_theme.dart';
import 'package:santa/core/constants/app_strings.dart';
import 'package:santa/features/export/domain/usecases/export_all_registrations.dart';
import 'package:santa/features/export/presentation/cubit/export_cubit.dart';
import 'package:santa/features/registrations/domain/entities/registration.dart';
import 'package:santa/features/registrations/domain/usecases/count_registrations.dart';
import 'package:santa/features/registrations/domain/usecases/create_registration.dart';
import 'package:santa/features/registrations/domain/usecases/delete_registration.dart';
import 'package:santa/features/registrations/domain/usecases/get_all_registrations.dart';
import 'package:santa/features/registrations/domain/usecases/search_registrations.dart';
import 'package:santa/features/registrations/domain/usecases/update_registration.dart';
import 'package:santa/features/registrations/presentation/cubit/registration_form_cubit.dart';
import 'package:santa/features/registrations/presentation/cubit/registrations_list_cubit.dart';

class _MockGetAllRegistrations extends Mock implements GetAllRegistrations {}

class _MockCountRegistrations extends Mock implements CountRegistrations {}

class _MockSearchRegistrations extends Mock implements SearchRegistrations {}

class _MockDeleteRegistration extends Mock implements DeleteRegistration {}

class _MockCreateRegistration extends Mock implements CreateRegistration {}

class _MockUpdateRegistration extends Mock implements UpdateRegistration {}

class _MockExportAllRegistrations extends Mock
    implements ExportAllRegistrations {}

const _record = Registration(
  id: 1,
  fullName: 'أحمد محمود',
  phone: '01000000000',
  governorate: 'القاهرة',
  district: 'مدينة نصر',
  villageStreet: 'شارع عباس العقاد',
  businessType: 'محل',
);

void main() {
  late RegistrationsListCubit listCubit;
  late RegistrationFormCubit formCubit;
  late ExportCubit exportCubit;
  late _MockCreateRegistration create;

  setUpAll(() {
    registerFallbackValue(_record);
  });

  setUp(() {
    final getAll = _MockGetAllRegistrations();
    final count = _MockCountRegistrations();
    final search = _MockSearchRegistrations();
    final delete = _MockDeleteRegistration();
    create = _MockCreateRegistration();
    final update = _MockUpdateRegistration();
    final exportAll = _MockExportAllRegistrations();

    when(() => getAll()).thenAnswer((_) async => (null, const [_record]));
    when(() => count()).thenAnswer((_) async => (null, 1));
    when(() => search(any())).thenAnswer((_) async => (null, const [_record]));
    when(() => delete(any())).thenAnswer((_) async => (null, true));
    when(() => create(any())).thenAnswer((_) async => (null, 2));
    when(() => update(any())).thenAnswer((_) async => (null, true));
    when(() => exportAll())
        .thenAnswer((_) async => (null, '/tmp/registrations.xlsx'));

    listCubit = RegistrationsListCubit(
      getAllRegistrations: getAll,
      countRegistrations: count,
      searchRegistrations: search,
      deleteRegistration: delete,
    );
    formCubit = RegistrationFormCubit(
      createRegistration: create,
      updateRegistration: update,
    );
    exportCubit = ExportCubit(exportAll);
  });

  tearDown(() async {
    await listCubit.close();
    await formCubit.close();
    await exportCubit.close();
  });

  Future<void> pumpShell(
    WidgetTester tester, {
    Size size = const Size(1600, 900),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: formCubit),
          BlocProvider.value(value: listCubit),
          BlocProvider.value(value: exportCubit),
        ],
        child: MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: AppTheme.supportedLocales,
          localizationsDelegates: AppTheme.localizationsDelegates,
          theme: AppTheme.light,
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          ),
          home: const AppShell(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('opens on the spacious registration form', (tester) async {
    await pumpShell(tester);

    expect(
      find.text(
        'Welcome to Santa Pavilion, the Official Sponsor of Agri Plaza',
      ),
      findsOneWidget,
    );
    expect(
      find.text('We are pleased to register your information with us.'),
      findsOneWidget,
    );
    expect(find.text(AppStrings.registrationPageTitle), findsNothing);
    expect(find.text(AppStrings.formTitle), findsNothing);
    expect(find.text(AppStrings.saveRegistration), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(find.text(AppStrings.navigation), findsNothing);
    for (final label in [
      AppStrings.fullName,
      AppStrings.phone,
      AppStrings.governorate,
      AppStrings.district,
      AppStrings.villageStreet,
      AppStrings.businessType,
    ]) {
      expect(find.text(label), findsWidgets);
    }
    expect(find.text(AppStrings.searchHint), findsNothing);
    expect(find.text(AppStrings.exportExcel), findsNothing);
    expect(find.text(AppStrings.navRecords), findsNothing);
    expect(find.text(AppStrings.navExport), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('registration fields use the available desktop width', (
    tester,
  ) async {
    await pumpShell(tester, size: const Size(1920, 1080));

    final fields = find.byType(TextFormField);
    expect(tester.getSize(fields.first).width, greaterThan(1700));
    expect(
      tester.getSize(find.byType(DropdownButtonFormField<String>)).width,
      greaterThan(1700),
    );
    for (var index = 1; index < fields.evaluate().length; index++) {
      expect(
        tester.getTopLeft(fields.at(index)).dy,
        greaterThan(tester.getTopLeft(fields.at(index - 1)).dy),
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows and clears the farm area for farm records', (
    tester,
  ) async {
    await pumpShell(tester);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.farmBusinessType).last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.farmArea), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(6));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(5), '10');
    expect(formCubit.state.farmArea, '10');
    expect(formCubit.state.farmAreaUnit, AppStrings.farmAreaDefaultUnit);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('محل').last);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.farmArea), findsNothing);
    expect(formCubit.state.farmArea, isEmpty);
    expect(formCubit.state.farmAreaUnit, AppStrings.farmAreaDefaultUnit);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saves the farm area with the selected unit', (tester) async {
    await pumpShell(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'أحمد محمود');
    await tester.enterText(fields.at(1), '01000000000');
    await tester.enterText(fields.at(2), 'القاهرة');
    await tester.enterText(fields.at(3), 'مدينة نصر');
    await tester.enterText(fields.at(4), 'شارع عباس العقاد');

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.farmBusinessType).last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(5), '10');
    await tester.tap(find.byType(DropdownButton<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('أكر').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.saveRegistration));
    await tester.pumpAndSettle();

    final saved = verify(() => create(captureAny())).captured.single;
    expect(saved, isA<Registration>());
    final registration = saved as Registration;
    expect(registration.businessType, AppStrings.farmBusinessType);
    expect(registration.farmArea, '10');
    expect(registration.farmAreaUnit, 'أكر');
    expect(formCubit.state.farmArea, isEmpty);
    expect(formCubit.state.businessType, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('saving clears the form and stays on the registration page', (
    tester,
  ) async {
    await pumpShell(tester);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'أحمد محمود');
    await tester.enterText(fields.at(1), '01000000000');
    await tester.enterText(fields.at(2), 'القاهرة');
    await tester.enterText(fields.at(3), 'مدينة نصر');
    await tester.enterText(fields.at(4), 'شارع عباس العقاد');

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('محل').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.saveRegistration));
    await tester.pumpAndSettle();

    expect(formCubit.state.mode, FormMode.create);
    expect(formCubit.state.fullName, isEmpty);
    expect(formCubit.state.phone, isEmpty);
    expect(formCubit.state.businessType, isEmpty);
    expect(find.text(AppStrings.formTitle), findsNothing);
    expect(find.text(AppStrings.searchHint), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation opens records and export destinations', (
    tester,
  ) async {
    await pumpShell(tester);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.navRecords));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.recordsTitle), findsWidgets);
    expect(find.text(AppStrings.searchHint), findsOneWidget);
    expect(find.text(AppStrings.saveRegistration), findsNothing);
    expect(find.text(AppStrings.navigation), findsNothing);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.navExport));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.exportPageTitle), findsWidgets);
    expect(find.text(AppStrings.exportExcel), findsOneWidget);
    expect(find.text(AppStrings.exportRecordsCount), findsOneWidget);
    expect(find.text(AppStrings.searchHint), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation drawer fits a narrow desktop window', (tester) async {
    await pumpShell(tester, size: const Size(480, 900));

    expect(find.text(AppStrings.navigation), findsNothing);
    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
    expect(find.text(AppStrings.saveRegistration), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.navRecords));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.searchHint), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.menu_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.navExport));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.exportExcel), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
