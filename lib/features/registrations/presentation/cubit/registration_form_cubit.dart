import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/registration.dart';
import '../../domain/usecases/create_registration.dart';
import '../../domain/usecases/update_registration.dart';

part 'registration_form_state.dart';

class RegistrationFormCubit extends Cubit<RegistrationFormState> {
  RegistrationFormCubit({
    required this.createRegistration,
    required this.updateRegistration,
  }) : super(const RegistrationFormState());

  final CreateRegistration createRegistration;
  final UpdateRegistration updateRegistration;

  void loadForEdit(Registration registration) {
    final farmAreaUnit =
        AppStrings.farmAreaUnits.contains(registration.farmAreaUnit)
        ? registration.farmAreaUnit
        : AppStrings.farmAreaDefaultUnit;
    emit(
      state.copyWith(
        mode: FormMode.edit,
        editingId: registration.id,
        fullName: registration.fullName,
        phone: registration.phone,
        governorate: registration.governorate,
        district: registration.district,
        villageStreet: registration.villageStreet,
        businessType: registration.businessType,
        farmArea: registration.farmArea,
        farmAreaUnit: farmAreaUnit,
        isSaving: false,
        successMessage: null,
        errorMessage: null,
        validationErrors: const {},
      ),
    );
  }

  void reset() {
    emit(const RegistrationFormState());
  }

  void updateFullName(String value) {
    emit(
      state.copyWith(
        fullName: value.trim(),
        validationErrors: _clearError(state.validationErrors, 'fullName'),
      ),
    );
  }

  void updatePhone(String value) {
    emit(
      state.copyWith(
        phone: value.trim(),
        validationErrors: _clearError(state.validationErrors, 'phone'),
      ),
    );
  }

  void updateGovernorate(String value) {
    emit(
      state.copyWith(
        governorate: value.trim(),
        validationErrors: _clearError(state.validationErrors, 'governorate'),
      ),
    );
  }

  void updateDistrict(String value) {
    emit(
      state.copyWith(
        district: value.trim(),
        validationErrors: _clearError(state.validationErrors, 'district'),
      ),
    );
  }

  void updateVillageStreet(String value) {
    emit(
      state.copyWith(
        villageStreet: value.trim(),
        validationErrors: _clearError(state.validationErrors, 'villageStreet'),
      ),
    );
  }

  void updateFarmArea(String value) {
    emit(
      state.copyWith(
        farmArea: value.trim(),
        validationErrors: _clearError(state.validationErrors, 'farmArea'),
      ),
    );
  }

  void updateFarmAreaUnit(String? value) {
    if (value == null) return;
    final errors = state.farmArea.trim().isEmpty
        ? state.validationErrors
        : _clearError(state.validationErrors, 'farmArea');
    emit(state.copyWith(farmAreaUnit: value, validationErrors: errors));
  }

  void updateBusinessType(String? value) {
    if (value == null) return;
    final isFarm = value == AppStrings.farmBusinessType;
    final errors = _clearError(state.validationErrors, 'businessType');
    if (!isFarm) errors.remove('farmArea');
    emit(
      state.copyWith(
        businessType: value,
        farmArea: isFarm ? state.farmArea : '',
        farmAreaUnit: isFarm
            ? state.farmAreaUnit
            : AppStrings.farmAreaDefaultUnit,
        validationErrors: errors,
      ),
    );
  }

  Map<String, String> _clearError(Map<String, String> errors, String key) {
    final copy = Map<String, String>.from(errors);
    copy.remove(key);
    return copy;
  }

  bool _validate() {
    final errors = <String, String>{};
    if (state.fullName.trim().isEmpty) {
      errors['fullName'] = AppStrings.requiredField;
    }
    if (state.phone.trim().isEmpty) {
      errors['phone'] = AppStrings.phoneRequired;
    }
    if (state.governorate.trim().isEmpty) {
      errors['governorate'] = AppStrings.requiredField;
    }
    if (state.district.trim().isEmpty) {
      errors['district'] = AppStrings.requiredField;
    }
    if (state.villageStreet.trim().isEmpty) {
      errors['villageStreet'] = AppStrings.requiredField;
    }
    if (state.businessType.trim().isEmpty) {
      errors['businessType'] = AppStrings.requiredField;
    }
    if (state.businessType == AppStrings.farmBusinessType &&
        (state.farmArea.trim().isEmpty || state.farmAreaUnit.trim().isEmpty)) {
      errors['farmArea'] = AppStrings.requiredField;
    }
    emit(state.copyWith(validationErrors: errors));
    return errors.isEmpty;
  }

  Future<void> submit() async {
    if (state.isSaving) return;
    if (!_validate()) return;

    emit(
      state.copyWith(isSaving: true, successMessage: null, errorMessage: null),
    );

    final registration = Registration(
      id: state.mode == FormMode.edit ? state.editingId : null,
      fullName: state.fullName.trim(),
      phone: state.phone.trim(),
      governorate: state.governorate.trim(),
      district: state.district.trim(),
      villageStreet: state.villageStreet.trim(),
      businessType: state.businessType.trim(),
      farmArea: state.businessType == AppStrings.farmBusinessType
          ? state.farmArea.trim()
          : '',
      farmAreaUnit: state.businessType == AppStrings.farmBusinessType
          ? state.farmAreaUnit.trim()
          : '',
      createdAt: DateTime.now(),
    );

    if (state.mode == FormMode.edit) {
      final result = await updateRegistration(registration);
      final failure = result.$1;
      final success = result.$2;
      if (failure != null || success != true) {
        emit(
          state.copyWith(
            isSaving: false,
            errorMessage: failure?.message ?? AppStrings.errorOccurred,
          ),
        );
        return;
      }
      emit(
        state.copyWith(isSaving: false, successMessage: 'تم تعديل السجل بنجاح'),
      );
      return;
    }

    final result = await createRegistration(registration);
    final failure = result.$1;
    final id = result.$2;
    if (failure != null || id == null || id <= 0) {
      emit(
        state.copyWith(
          isSaving: false,
          errorMessage: failure?.message ?? AppStrings.errorOccurred,
        ),
      );
      return;
    }
    emit(
      state.copyWith(isSaving: false, successMessage: AppStrings.saveSuccess),
    );
  }
}
