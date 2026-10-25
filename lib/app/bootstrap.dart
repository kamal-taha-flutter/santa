import 'dart:async';

import 'package:flutter/material.dart';

import '../features/registrations/data/datasources/registration_local_data_source.dart';
import 'app.dart';
import '../injection.dart';

class AppBootstrap {
  static Future<Widget> create() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize database once at startup
    await RegistrationLocalDataSource.instance.database;
    return AppCompositionRoot.create(child: const SantaApp());
  }
}
