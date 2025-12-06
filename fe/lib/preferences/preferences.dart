import 'package:flutter_bloc/flutter_bloc.dart';

// --- States ---
enum PreferencesStatus {
  initial,
  listDates,
  listProfiles,
}

class PreferencesState {
  final PreferencesStatus status;
  final String? selectedDateId;

  const PreferencesState({
    required this.status,
    this.selectedDateId,
  });

  factory PreferencesState.initial() {
    return const PreferencesState(status: PreferencesStatus.initial);
  }

  PreferencesState copyWith({
    PreferencesStatus? status,
    String? selectedDateId,
  }) {
    return PreferencesState(
      status: status ?? this.status,
      selectedDateId: selectedDateId ?? this.selectedDateId,
    );
  }
}

// --- Cubit ---
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit() : super(PreferencesState.initial());

  // User selects "YES" on the initial page
  void startPreferencesFlow() {
    emit(state.copyWith(status: PreferencesStatus.listDates));
  }

  // User selects a date from the list
  void selectDate(String dateId) {
    emit(state.copyWith(
      status: PreferencesStatus.listProfiles, // Directly goes to Swiping Screen
      selectedDateId: dateId,
    ));
  }
}