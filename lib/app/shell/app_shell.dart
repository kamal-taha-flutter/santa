import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_strings.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_snack_bar.dart';
import '../../features/export/presentation/pages/export_page.dart';
import '../../features/registrations/domain/entities/registration.dart';
import '../../features/registrations/presentation/cubit/registration_form_cubit.dart';
import '../../features/registrations/presentation/cubit/registrations_list_cubit.dart';
import '../../features/registrations/presentation/pages/records_page.dart';
import '../../features/registrations/presentation/pages/registration_page.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

enum AppDestination { registration, records, export }

extension AppDestinationInfo on AppDestination {
  String get label => switch (this) {
    AppDestination.registration => AppStrings.navNewRegistration,
    AppDestination.records => AppStrings.navRecords,
    AppDestination.export => AppStrings.navExport,
  };

  IconData get icon => switch (this) {
    AppDestination.registration => Icons.person_add_alt_1_rounded,
    AppDestination.records => Icons.table_rows_rounded,
    AppDestination.export => Icons.file_download_outlined,
  };
}

/// Persistent RTL application shell.
///
/// Pages live in an [IndexedStack] so switching destinations does not rebuild
/// or lose the state of the registration form, records search, or export page.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _registrationPageKey = GlobalKey<RegistrationPageState>();
  AppDestination _destination = AppDestination.registration;

  @override
  void initState() {
    super.initState();
    context.read<RegistrationsListCubit>().loadAll();
  }

  void _selectDestination(AppDestination destination) {
    if (_destination == destination) return;
    setState(() => _destination = destination);
  }

  void _scrollRegistrationToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _registrationPageKey.currentState?.scrollToTop();
    });
  }

  void _startNewRegistration() {
    context.read<RegistrationFormCubit>().reset();
    _selectDestination(AppDestination.registration);
    _scrollRegistrationToTop();
  }

  void _editRecord(Registration record) {
    context.read<RegistrationFormCubit>().loadForEdit(record);
    _selectDestination(AppDestination.registration);
    _scrollRegistrationToTop();
    AppSnackBar.show(context, AppStrings.editLoaded);
  }

  Widget _buildPages() {
    return IndexedStack(
      index: _destination.index,
      children: [
        RegistrationPage(key: _registrationPageKey),
        RecordsPage(
          onEdit: _editRecord,
          onCreateRequested: _startNewRegistration,
        ),
        const ExportPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final drawerWidth = screenWidth <= 320
        ? screenWidth * 0.9
        : (screenWidth * 0.82).clamp(280.0, 400.0).toDouble();

    return _AgriculturalBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: Builder(
            builder: (context) => IconButton(
              tooltip: 'فتح قائمة التنقل',
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const AppLogo(size: 40),
          actions: const [
            Padding(
              padding: EdgeInsetsDirectional.only(end: AppSpacing.lg),
              child: _CompactCountChip(),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(3),
            child: _BrandAccent(),
          ),
        ),
        drawer: Drawer(
          width: drawerWidth,
          child: _NavigationSidebar(
            destination: _destination,
            onDestinationSelected: _selectDestination,
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(child: _buildPages()),
      ),
    );
  }
}

class _AgriculturalBackground extends StatelessWidget {
  const _AgriculturalBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _AgriculturalBackgroundPainter(), child: child);
  }
}

class _AgriculturalBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final gradient = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF35583A), Color(0xFF4B7045), Color(0xFF3D623E)],
      ).createShader(bounds);
    canvas.drawRect(bounds, gradient);

    final leafAnchors = [
      (0.04, 0.12, 0.11, -0.65),
      (0.19, 0.07, 0.075, 0.45),
      (0.39, 0.13, 0.06, -0.25),
      (0.73, 0.08, 0.085, 0.7),
      (0.95, 0.16, 0.12, 0.5),
      (0.08, 0.36, 0.07, 0.2),
      (0.91, 0.43, 0.08, -0.6),
      (0.03, 0.64, 0.105, -0.35),
      (0.96, 0.7, 0.11, 0.5),
      (0.2, 0.91, 0.08, -0.7),
      (0.48, 0.95, 0.07, 0.2),
      (0.78, 0.9, 0.1, -0.4),
    ];
    final unit = size.shortestSide;

    for (var index = 0; index < leafAnchors.length; index++) {
      final (x, y, scale, rotation) = leafAnchors[index];
      _drawLeaf(
        canvas,
        Offset(size.width * x, size.height * y),
        unit * scale,
        rotation,
        index.isEven
            ? const Color(0xFFDAE9B8).withValues(alpha: 0.14)
            : const Color(0xFFC2D99A).withValues(alpha: 0.11),
      );
    }
  }

  void _drawLeaf(
    Canvas canvas,
    Offset center,
    double length,
    double rotation,
    Color color,
  ) {
    final leaf = Path()
      ..moveTo(0, -length / 2)
      ..cubicTo(
        length * 0.42,
        -length * 0.24,
        length * 0.42,
        length * 0.2,
        0,
        length / 2,
      )
      ..cubicTo(
        -length * 0.42,
        length * 0.2,
        -length * 0.42,
        -length * 0.24,
        0,
        -length / 2,
      )
      ..close();
    final shadowPaint = Paint()
      ..color = const Color(0xFF193A25).withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    final leafPaint = Paint()..color = color;
    final veinPaint = Paint()
      ..color = const Color(0xFFEBF2D7).withValues(alpha: 0.16)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final vein = Path()
      ..moveTo(0, -length * 0.42)
      ..lineTo(0, length * 0.42);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.drawShadow(leaf, const Color(0xFF193A25), 7, true);
    canvas.drawPath(leaf, shadowPaint);
    canvas.drawPath(leaf, leafPaint);
    canvas.drawPath(vein, veinPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AgriculturalBackgroundPainter oldDelegate) =>
      false;
}

class _NavigationSidebar extends StatelessWidget {
  const _NavigationSidebar({
    required this.destination,
    required this.onDestinationSelected,
  });

  final AppDestination destination;
  final ValueChanged<AppDestination> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _BrandAccent(),
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: _BrandBlock(),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      AppSpacing.sm,
                      0,
                      AppSpacing.sm,
                      AppSpacing.sm,
                    ),
                    child: Text(
                      AppStrings.navigation,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.inkSubtle,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  for (final item in AppDestination.values)
                    _SidebarDestination(
                      destination: item,
                      selected: destination == item,
                      onTap: () {
                        Navigator.of(context).pop();
                        onDestinationSelected(item);
                      },
                    ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: _TotalRecordsCard(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Text(
              AppStrings.appDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.inkSubtle,
                fontSize: 10.5,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppLogo(size: 48),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.appName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: AppColors.ink, fontSize: 19),
              ),
              const SizedBox(height: 2),
              Text(
                AppStrings.appTagline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.secondaryDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 8.5,
                  letterSpacing: 0.9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarDestination extends StatelessWidget {
  const _SidebarDestination({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final AppDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.primary : AppColors.inkMuted;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: selected ? AppColors.brandBlueSoft : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(
            color: selected
                ? AppColors.brandBlue.withValues(alpha: 0.16)
                : Colors.transparent,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          hoverColor: AppColors.brandBlueTint,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 12,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 3,
                  height: 22,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Icon(destination.icon, size: 20, color: foreground),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ),
                if (destination == AppDestination.records)
                  const _RecordsNavBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordsNavBadge extends StatelessWidget {
  const _RecordsNavBadge();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationsListCubit, RegistrationsListState>(
      builder: (context, state) {
        final isLoading =
            state.status == ListStatus.initial ||
            state.status == ListStatus.loading;
        if (isLoading) {
          return const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: 1,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '${state.totalCount}',
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: AppColors.inkMuted, fontSize: 10.5),
          ),
        );
      },
    );
  }
}

class _TotalRecordsCard extends StatelessWidget {
  const _TotalRecordsCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationsListCubit, RegistrationsListState>(
      builder: (context, state) {
        final isLoading =
            state.status == ListStatus.initial ||
            state.status == ListStatus.loading;
        final textTheme = Theme.of(context).textTheme;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.brandGreenSoft,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.brandGreen.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 19,
                  color: AppColors.brandGreenDark,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.totalRecords,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.brandGreenDark,
                        fontSize: 10.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (isLoading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.brandGreenDark,
                        ),
                      )
                    else
                      Text(
                        '${state.totalCount}',
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.brandGreenDark,
                          fontSize: 16,
                          height: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CompactCountChip extends StatelessWidget {
  const _CompactCountChip();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationsListCubit, RegistrationsListState>(
      builder: (context, state) {
        final isLoading =
            state.status == ListStatus.initial ||
            state.status == ListStatus.loading;
        return Container(
          constraints: const BoxConstraints(minHeight: 38),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.brandGreenSoft,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: AppColors.brandGreen.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.assignment_turned_in_outlined,
                size: 16,
                color: AppColors.brandGreenDark,
              ),
              const SizedBox(width: AppSpacing.xs),
              if (isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.brandGreenDark,
                  ),
                )
              else
                Text(
                  '${state.totalCount}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.brandGreenDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BrandAccent extends StatelessWidget {
  const _BrandAccent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            flex: 6,
            child: ColoredBox(color: AppColors.brandBlue),
          ),
          const Expanded(
            flex: 3,
            child: ColoredBox(color: AppColors.brandOrange),
          ),
          Expanded(flex: 2, child: ColoredBox(color: AppColors.brandGreen)),
        ],
      ),
    );
  }
}
