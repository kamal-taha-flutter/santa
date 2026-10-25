import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/page_header.dart';
import '../../../registrations/presentation/cubit/registrations_list_cubit.dart';
import '../cubit/export_cubit.dart';

/// Dedicated workspace for exporting every locally stored registration.
class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExportCubit, ExportState>(
      listener: (context, state) {
        final exportCubit = context.read<ExportCubit>();
        switch (state.status) {
          case ExportStatus.success:
            if (state.message != null) {
              AppSnackBar.show(
                context,
                state.message!,
                type: AppSnackType.success,
                duration: const Duration(seconds: 6),
              );
            }
            exportCubit.reset();
            break;
          case ExportStatus.error:
            if (state.message != null) {
              AppSnackBar.show(
                context,
                state.message!,
                type: AppSnackType.error,
              );
            }
            exportCubit.reset();
            break;
          case ExportStatus.cancelled:
            AppSnackBar.show(
              context,
              AppStrings.exportCancelled,
              type: AppSnackType.info,
            );
            exportCubit.reset();
            break;
          case ExportStatus.initial:
          case ExportStatus.loading:
            break;
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final horizontalPadding = width < 600
              ? AppSpacing.lg
              : width < 1100
              ? AppSpacing.xxl
              : AppSpacing.xxxl;

          return Scrollbar(
            child: SingleChildScrollView(
              key: const PageStorageKey('export-page-scroll'),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: AppSpacing.xxl,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.exportPageMaxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const PageHeader(
                        icon: Icons.file_download_outlined,
                        title: AppStrings.exportPageTitle,
                        subtitle: AppStrings.exportPageSubtitle,
                        iconColor: AppColors.brandGreenDark,
                        iconBackground: AppColors.brandGreenSoft,
                        iconBorderColor: AppColors.brandGreen,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _ExportCard(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final padding = constraints.maxWidth < 620
              ? AppSpacing.lg
              : AppSpacing.xxl;

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.brandGreenSoft,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: AppColors.brandGreen.withValues(alpha: 0.55),
                        ),
                      ),
                      child: const Icon(
                        Icons.grid_on_rounded,
                        color: AppColors.brandGreenDark,
                        size: 27,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.exportCardTitle,
                            style: textTheme.titleLarge,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            AppStrings.exportCardBody,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.inkMuted,
                              height: 1.65,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.xl),
                const _ExportCountSummary(),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.brandBlueTint,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: AppColors.brandBlue.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 19,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          AppStrings.exportAllRecordsNote,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.inkMuted,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                BlocBuilder<ExportCubit, ExportState>(
                  builder: (context, state) {
                    final isExporting = state.status == ExportStatus.loading;
                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                        ),
                        onPressed: isExporting
                            ? null
                            : () => context.read<ExportCubit>().exportAll(),
                        icon: isExporting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.onPrimary,
                                ),
                              )
                            : const Icon(
                                Icons.file_download_outlined,
                                size: 20,
                              ),
                        label: Text(
                          isExporting
                              ? AppStrings.exporting
                              : AppStrings.exportExcel,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ExportCountSummary extends StatelessWidget {
  const _ExportCountSummary();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<RegistrationsListCubit, RegistrationsListState>(
      builder: (context, state) {
        final isLoading =
            state.status == ListStatus.initial ||
            state.status == ListStatus.loading;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.brandBlueSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.exportRecordsCount,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (isLoading)
                      Text(
                        AppStrings.exportCountLoading,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      )
                    else
                      Text(
                        '${state.totalCount}',
                        style: textTheme.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontSize: 22,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  AppStrings.exportFileFormat,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
