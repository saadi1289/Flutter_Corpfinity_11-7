# Corpfinity Employee App Frontend Specifications

This document outlines the **frontend-only design specifications** for the **Corpfinity Employee Mobile App**, structured screen by screen. Each section includes layout, typography, component, and interaction details for consistent UI generation. Backend logic (e.g., API calls, authentication) will later be implemented using **FastAPI**.

---

## 1. Splash Screen

**Purpose:** Introduce the app brand identity.

### Layout
- Full-screen background with gradient (Calm Blue → Soft Green)
- Centered logo animation (Corpfinity logo scales in)
- Optional tagline: *"Wellness in 1–5 minutes"*

### Design Details
- Background: Linear gradient (#4A90E2 → #7ED321)
- Logo: 200x200px, SVG preferred for scalability
- Animation: Fade-in (0 → 100% opacity, 800ms)

### Typography
- Tagline: 18px Inter Medium, color #FFFFFF, letter spacing 0.5px

### Interactions
- Auto-transition to **Welcome Carousel** after 2s fade-out

### Backend Notes
- No API call; static screen.

---

## 2. Welcome Carousel

**Purpose:** Educate new users on app value and flow.

### Layout
- 3 horizontally swipeable cards:
  1. Wellness at your desk
  2. Choose energy level + goal
  3. Track your progress
- Navigation dots (3 total)
- CTA button: *"Get Started"*

### Design Details
- Background: White (#FFFFFF)
- Illustrations: Vector or Lottie animations
- Card dimensions: 90% width, height auto
- Dot inactive: #ECF0F1, active: #4A90E2
- Button: Primary (Calm Blue background, white text)

### Typography
- Header: 24px Bold, color #2C3E50
- Body: 16px Regular, color #7F8C8D

### Animations
- Slide-in from right (300ms)
- Fade on transition between slides

### Backend Notes
- Triggers routing to **Account Creation Screen**.

---

## 3. Account Creation

**Purpose:** Allow user registration with email/password or SSO.

### Layout
- Header: “Create Account”
- Form Fields:
  - Email
  - Password
  - Confirm Password
- Buttons:
  - Primary: “Sign Up”
  - Secondary: “Sign In Instead”
  - Divider: “or continue with” (SSO buttons below)

### Design Details
- Background: #FFFFFF
- Card container: White, rounded corners 16px, shadow rgba(0,0,0,0.05)
- Button height: 48px, border-radius: 12px
- SSO icons: Google, Microsoft (monotone, 24px)

### Typography
- Labels: 14px Medium
- Inputs: 16px Regular

### Interactions
- Form validation (email regex, password length ≥8)
- Transition to **Profile Setup** on success

### Backend Notes
- POST `/api/auth/register` (FastAPI endpoint)

---

## 4. Profile Setup

**Purpose:** Capture user basics and wellness goals.

### Layout
- Profile fields:
  - Name
  - Company (auto-filled via SSO if available)
  - Notification preferences (toggle)
  - Wellness goals (multi-select chips)

### Design Details
- Chip active: #4A90E2, white text
- Chip inactive: #ECF0F1, #2C3E50 text
- Toggle: Rounded slider, calm blue on active
- Button: “Continue” (primary)

### Typography
- Section titles: 18px Semibold
- Input text: 16px Regular

### Animations
- Chips bounce when selected (scale 0.9→1.0)

### Backend Notes
- PATCH `/api/users/me`

---

## 5. Home Screen

**Purpose:** Central dashboard for activity entry.

### Layout
- Header: “Good Morning, [Name] 👋”
- Energy Level Selector:
  - 3 cards: 🔴 Low, 🟡 Medium, 🟢 High
- Quick Stats below:
  - Streak
  - Weekly goal progress bar
  - Total activities completed

### Design Details
- Energy cards:
  - Height: 150px, Width: 100%
  - Color: Soft coral (#FFB6A3), Warm yellow (#FFD97D), Fresh green (#A8E6A3)
  - Rounded corners (16px), shadow rgba(0,0,0,0.05)
- Progress bar: 8px, gradient Calm Blue → Soft Green

### Typography
- Titles: 20px Bold, Body: 16px Regular

### Interactions
- Tapping energy card → **Wellness Pillar Screen**
- Progress bar animates to value on load

### Backend Notes
- GET `/api/users/me/progress`

---

## 6. Wellness Pillar Selection

**Purpose:** Let users choose wellness focus.

### Layout
- 6 grid cards (2 columns x 3 rows)
  - ⚡ Stress Reduction
  - 🔋 Increased Energy
  - 😴 Better Sleep
  - 💪 Physical Fitness
  - 🥗 Healthy Eating
  - 🤝 Social Connection

### Design Details
- Card background: White, shadow rgba(0,0,0,0.05)
- Pillar icon size: 36px
- Card height: 140px
- Border radius: 16px
- “Activities available” badge (top-right, Calm Blue)

### Typography
- Pillar Name: 18px Semibold
- Description: 14px Regular

### Interactions
- Tap card → **Activity Selection Screen**

### Backend Notes
- GET `/api/activities?pillar=selected`.

---

## 7. Activity Selection Screen

**Purpose:** Display recommended activities.

### Layout
- List of 3–5 cards per pillar
- Each card:
  - Thumbnail (left)
  - Activity name
  - Duration
  - Difficulty (Low/Medium/High)
  - Location icon

### Design Details
- Card padding: 16px, radius: 12px
- Thumbnail: 64x64px, rounded corners
- Difficulty indicator: Dot (color-coded by energy level)

### Typography
- Name: 16px Semibold, Duration: 14px Medium gray

### Interactions
- Tap card → **Activity Guide Screen**

### Backend Notes
- GET `/api/activities/recommended?energy=level`.

---

## 8. Activity Guide Screen

**Purpose:** Provide step-by-step activity instructions.

### Layout
- Header: Activity name + step progress bar
- Main section: Illustration/GIF
- Instruction text below visual
- Timer component (for timed tasks)
- Button: “Next Step” or “Complete”

### Design Details
- Background: White
- Timer ring: Circular SVG, color Calm Blue
- Progress bar: Step progress (fill animation)

### Typography
- Step title: 18px Semibold
- Instruction: 16px Regular

### Interactions
- Button click → next step or completion animation

### Backend Notes
- POST `/api/activities/{id}/complete`.

---

## 9. Completion Screen

**Purpose:** Congratulate and summarize progress.

### Layout
- Confetti animation (centered)
- Success text: “You completed [Activity Name]!”
- Stats summary: Streak count, weekly goal, total points
- Buttons: “Do Another Activity” / “Return Home”

### Design Details
- Background: Gradient Soft Green → White
- Confetti: Lottie JSON (loop once)
- CTA button: Calm Blue

### Typography
- Header: 22px Bold
- Stats: 16px Medium gray

### Interactions
- Tap “Do Another Activity” → Pillar screen

### Backend Notes
- GET `/api/users/me/progress` (update streak)

---

## 10. Progress & Streaks Screen

**Purpose:** Track activity history and achievements.

### Layout
- Tabs: [Streaks] [History] [Badges]
- Streaks tab: Calendar visualization (highlight completed days)
- History tab: List view of completed activities
- Badges tab: Grid of earned + locked badges

### Design Details
- Calendar cells: Rounded squares (8px radius)
- Badges: Circular icons, grayscale when locked
- Section spacing: 16px

### Typography
- Tab titles: 16px Semibold
- Badge labels: 12px Medium

### Animations
- Badge unlock pulse (scale 0→1.2→1)

### Backend Notes
- GET `/api/progress/streaks`
- GET `/api/progress/badges`

---

## 11. Profile & Settings Screen

**Purpose:** Manage user preferences.

### Layout
- Profile header: Photo + name + total points
- Tabs:
  - Notification preferences
  - Voice guidance toggle
  - Privacy settings
  - Language selector
  - Logout

### Design Details
- Toggle active: #4A90E2, inactive: #7F8C8D
- Language dropdown: Rounded 12px border, shadow

### Typography
- Section title: 18px Bold
- Item text: 16px Regular

### Animations
- Toggle slide: 200ms ease-in-out

### Backend Notes
- GET/PUT `/api/users/me/settings`

---

## 12. Activity Library Screen

**Purpose:** Explore all available activities.

### Layout
- Search bar at top (placeholder: “Search activities…”)
- Filter by pillar dropdown
- List/grid of all activities with preview image, name, duration

### Design Details
- Search field radius: 12px, icon on left
- Card layout: 2 columns grid, equal spacing (8px)
- Card height: 160px, thumbnail fills top 60%

### Typography
- Name: 16px Semibold
- Duration: 14px Medium gray

### Interactions
- Tap → open **Activity Guide**

### Backend Notes
- GET `/api/activities` (with filters: pillar, duration)

---

## Global Design Consistency

### Color Palette
- Calm Blue (#4A90E2)
- Soft Green (#7ED321)
- Warm Orange (#F5A623)
- Gentle Red (#E85D75)
- Neutral Gray (#ECF0F1)

### Typography
- Font: Inter (iOS: SF Pro, Android: Roboto)
- Sizes: 12–28px scale with 1.5x line height

### Components
- Buttons: Rounded 12px, shadows for primary
- Cards: White, 16px radius
- Progress Bars: Animated, gradient fill
- Icons: Feather or Material icons, outlined style

### Animations
- Transitions: Slide (300ms), fade (250ms)
- Confetti: Lottie (1000ms)

### Responsive Behavior
- Min width: 320px (iPhone SE)
- Scale fonts and padding proportionally
- Grid columns adjust automatically for tablets

---

**End of Document — Corpfinity Employee Frontend Design v1.0**

