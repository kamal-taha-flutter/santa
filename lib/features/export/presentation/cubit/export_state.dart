part of 'export_cubit.dart';

enum ExportStatus { initial, loading, success, cancelled, error }

class ExportState extends Equatable {
  const ExportState({required this.status, this.message, this.exportedPath});

  const ExportState.initial() : this(status: ExportStatus.initial);

  final ExportStatus status;
  final String? message;
  final String? exportedPath;

  ExportState copyWith({
    ExportStatus? status,
    String? message,
    String? exportedPath,
  }) {
    return ExportState(
      status: status ?? this.status,
      message: message,
      exportedPath: exportedPath ?? this.exportedPath,
    );
  }

  @override
  List<Object?> get props => [status, message, exportedPath];
}
