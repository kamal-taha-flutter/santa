import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/registration.dart';
import '../../domain/usecases/count_registrations.dart';
import '../../domain/usecases/delete_registration.dart';
import '../../domain/usecases/get_all_registrations.dart';
import '../../domain/usecases/search_registrations.dart';

part 'registrations_list_state.dart';

class RegistrationsListCubit extends Cubit<RegistrationsListState> {
  RegistrationsListCubit({
    required this.getAllRegistrations,
    required this.countRegistrations,
    required this.searchRegistrations,
    required this.deleteRegistration,
  }) : super(const RegistrationsListState.initial());

  final GetAllRegistrations getAllRegistrations;
  final CountRegistrations countRegistrations;
  final SearchRegistrations searchRegistrations;
  final DeleteRegistration deleteRegistration;

  Future<void> loadAll() async {
    emit(
      state.copyWith(status: ListStatus.loading, query: '', errorMessage: null),
    );
    final result = await getAllRegistrations();
    final failure = result.$1;
    final list = result.$2;
    if (failure != null) {
      emit(
        state.copyWith(
          status: ListStatus.error,
          errorMessage: failure.message,
          items: const [],
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: ListStatus.loaded,
        items: list,
        totalCount: list.length,
        errorMessage: null,
      ),
    );
  }

  /// Reloads the current view, preserving an active search query.
  Future<void> refresh() {
    final query = state.query.trim();
    return query.isEmpty ? loadAll() : search(query);
  }

  Future<void> search(String query) async {
    emit(
      state.copyWith(
        status: ListStatus.loading,
        query: query,
        errorMessage: null,
      ),
    );
    final result = await searchRegistrations(query);
    final countResult = await countRegistrations();
    final failure = result.$1;
    final list = result.$2;
    final countFailure = countResult.$1;
    final totalCount = countFailure == null ? countResult.$2 : state.totalCount;
    if (failure != null) {
      emit(
        state.copyWith(
          status: ListStatus.error,
          errorMessage: failure.message,
          items: const [],
          totalCount: totalCount,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: ListStatus.loaded,
        items: list,
        totalCount: totalCount,
        errorMessage: null,
      ),
    );
  }

  Future<bool> remove(int id) async {
    final result = await deleteRegistration(id);
    final failure = result.$1;
    final success = result.$2;
    if (failure != null || success != true) {
      emit(state.copyWith(errorMessage: failure?.message));
      return false;
    }
    await refresh();
    return true;
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
