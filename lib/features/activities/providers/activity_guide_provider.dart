import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../data/models/activity.dart';
import '../../../data/models/activity_step.dart';

/// ActivityGuideProvider manages the state of an activity being performed
/// including step progression, timer state, and completion tracking
class ActivityGuideProvider extends ChangeNotifier {
  Activity? _currentActivity;
  int _currentStepIndex = 0;
  bool _isTimerRunning = false;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isCompleted = false;

  Activity? get currentActivity => _currentActivity;
  int get currentStepIndex => _currentStepIndex;
  bool get isTimerRunning => _isTimerRunning;
  int get remainingSeconds => _remainingSeconds;
  bool get isCompleted => _isCompleted;

  /// Get the current step
  ActivityStep? get currentStep {
    if (_currentActivity == null || 
        _currentStepIndex >= _currentActivity!.steps.length) {
      return null;
    }
    return _currentActivity!.steps[_currentStepIndex];
  }

  /// Check if there are more steps
  bool get hasNextStep {
    if (_currentActivity == null) return false;
    return _currentStepIndex < _currentActivity!.steps.length - 1;
  }

  /// Get progress as a percentage (0.0 to 1.0)
  double get progress {
    if (_currentActivity == null || _currentActivity!.steps.isEmpty) {
      return 0.0;
    }
    return (_currentStepIndex + 1) / _currentActivity!.steps.length;
  }

  /// Start an activity
  void startActivity(Activity activity) {
    _currentActivity = activity;
    _currentStepIndex = 0;
    _isCompleted = false;
    _stopTimer();
    
    // Auto-start timer if first step has a timer
    final firstStep = activity.steps.isNotEmpty ? activity.steps[0] : null;
    if (firstStep?.timerSeconds != null) {
      startTimer(firstStep!.timerSeconds!);
    }
    
    notifyListeners();
  }

  /// Move to the next step
  void nextStep() {
    if (!hasNextStep) {
      completeActivity();
      return;
    }

    _stopTimer();
    _currentStepIndex++;
    
    // Auto-start timer if next step has a timer
    final nextStep = currentStep;
    if (nextStep?.timerSeconds != null) {
      startTimer(nextStep!.timerSeconds!);
    }
    
    notifyListeners();
  }

  /// Move to the previous step
  void previousStep() {
    if (_currentStepIndex > 0) {
      _stopTimer();
      _currentStepIndex--;
      
      // Auto-start timer if previous step has a timer
      final prevStep = currentStep;
      if (prevStep?.timerSeconds != null) {
        startTimer(prevStep!.timerSeconds!);
      }
      
      notifyListeners();
    }
  }

  /// Start the timer for the current step
  void startTimer(int seconds) {
    _stopTimer();
    _remainingSeconds = seconds;
    _isTimerRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _stopTimer();
        // Auto-advance to next step when timer completes
        if (hasNextStep) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_isTimerRunning == false && !_isCompleted) {
              nextStep();
            }
          });
        } else {
          completeActivity();
        }
      }
    });
  }

  /// Pause the timer
  void pauseTimer() {
    if (_isTimerRunning) {
      _isTimerRunning = false;
      _timer?.cancel();
      _timer = null;
      notifyListeners();
    }
  }

  /// Resume the timer
  void resumeTimer() {
    if (!_isTimerRunning && _remainingSeconds > 0) {
      _isTimerRunning = true;
      notifyListeners();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          notifyListeners();
        } else {
          _stopTimer();
        }
      });
    }
  }

  /// Stop the timer
  void _stopTimer() {
    _isTimerRunning = false;
    _remainingSeconds = 0;
    _timer?.cancel();
    _timer = null;
  }

  /// Mark the activity as completed
  void completeActivity() {
    _stopTimer();
    _isCompleted = true;
    notifyListeners();
    
    // Record activity completion
    // This will be integrated with the backend/repository later
    _recordActivityCompletion();
  }

  /// Record activity completion (placeholder for backend integration)
  Future<void> _recordActivityCompletion() async {
    if (_currentActivity == null) return;
    
    // TODO: Integrate with repository to record completion
    // For now, this is a placeholder that simulates the recording
    await Future.delayed(const Duration(milliseconds: 100));
    
    debugPrint('Activity completed: ${_currentActivity!.name}');
  }

  /// Reset the provider state
  void reset() {
    _stopTimer();
    _currentActivity = null;
    _currentStepIndex = 0;
    _isCompleted = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
