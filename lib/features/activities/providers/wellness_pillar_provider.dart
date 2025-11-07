import 'package:flutter/foundation.dart';
import '../../../data/models/wellness_pillar.dart';

/// WellnessPillarProvider manages wellness pillar data and selection state
class WellnessPillarProvider extends ChangeNotifier {
  List<WellnessPillar> _pillars = [];
  String? _selectedPillarId;
  bool _isLoading = false;
  String? _error;

  List<WellnessPillar> get pillars => _pillars;
  String? get selectedPillarId => _selectedPillarId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load wellness pillars (currently using mock data)
  Future<void> loadPillars() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual repository call when backend is integrated
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - 6 wellness pillars
      _pillars = [
        const WellnessPillar(
          id: 'stress-reduction',
          name: 'Stress Reduction',
          description: 'Calm your mind and reduce tension',
          iconPath: 'assets/icons/stress.png',
          availableActivities: 8,
        ),
        const WellnessPillar(
          id: 'increased-energy',
          name: 'Increased Energy',
          description: 'Boost your vitality and alertness',
          iconPath: 'assets/icons/energy.png',
          availableActivities: 6,
        ),
        const WellnessPillar(
          id: 'better-sleep',
          name: 'Better Sleep',
          description: 'Improve your sleep quality',
          iconPath: 'assets/icons/sleep.png',
          availableActivities: 5,
        ),
        const WellnessPillar(
          id: 'physical-fitness',
          name: 'Physical Fitness',
          description: 'Strengthen your body and flexibility',
          iconPath: 'assets/icons/fitness.png',
          availableActivities: 10,
        ),
        const WellnessPillar(
          id: 'healthy-eating',
          name: 'Healthy Eating',
          description: 'Nourish your body with good habits',
          iconPath: 'assets/icons/eating.png',
          availableActivities: 7,
        ),
        const WellnessPillar(
          id: 'social-connection',
          name: 'Social Connection',
          description: 'Build meaningful relationships',
          iconPath: 'assets/icons/social.png',
          availableActivities: 4,
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Get a specific pillar by ID
  WellnessPillar? getPillarById(String id) {
    try {
      return _pillars.firstWhere((pillar) => pillar.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Select a wellness pillar
  void selectPillar(String pillarId) {
    _selectedPillarId = pillarId;
    notifyListeners();
  }

  /// Clear pillar selection
  void clearSelection() {
    _selectedPillarId = null;
    notifyListeners();
  }

  /// Get selected pillar object
  WellnessPillar? getSelectedPillar() {
    if (_selectedPillarId == null) return null;
    return getPillarById(_selectedPillarId!);
  }

  /// Filter pillars by search query
  List<WellnessPillar> searchPillars(String query) {
    if (query.isEmpty) return _pillars;
    
    final lowerQuery = query.toLowerCase();
    return _pillars.where((pillar) {
      return pillar.name.toLowerCase().contains(lowerQuery) ||
          pillar.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Refresh pillar data
  Future<void> refresh() async {
    await loadPillars();
  }
}
