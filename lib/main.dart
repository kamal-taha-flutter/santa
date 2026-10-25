import 'package:flutter/material.dart';

import 'app/bootstrap.dart';

void main() async {
  final app = await AppBootstrap.create();
  runApp(app);
}
