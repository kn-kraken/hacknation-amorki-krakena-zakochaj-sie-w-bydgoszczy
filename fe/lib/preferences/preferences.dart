import 'package:flutter_bloc/flutter_bloc.dart';

import '../swapper.dart';

// --- States ---
enum PreferencesStatus {
  initial,
  listDatesShouldSwipe, // means user is looking for love
  listDatesNoSwipe,
  listProfiles,
  datePage, // blank for now
  matched, // means user is looking for love
}

class PreferencesState {
  final PreferencesStatus status;
  final CardItem? matchedCard;
  final String? selectedDateId;
  final bool shouldSwipe;

  const PreferencesState({
    required this.status,
    this.matchedCard,
    this.selectedDateId,
    this.shouldSwipe = false,
  });

  factory PreferencesState.initial() {
    return const PreferencesState(status: PreferencesStatus.initial);
  }

  PreferencesState copyWith({
    PreferencesStatus? status,
    CardItem? matchedCard,
    String? selectedDateId,
    bool? shouldSwipe,
  }) {
    return PreferencesState(
      status: status ?? this.status,
      matchedCard: matchedCard,
      selectedDateId: selectedDateId ?? this.selectedDateId,
      shouldSwipe: shouldSwipe ?? this.shouldSwipe,
    );
  }
}

// --- Cubit ---
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit() : super(PreferencesState.initial());

  // User selects "YES" on the initial page
  void startPreferencesFlow() {
    emit(
      state.copyWith(
        status: PreferencesStatus.listDatesShouldSwipe,
        shouldSwipe: true,
      ),
    );
  }

  // User selects "NO" on the initial page
  void startPreferencesNoSwipe() {
    emit(
      state.copyWith(
        status: PreferencesStatus.listDatesShouldSwipe,
        shouldSwipe: false,
      ),
    );
  }

  // User selects a date from the list
  void selectDate(String dateId) {
    if (state.shouldSwipe) {
      emit(
        state.copyWith(
          status:
              PreferencesStatus.listProfiles, // Directly goes to Swiping Screen
          selectedDateId: dateId,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: PreferencesStatus.datePage,
          selectedDateId: dateId,
        ),
      );
    }
  }

  // User goes back
  void goBack() {
    switch (state.status) {
      case PreferencesStatus.listProfiles:
      case PreferencesStatus.datePage:
        if (state.shouldSwipe) {
          emit(
            state.copyWith(
              status: PreferencesStatus.listDatesShouldSwipe,
              selectedDateId: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: PreferencesStatus.listDatesNoSwipe,
              selectedDateId: null,
            ),
          );
        }
        break;
      case PreferencesStatus.listDatesShouldSwipe:
      case PreferencesStatus.listDatesNoSwipe:
        emit(
          state.copyWith(
            status: PreferencesStatus.initial,
            selectedDateId: null,
            shouldSwipe: false,
          ),
        );
        break;
      case PreferencesStatus.matched:
        emit(state.copyWith(status: PreferencesStatus.listProfiles));
        break;
      case PreferencesStatus.initial:
        break;
    }
  }
}
