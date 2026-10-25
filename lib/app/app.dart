import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

class SantaApp extends StatelessWidget {
  const SantaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final injection = AppInjection.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: injection.formCubit),
        BlocProvider.value(value: injection.listCubit),
        BlocProvider.value(value: injection.exportCubit),
      ],
      child: MaterialApp(
        title: 'Santa |  الأنشطة التجارية',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'),
        supportedLocales: AppTheme.supportedLocales,
        localizationsDelegates: AppTheme.localizationsDelegates,
        theme: AppTheme.light,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: const AppShell(),
      ),
    );
  }
}
