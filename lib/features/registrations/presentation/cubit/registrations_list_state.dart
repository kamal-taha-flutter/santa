part of 'registrations_list_cubit.dart';

enum ListStatus { initial, loading, loaded, error }

class RegistrationsListState extends Equatable {
  const RegistrationsListState({
    required this.status,
    required this.items,
    this.totalCount = 0,
    this.query = '',
    this.errorMessage,
  });

  const RegistrationsListState.initial()
    : this(status: ListStatus.initial, items: const []);

  final ListStatus status;
  final List<Registration> items;

  /// Number of records stored in the database, independent of any search.
  final int totalCount;
  final String query;
  final String? errorMessage;

  RegistrationsListState copyWith({
    ListStatus? status,
    List<Registration>? items,
    int? totalCount,
    String? query,
    String? errorMessage,
  }) {
    return RegistrationsListState(
      status: status ?? this.status,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, totalCount, query, errorMessage];
}
