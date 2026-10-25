import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimens.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/registration.dart';
import '../cubit/registrations_list_cubit.dart';

/// Search, table/list and record actions for the records page.
class RecordsPanel extends StatefulWidget {
  const RecordsPanel({
    super.key,
    required this.onEdit,
    required this.onCreateRequested,
  });

  final ValueChanged<Registration> onEdit;
  final VoidCallback onCreateRequested;

  @override
  State<RecordsPanel> createState() => _RecordsPanelState();
}

class _RecordsPanelState extends State<RecordsPanel> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      _runSearch(value);
    });
  }

  void _onSearchSubmitted(String value) {
    _debounce?.cancel();
    _runSearch(value);
  }

  void _runSearch(String value) {
    final cubit = context.read<RegistrationsListCubit>();
    final query = value.trim();
    if (query.isEmpty) {
      cubit.loadAll();
    } else {
      cubit.search(query);
    }
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchController.clear();
    context.read<RegistrationsListCubit>().loadAll();
  }

  void _refresh() {
    context.read<RegistrationsListCubit>().refresh();
  }

  Future<void> _confirmDelete(Registration record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
              size: 26,
            ),
          ),
          title: const Text(AppStrings.deleteConfirmTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(AppStrings.deleteConfirmBody),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    _RecordAvatar(name: record.fullName, size: 36),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(dialogContext).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            record.phone,
                            style: Theme.of(dialogContext).textTheme.bodySmall
                                ?.copyWith(color: AppColors.inkMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AppStrings.cancel),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.onError,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted || record.id == null) return;

    final ok = await context.read<RegistrationsListCubit>().remove(record.id!);
    if (!mounted) return;
    if (ok) {
      AppSnackBar.show(
        context,
        AppStrings.deleteSuccess,
        type: AppSnackType.success,
      );
    } else {
      final message =
          context.read<RegistrationsListCubit>().state.errorMessage ??
          AppStrings.deleteFailed;
      AppSnackBar.show(context, message, type: AppSnackType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationsListCubit, RegistrationsListState>(
      builder: (context, listState) {
        return Card(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardPadding = constraints.maxWidth < 620
                  ? AppSpacing.lg
                  : AppSpacing.xxl;

              return Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _RecordsToolbar(
                      searchController: _searchController,
                      listState: listState,
                      onSearchChanged: _onSearchChanged,
                      onSearchSubmitted: _onSearchSubmitted,
                      onClearSearch: _clearSearch,
                      onRefresh: _refresh,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildContent(context, listState),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, RegistrationsListState listState) {
    if (listState.status == ListStatus.initial ||
        listState.status == ListStatus.loading) {
      return const _RecordsLoading();
    }

    if (listState.status == ListStatus.error) {
      return _RecordsMessage(
        icon: Icons.storage_outlined,
        iconColor: AppColors.error,
        iconBackground: AppColors.errorContainer,
        title: AppStrings.errorOccurred,
        message: listState.errorMessage ?? AppStrings.errorOccurred,
        action: OutlinedButton.icon(
          onPressed: _refresh,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text(AppStrings.retry),
        ),
      );
    }

    if (listState.items.isEmpty) {
      if (listState.query.trim().isNotEmpty) {
        return _RecordsMessage(
          icon: Icons.search_off_rounded,
          iconColor: AppColors.primary,
          iconBackground: AppColors.brandBlueSoft,
          title: AppStrings.noResultsTitle,
          message: AppStrings.noResultsBody,
          action: OutlinedButton.icon(
            onPressed: _clearSearch,
            icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
            label: const Text(AppStrings.clearSearch),
          ),
        );
      }
      return _RecordsMessage(
        brandArtwork: true,
        title: AppStrings.noRecordsTitle,
        message: AppStrings.noRecordsBody,
        action: FilledButton.icon(
          onPressed: widget.onCreateRequested,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text(AppStrings.addFirstRecord),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppSizes.tableBreakpoint) {
          return _RecordsTable(
            records: listState.items,
            onEdit: widget.onEdit,
            onDelete: _confirmDelete,
          );
        }
        return _RecordsList(
          records: listState.items,
          onEdit: widget.onEdit,
          onDelete: _confirmDelete,
        );
      },
    );
  }
}

class _RecordsToolbar extends StatelessWidget {
  const _RecordsToolbar({
    required this.searchController,
    required this.listState,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    required this.onRefresh,
  });

  final TextEditingController searchController;
  final RegistrationsListState listState;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onClearSearch;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final searchField = ValueListenableBuilder<TextEditingValue>(
          valueListenable: searchController,
          builder: (context, value, _) {
            return TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                fillColor: AppColors.surfaceMuted,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: value.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: AppStrings.clearSearch,
                        onPressed: onClearSearch,
                        icon: const Icon(Icons.close_rounded, size: 18),
                      ),
              ),
            );
          },
        );

        final refreshButton = IconButton(
          tooltip: AppStrings.refresh,
          onPressed: listState.status == ListStatus.loading ? null : onRefresh,
          icon: const Icon(Icons.refresh_rounded),
        );

        if (constraints.maxWidth >= 520) {
          return Row(
            children: [
              Expanded(child: searchField),
              const SizedBox(width: AppSpacing.sm),
              refreshButton,
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchField,
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: refreshButton,
            ),
          ],
        );
      },
    );
  }
}

class _RecordsTable extends StatelessWidget {
  const _RecordsTable({
    required this.records,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Registration> records;
  final ValueChanged<Registration> onEdit;
  final ValueChanged<Registration> onDelete;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: AppColors.inkMuted,
      fontWeight: FontWeight.w700,
      fontSize: 11.5,
      height: 1.35,
    );
    final cellStyle = Theme.of(context).textTheme.bodySmall
        ?.copyWith(fontSize: 12.5, color: AppColors.ink, height: 1.4);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.surface,
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.6),
          1: FlexColumnWidth(1.15),
          2: FlexColumnWidth(0.9),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1.15),
          5: FlexColumnWidth(0.8),
          6: FixedColumnWidth(86),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: const TableBorder(
          horizontalInside: BorderSide(color: AppColors.border),
        ),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: AppColors.brandBlueTint),
            children: [
              _headerCell(AppStrings.fullName, headerStyle),
              _headerCell(AppStrings.phone, headerStyle),
              _headerCell(AppStrings.governorate, headerStyle),
              _headerCell(AppStrings.district, headerStyle, maxLines: 2),
              _headerCell(AppStrings.villageStreet, headerStyle, maxLines: 2),
              _headerCell(AppStrings.businessType, headerStyle, maxLines: 2),
              _headerCell(AppStrings.actions, headerStyle, centered: true),
            ],
          ),
          for (var index = 0; index < records.length; index++)
            _recordRow(context, records[index], index, cellStyle),
        ],
      ),
    );
  }

  Widget _headerCell(
    String label,
    TextStyle? style, {
    int maxLines = 1,
    bool centered = false,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        alignment: centered
            ? AlignmentDirectional.center
            : AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.md,
        ),
        child: Semantics(
          header: true,
          child: Text(
            label,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ),
    );
  }

  TableRow _recordRow(
    BuildContext context,
    Registration record,
    int index,
    TextStyle? cellStyle,
  ) {
    final cellPadding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.xs,
      vertical: AppSpacing.md,
    );

    Widget cell(Widget child, {bool centered = false}) {
      return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Container(
          alignment: centered
              ? AlignmentDirectional.center
              : AlignmentDirectional.centerStart,
          padding: cellPadding,
          child: child,
        ),
      );
    }

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven ? AppColors.surface : AppColors.surfaceMuted,
      ),
      children: [
        cell(
          Text(
            record.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: cellStyle?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        cell(
          Text(
            record.phone,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: cellStyle,
          ),
        ),
        cell(
          Text(
            record.governorate,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: cellStyle,
          ),
        ),
        cell(
          Text(
            record.district,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: cellStyle,
          ),
        ),
        cell(
          Text(
            record.villageStreet,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: cellStyle,
          ),
        ),
        cell(
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.brandGreenSoft,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              record.businessType,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onTertiaryContainer,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        cell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TableActionButton(
                tooltip: AppStrings.edit,
                color: AppColors.primary,
                icon: Icons.edit_outlined,
                onPressed: () => onEdit(record),
              ),
              const SizedBox(width: AppSpacing.xxs),
              _TableActionButton(
                tooltip: AppStrings.delete,
                color: AppColors.error,
                icon: Icons.delete_outline_rounded,
                onPressed: () => onDelete(record),
              ),
            ],
          ),
          centered: true,
        ),
      ],
    );
  }
}

class _TableActionButton extends StatelessWidget {
  const _TableActionButton({
    required this.tooltip,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      icon: Icon(icon, size: 17, color: color),
    );
  }
}

class _RecordsList extends StatelessWidget {
  const _RecordsList({
    required this.records,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Registration> records;
  final ValueChanged<Registration> onEdit;
  final ValueChanged<Registration> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < records.length; index++) ...[
          _RecordCard(
            record: records[index],
            onEdit: () => onEdit(records[index]),
            onDelete: () => onDelete(records[index]),
          ),
          if (index != records.length - 1)
            const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  final Registration record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RecordAvatar(name: record.fullName, size: 38),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      record.phone,
                      textDirection: TextDirection.ltr,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: AppStrings.edit,
                visualDensity: VisualDensity.compact,
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                tooltip: AppStrings.delete,
                visualDensity: VisualDensity.compact,
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _DetailChip(icon: Icons.map_outlined, label: record.governorate),
              _DetailChip(
                icon: Icons.location_city_outlined,
                label: record.district,
              ),
              _DetailChip(
                icon: Icons.home_outlined,
                label: record.villageStreet,
              ),
              _DetailChip(
                icon: Icons.category_outlined,
                label: record.businessType,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordAvatar extends StatelessWidget {
  const _RecordAvatar({required this.name, required this.size});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '؟' : name.trim().characters.first;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.brandBlueSoft,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(color: AppColors.primary, fontSize: size * 0.42),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.inkMuted),
          const SizedBox(width: AppSpacing.xxs),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.inkMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsLoading extends StatelessWidget {
  const _RecordsLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.huge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.loadingRecords,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}

class _RecordsMessage extends StatelessWidget {
  const _RecordsMessage({
    this.icon,
    this.iconColor,
    this.iconBackground,
    this.brandArtwork = false,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackground;
  final bool brandArtwork;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.huge,
      ),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (brandArtwork)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Image.asset(
                  'assets/branding/santa_logo.png',
                  height: 96,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.storefront_rounded,
                      size: 48,
                      color: AppColors.primary,
                    );
                  },
                ),
              )
            else
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: iconBackground ?? AppColors.brandBlueSoft,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.primary,
                  size: 27,
                ),
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 16,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.inkMuted,
                height: 1.65,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
