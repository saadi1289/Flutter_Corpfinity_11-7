import 'package:flutter/foundation.dart';
import 'package:corpfinity_employee_app/data/models/enums.dart';
import 'package:corpfinity_employee_app/features/challenges/utils/challenge_generator.dart';

/// State class for the challenge creation flow
class ChallengeFlowState {
  final int currentStep;
  final EnergyLevel? selectedEnergy;
  final LocationContext? selectedLocation;
  final WellnessGoal? selectedGoal;
  final String? generatedChallenge;

  const ChallengeFlowState({
    this.currentStep = 0,
    this.selectedEnergy,
    this.selectedLocation,
    this.selectedGoal,
    this.generatedChallenge,
  });

  ChallengeFlowState copyWith({
    int? currentStep,
    EnergyLevel? selectedEnergy,
    LocationContext? selectedLocation,
    WellnessGoal? selectedGoal,
    String? generatedChallenge,
  }) {
    return ChallengeFlowState(
      currentStep: currentStep ?? this.currentStep,
      selectedEnergy: selectedEnergy ?? this.selectedEnergy,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      selectedGoal: selectedGoal ?? this.selectedGoal,
      generatedChallenge: generatedChallenge ?? this.generatedChallenge,
    );
  }
}

/// Provider for managing challenge creation flow state
class ChallengeFlowProvider extends ChangeNotifier {
  ChallengeFlowState _state = const ChallengeFlowState();

  ChallengeFlowState get state => _state;

  int get currentStep => _state.currentStep;
  EnergyLevel? get selectedEnergy => _state.selectedEnergy;
  LocationContext? get selectedLocation => _state.selectedLocation;
  WellnessGoal? get selectedGoal => _state.selectedGoal;
  String? get generatedChallenge => _state.generatedChallenge;

  /// Select energy level and update state
  void selectEnergy(EnergyLevel energy) {
    _state = _state.copyWith(selectedEnergy: energy);
    notifyListeners();
  }

  /// Select location context and update state
  void selectLocation(LocationContext location) {
    _state = _state.copyWith(selectedLocation: location);
    notifyListeners();
  }

  /// Select wellness goal and update state
  void selectGoal(WellnessGoal goal) {
    _state = _state.copyWith(selectedGoal: goal);
    notifyListeners();
  }

  /// Generate challenge based on selected inputs
  /// Uses ChallengeGenerator utility class with static placeholder logic
  /// Future: Will be enhanced with AI-powered generation
  void generateChallenge() {
    if (_state.selectedEnergy == null ||
        _state.selectedLocation == null ||
        _state.selectedGoal == null) {
      return;
    }

    // Use the ChallengeGenerator utility class
    final challenge = ChallengeGenerator.generateChallenge(
      energy: _state.selectedEnergy!,
      location: _state.selectedLocation!,
      goal: _state.selectedGoal!,
    );

    _state = _state.copyWith(generatedChallenge: challenge);
    notifyListeners();
  }

  /// Fetch challenge from the database (simulated)
  /// For now, we return a static challenge text for all selections.
  /// In the future, replace this with an actual repository/service call.
  Future<void> fetchChallengeFromDb() async {
    if (_state.selectedEnergy == null ||
        _state.selectedLocation == null ||
        _state.selectedGoal == null) {
      return;
    }

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));

    const staticChallenge =
        'Take a 10-minute mindful break today.\n\n• Find a quiet spot (desk or outdoors).\n• Breathe slowly for 2 minutes.\n• Stretch your neck, shoulders, and back.\n• Write one thing you’re grateful for.';

    _state = _state.copyWith(generatedChallenge: staticChallenge);
    notifyListeners();
  }

  /// Reset the flow to initial state
  void resetFlow() {
    _state = const ChallengeFlowState();
    notifyListeners();
  }

  /// Move to the next step in the flow
  void goToNextStep() {
    if (_state.currentStep < 2) {
      _state = _state.copyWith(currentStep: _state.currentStep + 1);
      notifyListeners();
    }
  }

  /// Move to the previous step in the flow
  void goToPreviousStep() {
    if (_state.currentStep > 0) {
      _state = _state.copyWith(currentStep: _state.currentStep - 1);
      notifyListeners();
    }
  }
}
