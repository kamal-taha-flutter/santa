import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/page_header.dart';
import '../../domain/entities/registration.dart';
import '../cubit/registrations_list_cubit.dart';
import '../widgets/records_panel.dart';

/// Full-size workspace for browsing and managing saved registrations.
class RecordsPage extends StatelessWidget {
  const RecordsPage({
    super.key,
    required this.onEdit,
    required this.onCreateRequested,
  });

  final ValueChanged<Registration> onEdit;
  final VoidCallback onCreateRequested;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width < 600
            ? AppSpacing.lg
            : width < 1100
            ? AppSpacing.xxl
            : AppSpacing.xxxl;

        return Scrollbar(
          child: SingleChildScrollView(
            key: const PageStorageKey('records-page-scroll'),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: AppSpacing.xxl,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.contentMaxWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PageHeader(
                      icon: Icons.table_rows_rounded,
                      title: AppStrings.recordsTitle,
                      subtitle: AppStrings.recordsPageSubtitle,
                      iconColor: AppColors.secondaryDark,
                      iconBackground: AppColors.brandOrangeSoft,
                      iconBorderColor: AppColors.brandOrange.withValues(
                        alpha: 0.24,
                      ),
                      trailing: Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.sm,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const _RecordsCountBadge(),
                          FilledButton.tonalIcon(
                            onPressed: onCreateRequested,
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text(AppStrings.addRecord),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    RecordsPanel(
                      onEdit: onEdit,
                      onCreateRequested: onCreateRequested,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RecordsCountBadge extends StatelessWidget {
  const _RecordsCountBadge();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationsListCubit, RegistrationsListState>(
      builder: (context, state) {
        final isLoading =
            state.status == ListStatus.initial ||
            state.status == ListStatus.loading;
        final isFiltered = state.query.trim().isNotEmpty;
        final count = isFiltered ? state.items.length : state.totalCount;
        final label = isFiltered ? AppStrings.result : AppStrings.record;
        final textTheme = Theme.of(context).textTheme;

        return Container(
          constraints: const BoxConstraints(minHeight: 46),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.brandBlueTint,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.brandBlue.withValues(alpha: 0.16),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  '$count',
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                  ),
                ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                isLoading ? AppStrings.loading : label,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
