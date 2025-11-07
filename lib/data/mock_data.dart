import 'models/activity.dart';
import 'models/activity_step.dart';
import 'models/badge.dart';
import 'models/enums.dart';
import 'models/notification_preferences.dart';
import 'models/user.dart';
import 'models/wellness_pillar.dart';

/// Mock data for development and testing
class MockData {
  // Wellness Pillar IDs
  static const String pillarStressReduction = 'stress-reduction';
  static const String pillarIncreasedEnergy = 'increased-energy';
  static const String pillarBetterSleep = 'better-sleep';
  static const String pillarPhysicalFitness = 'physical-fitness';
  static const String pillarHealthyEating = 'healthy-eating';
  static const String pillarSocialConnection = 'social-connection';

  /// Mock wellness pillars (6 pillars)
  static final List<WellnessPillar> wellnessPillars = [
    const WellnessPillar(
      id: pillarStressReduction,
      name: 'Stress Reduction',
      description: 'Calm your mind and reduce workplace stress',
      iconPath: 'assets/icons/stress_reduction.png',
      availableActivities: 4,
    ),
    const WellnessPillar(
      id: pillarIncreasedEnergy,
      name: 'Increased Energy',
      description: 'Boost your energy levels throughout the day',
      iconPath: 'assets/icons/increased_energy.png',
      availableActivities: 3,
    ),
    const WellnessPillar(
      id: pillarBetterSleep,
      name: 'Better Sleep',
      description: 'Improve sleep quality and nighttime routines',
      iconPath: 'assets/icons/better_sleep.png',
      availableActivities: 3,
    ),
    const WellnessPillar(
      id: pillarPhysicalFitness,
      name: 'Physical Fitness',
      description: 'Stay active with quick desk exercises',
      iconPath: 'assets/icons/physical_fitness.png',
      availableActivities: 4,
    ),
    const WellnessPillar(
      id: pillarHealthyEating,
      name: 'Healthy Eating',
      description: 'Make better nutrition choices at work',
      iconPath: 'assets/icons/healthy_eating.png',
      availableActivities: 3,
    ),
    const WellnessPillar(
      id: pillarSocialConnection,
      name: 'Social Connection',
      description: 'Build meaningful workplace relationships',
      iconPath: 'assets/icons/social_connection.png',
      availableActivities: 3,
    ),
  ];

  /// Mock activities (20 activities across all pillars)
  static final List<Activity> activities = [
    // Stress Reduction Activities (4)
    Activity(
      id: 'activity-001',
      name: 'Deep Breathing Exercise',
      description: 'A simple breathing technique to calm your nervous system',
      pillarId: pillarStressReduction,
      durationMinutes: 3,
      difficulty: Difficulty.low,
      location: 'At Desk',
      thumbnailUrl: 'assets/images/deep_breathing.jpg',
      tags: ['breathing', 'relaxation', 'quick'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Get Comfortable',
          instruction: 'Sit upright in your chair with feet flat on the floor. Place your hands on your lap.',
          imageUrl: 'assets/images/sitting_posture.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Inhale Deeply',
          instruction: 'Breathe in slowly through your nose for 4 counts. Feel your belly expand.',
          imageUrl: 'assets/images/inhale.jpg',
          timerSeconds: 4,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Hold',
          instruction: 'Hold your breath gently for 4 counts.',
          imageUrl: 'assets/images/hold_breath.jpg',
          timerSeconds: 4,
        ),
        const ActivityStep(
          stepNumber: 4,
          title: 'Exhale Slowly',
          instruction: 'Breathe out slowly through your mouth for 6 counts.',
          imageUrl: 'assets/images/exhale.jpg',
          timerSeconds: 6,
        ),
        const ActivityStep(
          stepNumber: 5,
          title: 'Repeat',
          instruction: 'Repeat this cycle 5 more times. Notice how you feel calmer with each breath.',
          imageUrl: 'assets/images/breathing_cycle.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-002',
      name: 'Progressive Muscle Relaxation',
      description: 'Release tension by systematically tensing and relaxing muscle groups',
      pillarId: pillarStressReduction,
      durationMinutes: 5,
      difficulty: Difficulty.low,
      location: 'At Desk',
      thumbnailUrl: 'assets/images/muscle_relaxation.jpg',
      tags: ['tension', 'relaxation', 'body'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Prepare',
          instruction: 'Sit comfortably and close your eyes. Take three deep breaths.',
          imageUrl: 'assets/images/eyes_closed.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Tense Hands',
          instruction: 'Make tight fists with both hands. Hold for 5 seconds.',
          imageUrl: 'assets/images/fists.jpg',
          timerSeconds: 5,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Release Hands',
          instruction: 'Release your fists and notice the difference. Feel the tension flowing away.',
          imageUrl: 'assets/images/open_hands.jpg',
        ),
        const ActivityStep(
          stepNumber: 4,
          title: 'Tense Shoulders',
          instruction: 'Raise your shoulders to your ears. Hold for 5 seconds.',
          imageUrl: 'assets/images/raised_shoulders.jpg',
          timerSeconds: 5,
        ),
        const ActivityStep(
          stepNumber: 5,
          title: 'Release Shoulders',
          instruction: 'Drop your shoulders and feel the relaxation spread through your upper body.',
          imageUrl: 'assets/images/relaxed_shoulders.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-003',
      name: 'Desk Meditation',
      description: 'A quick mindfulness practice to center yourself',
      pillarId: pillarStressReduction,
      durationMinutes: 2,
      difficulty: Difficulty.low,
      location: 'At Desk',
      thumbnailUrl: 'assets/images/desk_meditation.jpg',
      tags: ['mindfulness', 'meditation', 'focus'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Find Your Position',
          instruction: 'Sit comfortably with your back straight. Rest your hands on your desk or lap.',
          imageUrl: 'assets/images/meditation_posture.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Focus on Breath',
          instruction: 'Close your eyes and bring attention to your natural breathing. Don\'t try to change it.',
          imageUrl: 'assets/images/focus_breath.jpg',
          timerSeconds: 60,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Notice Thoughts',
          instruction: 'When thoughts arise, acknowledge them without judgment and return focus to your breath.',
          imageUrl: 'assets/images/mindful_thoughts.jpg',
          timerSeconds: 60,
        ),
        const ActivityStep(
          stepNumber: 4,
          title: 'Return Gently',
          instruction: 'Slowly open your eyes and take a moment before returning to work.',
          imageUrl: 'assets/images/open_eyes.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-004',
      name: 'Gratitude Reflection',
      description: 'Shift your mindset by focusing on positive aspects',
      pillarId: pillarStressReduction,
      durationMinutes: 2,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/gratitude.jpg',
      tags: ['mindfulness', 'positivity', 'mental'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Pause',
          instruction: 'Take a moment to step away from your current task.',
          imageUrl: 'assets/images/pause.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Think of Three Things',
          instruction: 'Identify three things you\'re grateful for today. They can be big or small.',
          imageUrl: 'assets/images/thinking.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Feel the Gratitude',
          instruction: 'For each item, take a moment to really feel the appreciation in your body.',
          imageUrl: 'assets/images/heart_hands.jpg',
          timerSeconds: 30,
        ),
      ],
    ),

    // Increased Energy Activities (3)
    Activity(
      id: 'activity-005',
      name: 'Desk Stretches',
      description: 'Quick stretches to energize your body',
      pillarId: pillarIncreasedEnergy,
      durationMinutes: 3,
      difficulty: Difficulty.low,
      location: 'At Desk',
      thumbnailUrl: 'assets/images/desk_stretches.jpg',
      tags: ['stretching', 'movement', 'energy'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Neck Rolls',
          instruction: 'Slowly roll your head in a circle. 5 times clockwise, then 5 times counter-clockwise.',
          imageUrl: 'assets/images/neck_rolls.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Shoulder Shrugs',
          instruction: 'Raise shoulders to ears, hold for 3 seconds, then release. Repeat 10 times.',
          imageUrl: 'assets/images/shoulder_shrugs.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Seated Twist',
          instruction: 'Place right hand on left knee, twist to the left. Hold 15 seconds. Repeat on other side.',
          imageUrl: 'assets/images/seated_twist.jpg',
          timerSeconds: 15,
        ),
        const ActivityStep(
          stepNumber: 4,
          title: 'Wrist Circles',
          instruction: 'Rotate wrists in circles, 10 times each direction.',
          imageUrl: 'assets/images/wrist_circles.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-006',
      name: 'Power Pose',
      description: 'Boost confidence and energy with body language',
      pillarId: pillarIncreasedEnergy,
      durationMinutes: 2,
      difficulty: Difficulty.low,
      location: 'Private Space',
      thumbnailUrl: 'assets/images/power_pose.jpg',
      tags: ['confidence', 'posture', 'energy'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Stand Tall',
          instruction: 'Stand with feet shoulder-width apart, hands on hips.',
          imageUrl: 'assets/images/superhero_pose.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Hold the Pose',
          instruction: 'Keep your chin up, chest out. Hold this powerful stance for 2 minutes.',
          imageUrl: 'assets/images/confident_stance.jpg',
          timerSeconds: 120,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Feel the Energy',
          instruction: 'Notice how your body feels more energized and confident.',
          imageUrl: 'assets/images/energized.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-007',
      name: 'Hydration Break',
      description: 'Refresh your body and mind with water',
      pillarId: pillarIncreasedEnergy,
      durationMinutes: 1,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/hydration.jpg',
      tags: ['water', 'health', 'quick'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Get Water',
          instruction: 'Fill a glass with cool water.',
          imageUrl: 'assets/images/water_glass.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Drink Mindfully',
          instruction: 'Drink slowly, paying attention to the sensation of water refreshing your body.',
          imageUrl: 'assets/images/drinking_water.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Take a Moment',
          instruction: 'Stand or walk for a moment before returning to your desk.',
          imageUrl: 'assets/images/standing.jpg',
        ),
      ],
    ),

    // Better Sleep Activities (3)
    Activity(
      id: 'activity-008',
      name: 'Evening Wind-Down',
      description: 'Prepare your mind for restful sleep',
      pillarId: pillarBetterSleep,
      durationMinutes: 4,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/wind_down.jpg',
      tags: ['evening', 'relaxation', 'routine'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Dim the Lights',
          instruction: 'Reduce screen brightness and lighting around you.',
          imageUrl: 'assets/images/dim_lights.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Body Scan',
          instruction: 'Starting from your toes, mentally scan up your body, releasing tension in each area.',
          imageUrl: 'assets/images/body_scan.jpg',
          timerSeconds: 120,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Gentle Breathing',
          instruction: 'Take slow, deep breaths. Inhale for 4, exhale for 6. Repeat 5 times.',
          imageUrl: 'assets/images/evening_breathing.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-009',
      name: 'Sleep Affirmations',
      description: 'Positive statements to calm your mind',
      pillarId: pillarBetterSleep,
      durationMinutes: 2,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/affirmations.jpg',
      tags: ['mindfulness', 'mental', 'evening'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Get Comfortable',
          instruction: 'Sit or lie down in a comfortable position.',
          imageUrl: 'assets/images/comfortable.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Repeat Affirmations',
          instruction: 'Silently or aloud, repeat: "I am calm. I am ready for rest. Tomorrow will take care of itself."',
          imageUrl: 'assets/images/peaceful.jpg',
          timerSeconds: 60,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Let Go',
          instruction: 'Release any remaining thoughts about work or worries.',
          imageUrl: 'assets/images/letting_go.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-010',
      name: 'Screen-Free Time',
      description: 'Give your eyes and mind a break from screens',
      pillarId: pillarBetterSleep,
      durationMinutes: 5,
      difficulty: Difficulty.medium,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/screen_free.jpg',
      tags: ['digital detox', 'eyes', 'evening'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Put Devices Away',
          instruction: 'Turn off or put away all screens - phone, computer, TV.',
          imageUrl: 'assets/images/devices_away.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Choose an Activity',
          instruction: 'Read a book, journal, or simply sit quietly for 5 minutes.',
          imageUrl: 'assets/images/reading.jpg',
          timerSeconds: 300,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Notice the Difference',
          instruction: 'Pay attention to how your eyes and mind feel without screen stimulation.',
          imageUrl: 'assets/images/relaxed_eyes.jpg',
        ),
      ],
    ),

    // Physical Fitness Activities (4)
    Activity(
      id: 'activity-011',
      name: 'Desk Push-Ups',
      description: 'Strengthen your upper body at your desk',
      pillarId: pillarPhysicalFitness,
      durationMinutes: 2,
      difficulty: Difficulty.medium,
      location: 'At Desk',
      thumbnailUrl: 'assets/images/desk_pushups.jpg',
      tags: ['strength', 'upper body', 'exercise'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Position Yourself',
          instruction: 'Place hands on edge of desk, shoulder-width apart. Step back until body is at an angle.',
          imageUrl: 'assets/images/pushup_position.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Perform Push-Ups',
          instruction: 'Lower chest to desk, then push back up. Do 10-15 repetitions.',
          imageUrl: 'assets/images/pushup_motion.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Rest',
          instruction: 'Take a 30-second break and shake out your arms.',
          imageUrl: 'assets/images/arm_shake.jpg',
          timerSeconds: 30,
        ),
      ],
    ),
    Activity(
      id: 'activity-012',
      name: 'Chair Squats',
      description: 'Activate your leg muscles without leaving your workspace',
      pillarId: pillarPhysicalFitness,
      durationMinutes: 2,
      difficulty: Difficulty.medium,
      location: 'At Desk',
      thumbnailUrl: 'assets/images/chair_squats.jpg',
      tags: ['legs', 'strength', 'exercise'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Stand in Front of Chair',
          instruction: 'Stand with feet shoulder-width apart, chair behind you.',
          imageUrl: 'assets/images/squat_start.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Lower Down',
          instruction: 'Bend knees and lower yourself until you lightly touch the chair, then stand back up.',
          imageUrl: 'assets/images/squat_down.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Repeat',
          instruction: 'Complete 15 repetitions. Keep your core engaged and back straight.',
          imageUrl: 'assets/images/squat_repeat.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-013',
      name: 'Walking Break',
      description: 'Get your blood flowing with a quick walk',
      pillarId: pillarPhysicalFitness,
      durationMinutes: 5,
      difficulty: Difficulty.low,
      location: 'Hallway/Outside',
      thumbnailUrl: 'assets/images/walking.jpg',
      tags: ['cardio', 'movement', 'outdoor'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Start Walking',
          instruction: 'Walk at a comfortable pace around your office or outside.',
          imageUrl: 'assets/images/walking_start.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Maintain Pace',
          instruction: 'Keep a steady pace for 5 minutes. Swing your arms naturally.',
          imageUrl: 'assets/images/walking_pace.jpg',
          timerSeconds: 300,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Cool Down',
          instruction: 'Slow your pace for the last 30 seconds before returning.',
          imageUrl: 'assets/images/cool_down.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-014',
      name: 'Stair Climbing',
      description: 'Quick cardio boost using stairs',
      pillarId: pillarPhysicalFitness,
      durationMinutes: 3,
      difficulty: Difficulty.high,
      location: 'Stairwell',
      thumbnailUrl: 'assets/images/stairs.jpg',
      tags: ['cardio', 'legs', 'intense'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Find Stairs',
          instruction: 'Locate a stairwell in your building.',
          imageUrl: 'assets/images/stairwell.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Climb Up',
          instruction: 'Walk up 2-3 flights of stairs at a steady pace.',
          imageUrl: 'assets/images/climbing_stairs.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Walk Down',
          instruction: 'Walk back down slowly to recover. Repeat if time allows.',
          imageUrl: 'assets/images/descending_stairs.jpg',
        ),
      ],
    ),

    // Healthy Eating Activities (3)
    Activity(
      id: 'activity-015',
      name: 'Mindful Snacking',
      description: 'Practice awareness while eating',
      pillarId: pillarHealthyEating,
      durationMinutes: 3,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/mindful_eating.jpg',
      tags: ['mindfulness', 'nutrition', 'awareness'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Choose a Healthy Snack',
          instruction: 'Select a nutritious snack like fruit, nuts, or vegetables.',
          imageUrl: 'assets/images/healthy_snack.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Eat Slowly',
          instruction: 'Take small bites. Notice the texture, taste, and smell of your food.',
          imageUrl: 'assets/images/eating_slowly.jpg',
          timerSeconds: 120,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Appreciate',
          instruction: 'Take a moment to appreciate nourishing your body.',
          imageUrl: 'assets/images/appreciation.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-016',
      name: 'Hydration Check',
      description: 'Assess and improve your water intake',
      pillarId: pillarHealthyEating,
      durationMinutes: 1,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/water_check.jpg',
      tags: ['hydration', 'health', 'quick'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Check Your Intake',
          instruction: 'Think about how much water you\'ve had today.',
          imageUrl: 'assets/images/thinking_water.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Drink a Glass',
          instruction: 'Drink a full glass of water (8 oz).',
          imageUrl: 'assets/images/drinking_full_glass.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Set a Reminder',
          instruction: 'Set a reminder to drink water again in 2 hours.',
          imageUrl: 'assets/images/phone_reminder.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-017',
      name: 'Meal Planning Moment',
      description: 'Plan your next healthy meal',
      pillarId: pillarHealthyEating,
      durationMinutes: 3,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/meal_planning.jpg',
      tags: ['planning', 'nutrition', 'preparation'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Think About Your Next Meal',
          instruction: 'Consider what you\'ll eat for your next meal.',
          imageUrl: 'assets/images/thinking_meal.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Choose Healthy Options',
          instruction: 'Plan to include vegetables, protein, and whole grains.',
          imageUrl: 'assets/images/balanced_plate.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Make a Note',
          instruction: 'Write down your meal plan or set a reminder.',
          imageUrl: 'assets/images/writing_note.jpg',
        ),
      ],
    ),

    // Social Connection Activities (3)
    Activity(
      id: 'activity-018',
      name: 'Coffee Chat',
      description: 'Connect with a colleague over a beverage',
      pillarId: pillarSocialConnection,
      durationMinutes: 5,
      difficulty: Difficulty.low,
      location: 'Break Room',
      thumbnailUrl: 'assets/images/coffee_chat.jpg',
      tags: ['social', 'conversation', 'connection'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Invite a Colleague',
          instruction: 'Ask a coworker to join you for a quick coffee or tea break.',
          imageUrl: 'assets/images/invitation.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Have a Conversation',
          instruction: 'Chat about non-work topics. Ask about their day or interests.',
          imageUrl: 'assets/images/conversation.jpg',
          timerSeconds: 240,
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Express Appreciation',
          instruction: 'Thank them for their time and the connection.',
          imageUrl: 'assets/images/thank_you.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-019',
      name: 'Gratitude Message',
      description: 'Send appreciation to someone who helped you',
      pillarId: pillarSocialConnection,
      durationMinutes: 2,
      difficulty: Difficulty.low,
      location: 'Anywhere',
      thumbnailUrl: 'assets/images/gratitude_message.jpg',
      tags: ['appreciation', 'communication', 'kindness'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Think of Someone',
          instruction: 'Identify a colleague who helped you recently or made your day better.',
          imageUrl: 'assets/images/thinking_person.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Write a Message',
          instruction: 'Send them a brief message expressing your appreciation.',
          imageUrl: 'assets/images/typing_message.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Feel the Connection',
          instruction: 'Notice how expressing gratitude makes you feel.',
          imageUrl: 'assets/images/happy_feeling.jpg',
        ),
      ],
    ),
    Activity(
      id: 'activity-020',
      name: 'Team Check-In',
      description: 'Quick pulse check with your team',
      pillarId: pillarSocialConnection,
      durationMinutes: 3,
      difficulty: Difficulty.low,
      location: 'Meeting Room',
      thumbnailUrl: 'assets/images/team_checkin.jpg',
      tags: ['team', 'communication', 'support'],
      steps: [
        const ActivityStep(
          stepNumber: 1,
          title: 'Gather Your Team',
          instruction: 'Bring your team together for a quick stand-up or virtual call.',
          imageUrl: 'assets/images/team_gathering.jpg',
        ),
        const ActivityStep(
          stepNumber: 2,
          title: 'Share Updates',
          instruction: 'Each person shares one thing they\'re working on and one thing they need help with.',
          imageUrl: 'assets/images/sharing.jpg',
        ),
        const ActivityStep(
          stepNumber: 3,
          title: 'Offer Support',
          instruction: 'Identify ways team members can support each other.',
          imageUrl: 'assets/images/support.jpg',
        ),
      ],
    ),
  ];

  /// Mock badges (10 badges with unlock criteria)
  static final List<Badge> badges = [
    Badge(
      id: 'badge-001',
      name: 'First Step',
      description: 'Complete your first activity',
      iconUrl: 'assets/icons/badge_first_step.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-002',
      name: '3-Day Streak',
      description: 'Complete activities for 3 consecutive days',
      iconUrl: 'assets/icons/badge_3_day.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-003',
      name: 'Week Warrior',
      description: 'Complete activities for 7 consecutive days',
      iconUrl: 'assets/icons/badge_week.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-004',
      name: 'Stress Buster',
      description: 'Complete 5 stress reduction activities',
      iconUrl: 'assets/icons/badge_stress.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-005',
      name: 'Energy Booster',
      description: 'Complete 5 energy-boosting activities',
      iconUrl: 'assets/icons/badge_energy.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-006',
      name: 'Sleep Champion',
      description: 'Complete 5 better sleep activities',
      iconUrl: 'assets/icons/badge_sleep.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-007',
      name: 'Fitness Fan',
      description: 'Complete 10 physical fitness activities',
      iconUrl: 'assets/icons/badge_fitness.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-008',
      name: 'Wellness Explorer',
      description: 'Complete at least one activity from each pillar',
      iconUrl: 'assets/icons/badge_explorer.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-009',
      name: 'Century Club',
      description: 'Complete 100 total activities',
      iconUrl: 'assets/icons/badge_century.png',
      isUnlocked: false,
    ),
    Badge(
      id: 'badge-010',
      name: 'Social Butterfly',
      description: 'Complete 5 social connection activities',
      iconUrl: 'assets/icons/badge_social.png',
      isUnlocked: false,
    ),
  ];

  /// Mock user data for testing
  static final User mockUser = User(
    id: 'user-001',
    email: 'john.doe@corpfinity.com',
    name: 'John Doe',
    company: 'Corpfinity',
    photoUrl: 'assets/images/default_avatar.jpg',
    wellnessGoals: [
      'Stress Reduction',
      'Better Sleep',
      'Physical Fitness',
    ],
    notifications: const NotificationPreferences(
      enabled: true,
      dailyReminders: true,
      achievementAlerts: true,
    ),
    totalPoints: 250,
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  /// Get activities by pillar ID
  static List<Activity> getActivitiesByPillar(String pillarId) {
    return activities.where((activity) => activity.pillarId == pillarId).toList();
  }

  /// Get activities by energy level and pillar
  static List<Activity> getRecommendedActivities({
    required EnergyLevel energy,
    required String pillarId,
  }) {
    final pillarActivities = getActivitiesByPillar(pillarId);
    
    // Filter by energy level based on difficulty
    switch (energy) {
      case EnergyLevel.low:
        return pillarActivities
            .where((a) => a.difficulty == Difficulty.low)
            .toList();
      case EnergyLevel.medium:
        return pillarActivities
            .where((a) => a.difficulty == Difficulty.low || a.difficulty == Difficulty.medium)
            .toList();
      case EnergyLevel.high:
        return pillarActivities; // All activities
    }
  }

  /// Get activity by ID
  static Activity? getActivityById(String id) {
    try {
      return activities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get pillar by ID
  static WellnessPillar? getPillarById(String id) {
    try {
      return wellnessPillars.firstWhere((pillar) => pillar.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search activities by name or tags
  static List<Activity> searchActivities(String query) {
    final lowerQuery = query.toLowerCase();
    return activities.where((activity) {
      return activity.name.toLowerCase().contains(lowerQuery) ||
          activity.description.toLowerCase().contains(lowerQuery) ||
          activity.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
