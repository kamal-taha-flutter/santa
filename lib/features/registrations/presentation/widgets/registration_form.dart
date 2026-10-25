import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../cubit/registration_form_cubit.dart';
import '../cubit/registrations_list_cubit.dart';

/// Registration form card. The widget owns only presentation state; all
/// validation, persistence and CRUD behaviour stays in [RegistrationFormCubit].
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _governorateController = TextEditingController();
  final _districtController = TextEditingController();
  final _villageStreetController = TextEditingController();
  final _farmAreaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FormMode? _lastMode;
  int? _lastEditingId;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _governorateController.dispose();
    _districtController.dispose();
    _villageStreetController.dispose();
    _farmAreaController.dispose();
    super.dispose();
  }

  void _syncControllers(RegistrationFormState state, {bool force = false}) {
    _syncField(_fullNameController, state.fullName, force: force);
    _syncField(_phoneController, state.phone, force: force);
    _syncField(_governorateController, state.governorate, force: force);
    _syncField(_districtController, state.district, force: force);
    _syncField(_villageStreetController, state.villageStreet, force: force);
    _syncField(_farmAreaController, state.farmArea, force: force);
  }

  void _syncField(
    TextEditingController controller,
    String value, {
    bool force = false,
  }) {
    // Comparing trimmed values prevents the cursor from jumping while the user
    // types leading/trailing spaces. External changes (edit/reset) still sync.
    if (!force && controller.text.trim() == value) return;
    if (controller.text == value) return;
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegistrationFormCubit>();
    return BlocConsumer<RegistrationFormCubit, RegistrationFormState>(
      listener: (context, state) {
        final externalChange =
            _lastMode != state.mode || _lastEditingId != state.editingId;
        _lastMode = state.mode;
        _lastEditingId = state.editingId;
        _syncControllers(state, force: externalChange);

        if (state.successMessage != null) {
          AppSnackBar.show(
            context,
            state.successMessage!,
            type: AppSnackType.success,
          );
          // Keep the records list and its count in sync without a manual
          // refresh, then clear the form for the next registration.
          context.read<RegistrationsListCubit>().refresh();
          cubit.reset();
        }
        if (state.errorMessage != null) {
          AppSnackBar.show(
            context,
            state.errorMessage!,
            type: AppSnackType.error,
          );
        }
      },
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: _FormFields(
                    state: state,
                    cubit: cubit,
                    fullNameController: _fullNameController,
                    phoneController: _phoneController,
                    governorateController: _governorateController,
                    districtController: _districtController,
                    villageStreetController: _villageStreetController,
                    farmAreaController: _farmAreaController,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(210, 50),
                      ),
                      onPressed: state.isSaving
                          ? null
                          : () {
                              _dismissKeyboard();
                              cubit.submit();
                            },
                      icon: state.isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : const Icon(Icons.save_outlined, size: 19),
                      label: Text(
                        state.isSaving
                            ? AppStrings.saveInProgress
                            : AppStrings.saveRegistration,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: state.isSaving
                          ? null
                          : () {
                              _dismissKeyboard();
                              cubit.reset();
                            },
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: Text(
                        state.mode == FormMode.edit
                            ? AppStrings.cancelEdit
                            : AppStrings.resetForm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FormFields extends StatelessWidget {
  const _FormFields({
    required this.state,
    required this.cubit,
    required this.fullNameController,
    required this.phoneController,
    required this.governorateController,
    required this.districtController,
    required this.villageStreetController,
    required this.farmAreaController,
  });

  final RegistrationFormState state;
  final RegistrationFormCubit cubit;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController governorateController;
  final TextEditingController districtController;
  final TextEditingController villageStreetController;
  final TextEditingController farmAreaController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldSpacing = constraints.maxWidth >= 1200
            ? AppSpacing.xxl
            : constraints.maxWidth >= 600
            ? AppSpacing.xl
            : AppSpacing.lg;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TextField(
              controller: fullNameController,
              label: AppStrings.fullName,
              hint: AppStrings.fullNameHint,
              icon: Icons.person_outline_rounded,
              errorText: state.validationErrors['fullName'],
              enabled: !state.isSaving,
              onChanged: cubit.updateFullName,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: fieldSpacing),
            _TextField(
              controller: phoneController,
              label: AppStrings.phone,
              hint: AppStrings.phoneHint,
              icon: Icons.phone_outlined,
              errorText: state.validationErrors['phone'],
              enabled: !state.isSaving,
              keyboardType: TextInputType.phone,
              onChanged: cubit.updatePhone,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: fieldSpacing),
            _TextField(
              controller: governorateController,
              label: AppStrings.governorate,
              hint: AppStrings.governorateHint,
              icon: Icons.map_outlined,
              errorText: state.validationErrors['governorate'],
              enabled: !state.isSaving,
              onChanged: cubit.updateGovernorate,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: fieldSpacing),
            _TextField(
              controller: districtController,
              label: AppStrings.district,
              hint: AppStrings.districtHint,
              icon: Icons.location_city_outlined,
              errorText: state.validationErrors['district'],
              enabled: !state.isSaving,
              onChanged: cubit.updateDistrict,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: fieldSpacing),
            _TextField(
              controller: villageStreetController,
              label: AppStrings.villageStreet,
              hint: AppStrings.villageStreetHint,
              icon: Icons.home_outlined,
              errorText: state.validationErrors['villageStreet'],
              enabled: !state.isSaving,
              onChanged: cubit.updateVillageStreet,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: fieldSpacing),
            DropdownButtonFormField<String>(
              key: ValueKey(
                'business-type-${state.mode.name}-${state.editingId}-${state.businessType}',
              ),
              initialValue: state.businessType.isEmpty
                  ? null
                  : state.businessType,
              isExpanded: true,
              hint: const Text(AppStrings.businessTypeHint),
              decoration: InputDecoration(
                labelText: AppStrings.businessType,
                errorText: state.validationErrors['businessType'],
                prefixIcon: const Icon(Icons.category_outlined, size: 20),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                constraints: const BoxConstraints(minHeight: 72),
              ),
              items: AppStrings.businessTypes
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(growable: false),
              onChanged: state.isSaving ? null : cubit.updateBusinessType,
              borderRadius: AppRadius.field,
              menuMaxHeight: 280,
              dropdownColor: AppColors.surface,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
            if (state.businessType == AppStrings.farmBusinessType) ...[
              SizedBox(height: fieldSpacing),
              _FarmAreaField(
                controller: farmAreaController,
                state: state,
                cubit: cubit,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _FarmAreaField extends StatelessWidget {
  const _FarmAreaField({
    required this.controller,
    required this.state,
    required this.cubit,
  });

  final TextEditingController controller;
  final RegistrationFormState state;
  final RegistrationFormCubit cubit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return TextFormField(
      controller: controller,
      enabled: !state.isSaving,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      onChanged: cubit.updateFarmArea,
      textAlign: TextAlign.right,
      style: textTheme.bodyMedium?.copyWith(
        fontSize: 13.5,
        color: AppColors.ink,
      ),
      decoration: InputDecoration(
        labelText: AppStrings.farmArea,
        hintText: AppStrings.farmAreaHint,
        errorText: state.validationErrors['farmArea'],
        prefixIcon: const Icon(Icons.agriculture_outlined, size: 20),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        constraints: const BoxConstraints(minHeight: 72),
        // suffixIcon: Padding(
        //   padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
        //   child: DropdownButtonHideUnderline(
        //     child: DropdownButton<String>(
        //       value: state.farmAreaUnit,
        //       isDense: true,
        //       borderRadius: AppRadius.field,
        //       dropdownColor: AppColors.surface,
        //       icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        //       style: textTheme.bodyMedium?.copyWith(
        //         fontSize: 13,
        //         color: AppColors.ink,
        //       ),
        //       onChanged: state.isSaving ? null : cubit.updateFarmAreaUnit,
        //       items: AppStrings.farmAreaUnits
        //           .map(
        //             (unit) => DropdownMenuItem<String>(
        //               value: unit,
        //               child: Text(unit),
        //             ),
        //           )
        //           .toList(growable: false),
        //     ),
        //   ),
        // ),
        suffixIconConstraints: const BoxConstraints(minWidth: 78),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.errorText,
    required this.enabled,
    required this.onChanged,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? errorText;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.bodyMedium
          ?.copyWith(fontSize: 13.5, color: AppColors.ink),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: Icon(icon, size: 20),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        constraints: const BoxConstraints(minHeight: 72),
      ),
    );
  }
}
