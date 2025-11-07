import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:corpfinity_employee_app/data/models/models.dart';

void main() {
  group('LocationContextHelper', () {
    test('getLabel returns correct labels', () {
      expect(LocationContextHelper.getLabel(LocationContext.home), 'Home');
      expect(LocationContextHelper.getLabel(LocationContext.office), 'Office');
      expect(LocationContextHelper.getLabel(LocationContext.gym), 'Gym');
      expect(LocationContextHelper.getLabel(LocationContext.outdoor), 'Outdoor');
    });

    test('getIcon returns IconData for all locations', () {
      expect(LocationContextHelper.getIcon(LocationContext.home), isA<IconData>());
      expect(LocationContextHelper.getIcon(LocationContext.office), isA<IconData>());
      expect(LocationContextHelper.getIcon(LocationContext.gym), isA<IconData>());
      expect(LocationContextHelper.getIcon(LocationContext.outdoor), isA<IconData>());
    });
  });

  group('EnergyLevelHelper', () {
    test('getLabel returns correct labels', () {
      expect(EnergyLevelHelper.getLabel(EnergyLevel.low), 'Low');
      expect(EnergyLevelHelper.getLabel(EnergyLevel.medium), 'Medium');
      expect(EnergyLevelHelper.getLabel(EnergyLevel.high), 'High');
    });

    test('getIcon returns IconData for all energy levels', () {
      expect(EnergyLevelHelper.getIcon(EnergyLevel.low), isA<IconData>());
      expect(EnergyLevelHelper.getIcon(EnergyLevel.medium), isA<IconData>());
      expect(EnergyLevelHelper.getIcon(EnergyLevel.high), isA<IconData>());
    });
  });

  group('WellnessGoalHelper', () {
    test('getLabel returns correct labels', () {
      expect(WellnessGoalHelper.getLabel(WellnessGoal.stressReduction), 'Stress Reduction');
      expect(WellnessGoalHelper.getLabel(WellnessGoal.increasedEnergy), 'Increased Energy');
      expect(WellnessGoalHelper.getLabel(WellnessGoal.betterSleep), 'Better Sleep');
      expect(WellnessGoalHelper.getLabel(WellnessGoal.physicalFitness), 'Physical Fitness');
      expect(WellnessGoalHelper.getLabel(WellnessGoal.healthyEating), 'Healthy Eating');
      expect(WellnessGoalHelper.getLabel(WellnessGoal.socialConnection), 'Social Connection');
    });

    test('getIcon returns IconData for all wellness goals', () {
      expect(WellnessGoalHelper.getIcon(WellnessGoal.stressReduction), isA<IconData>());
      expect(WellnessGoalHelper.getIcon(WellnessGoal.increasedEnergy), isA<IconData>());
      expect(WellnessGoalHelper.getIcon(WellnessGoal.betterSleep), isA<IconData>());
      expect(WellnessGoalHelper.getIcon(WellnessGoal.physicalFitness), isA<IconData>());
      expect(WellnessGoalHelper.getIcon(WellnessGoal.healthyEating), isA<IconData>());
      expect(WellnessGoalHelper.getIcon(WellnessGoal.socialConnection), isA<IconData>());
    });
  });

  group('LocationContext enum', () {
    test('displayName returns correct values', () {
      expect(LocationContext.home.displayName, 'Home');
      expect(LocationContext.office.displayName, 'Office');
      expect(LocationContext.gym.displayName, 'Gym');
      expect(LocationContext.outdoor.displayName, 'Outdoor');
    });
  });

  group('WellnessGoal enum', () {
    test('displayName returns correct values', () {
      expect(WellnessGoal.stressReduction.displayName, 'Stress Reduction');
      expect(WellnessGoal.increasedEnergy.displayName, 'Increased Energy');
      expect(WellnessGoal.betterSleep.displayName, 'Better Sleep');
      expect(WellnessGoal.physicalFitness.displayName, 'Physical Fitness');
      expect(WellnessGoal.healthyEating.displayName, 'Healthy Eating');
      expect(WellnessGoal.socialConnection.displayName, 'Social Connection');
    });
  });

  group('EnergyLevel enum', () {
    test('displayName returns correct values', () {
      expect(EnergyLevel.low.displayName, 'Low');
      expect(EnergyLevel.medium.displayName, 'Medium');
      expect(EnergyLevel.high.displayName, 'High');
    });
  });
}
