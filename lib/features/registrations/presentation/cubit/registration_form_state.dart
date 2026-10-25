part of 'registration_form_cubit.dart';

enum FormMode { create, edit }

class RegistrationFormState extends Equatable {
  const RegistrationFormState({
    this.mode = FormMode.create,
    this.editingId,
    this.fullName = '',
    this.phone = '',
    this.governorate = '',
    this.district = '',
    this.villageStreet = '',
    this.businessType = '',
    this.farmArea = '',
    this.farmAreaUnit = AppStrings.farmAreaDefaultUnit,
    this.isSaving = false,
    this.validationErrors = const {},
    this.successMessage,
    this.errorMessage,
  });

  final FormMode mode;
  final int? editingId;
  final String fullName;
  final String phone;
  final String governorate;
  final String district;
  final String villageStreet;
  final String businessType;
  final String farmArea;
  final String farmAreaUnit;
  final bool isSaving;
  final Map<String, String> validationErrors;
  final String? successMessage;
  final String? errorMessage;

  RegistrationFormState copyWith({
    FormMode? mode,
    int? editingId,
    String? fullName,
    String? phone,
    String? governorate,
    String? district,
    String? villageStreet,
    String? businessType,
    String? farmArea,
    String? farmAreaUnit,
    bool? isSaving,
    Map<String, String>? validationErrors,
    String? successMessage,
    String? errorMessage,
  }) {
    return RegistrationFormState(
      mode: mode ?? this.mode,
      editingId: editingId ?? this.editingId,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      district: district ?? this.district,
      villageStreet: villageStreet ?? this.villageStreet,
      businessType: businessType ?? this.businessType,
      farmArea: farmArea ?? this.farmArea,
      farmAreaUnit: farmAreaUnit ?? this.farmAreaUnit,
      isSaving: isSaving ?? this.isSaving,
      validationErrors: validationErrors ?? this.validationErrors,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    mode,
    editingId,
    fullName,
    phone,
    governorate,
    district,
    villageStreet,
    businessType,
    farmArea,
    farmAreaUnit,
    isSaving,
    validationErrors,
    successMessage,
    errorMessage,
  ];
}
