import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/export_all_registrations.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  ExportCubit(this.exportAllRegistrations) : super(const ExportState.initial());

  final ExportAllRegistrations exportAllRegistrations;

  Future<void> exportAll() async {
    if (state.status == ExportStatus.loading) return;

    emit(state.copyWith(status: ExportStatus.loading, message: null));
    final result = await exportAllRegistrations();
    final failure = result.$1;
    final path = result.$2;

    if (failure != null) {
      emit(
        state.copyWith(status: ExportStatus.error, message: failure.message),
      );
      return;
    }
    if (path == null) {
      emit(state.copyWith(status: ExportStatus.cancelled, message: null));
      return;
    }
    emit(
      state.copyWith(
        status: ExportStatus.success,
        message: 'تم تصدير الملف بنجاح: $path',
        exportedPath: path,
      ),
    );
  }

  void reset() {
    emit(const ExportState.initial());
  }
}
