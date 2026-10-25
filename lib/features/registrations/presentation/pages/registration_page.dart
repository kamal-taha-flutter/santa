import 'package:flutter/material.dart';

import '../../../../app/theme/app_dimens.dart';
import '../../../../core/widgets/app_logo.dart';
import '../widgets/registration_form.dart';

/// Default home destination. The registration form owns the full workspace so
/// every field and the primary save action stay comfortable to use.
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _scrollController = ScrollController();

  void scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = width < 600
            ? AppSpacing.lg
            : width < 1100
            ? AppSpacing.xxl
            : AppSpacing.huge;
        final verticalPadding = width < 600
            ? AppSpacing.xl
            : width < 1100
            ? AppSpacing.xxxl
            : AppSpacing.huge;
        final logoSize = width < 600
            ? 76.0
            : width < 1100
            ? 88.0
            : 100.0;

        return Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            key: const PageStorageKey('registration-page-scroll'),
            controller: _scrollController,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - verticalPadding * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: AppLogo(size: logoSize)),
                  SizedBox(height: width < 600 ? AppSpacing.lg : AppSpacing.xl),
                  Text(
                    'أهلاً بكم في جناح سانتا الراعي الرسمي لـ أجري بلازا',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontSize: (width * 0.026).clamp(25.0, 40.0),
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: width < 600 ? AppSpacing.sm : AppSpacing.lg),
                  Text(
                    '.يسعدنا تسجيل بياناتكم لدينا',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: (width * 0.012).clamp(15.0, 19.0),
                    ),
                  ),
                  SizedBox(
                    height: width < 600
                        ? AppSpacing.xl
                        : width < 1100
                        ? AppSpacing.xxxl
                        : AppSpacing.huge,
                  ),
                  const RegistrationForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
