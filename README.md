# 🌱 SwiftUI Onboarding That Leads to the First Win

A SwiftUI demo showing onboarding that gets a new user from the download to their first real win, and keeps pointing the way even if they tap Skip.

---

## 🤔 What this is

Sprout is a tiny plant-watering app built from a blank project. Its first-run path is one connected flow:

1. **Three onboarding pages** (`TabView` + `.tabViewStyle(.page)`) with a custom page indicator and a Skip button on every page.
2. **A last page whose button is the app's first action.** "Add your first plant" opens the *real* add sheet. Save, and onboarding ends with a plant already in the list.
3. **An `@AppStorage` gate**, so onboarding shows once, whether the user finishes or skips.
4. **An empty state that still guides.** Skippers land on a `ContentUnavailableView` with a description and an "Add your first plant" button, not a blank list.
5. **One notification ask, primed after the win.** A card under the new plant explains exactly what it'll send ("One notification on Tuesday. Nothing else.") before iOS shows its one-shot system alert. Then it schedules that exact reminder.

## ✅ Why you'd use it

- **Onboarding that ends in the app, not before it.** See how to reuse your real first-action screen as the final onboarding step.
- **Skip without dead ends.** The empty state and the last onboarding page point at the same win.
- **Permission asks that get a yes.** A pre-permission primer, shown only while the status is `.notDetermined`, keeps the system alert unused until the user has a reason to say yes.
- **Commented for learning.** Every file explains the *why* behind each decision, not just the *what*.

## 📺 Watch on YouTube

[![Watch on YouTube](https://img.shields.io/badge/YouTube-Watch%20the%20Tutorial-red?style=for-the-badge&logo=youtube)](https://youtu.be/nh809wJg1fQ)

> This project was built for the [NoahDoesCoding YouTube channel](https://www.youtube.com/@NoahDoesCoding).

---

## 🗂️ Project tour

| File | What it teaches |
|---|---|
| `ContentView.swift` | The hub: `@AppStorage` + `.fullScreenCover`, the guiding empty state, and `.task(id:)` to show the primer right after a plant is added |
| `OnboardingView.swift` | Paged `TabView`, a custom accessible page indicator, Skip, and the last-page button that opens the real add sheet |
| `AddPlantView.swift` | The app's first action, reused from the toolbar, the empty state, and onboarding via an `onSave` closure |
| `ReminderPrimer.swift` | The pre-permission card: a specific promise, "Remind me", and "Not now" |
| `Reminders.swift` | `UNUserNotificationCenter` with async/await: status, request, a 9 AM `UNCalendarNotificationTrigger`, and a debug logger |
| `Plant.swift` | The in-memory model, and the single `nextWatering` date everything shares |

## 🚀 Getting Started

### 1. Clone

```bash
git clone https://github.com/NDCSwift/OnboardingDemo_SwiftUI.git
```

### 2. Open

Open `SproutOnboardingDemo.xcodeproj` in Xcode.

### 3. Team

Select your Development Team under **Signing & Capabilities**.

### 4. Bundle ID

Update the Bundle Identifier if you plan to run this on a physical device.

## 🛠️ Notes

- **Want to see onboarding again?** Delete the app from the simulator. `@AppStorage` remembers that onboarding was shown, so a relaunch won't bring it back.
- **Plants don't persist.** They live in `@State` on purpose, to keep the focus on onboarding. Relaunch and the list is empty. Swap `Plant` for a SwiftData `@Model` to keep them.
- **Primer not showing?** It only appears while notification permission is `.notDetermined`. If you've already answered the system alert, reset it by deleting the app.
- **Check a scheduled reminder** without waiting a week: call `await Reminders.logPending()` after "Remind me" and read Xcode's console.
- **macOS:** `.fullScreenCover` and `.tabViewStyle(.page)` aren't available. Use `.sheet` and switch pages with the Next button instead.

## 📦 Requirements

- Xcode 16+
- iOS 17+
- Swift 5.9+ (builds clean in Swift 6 language mode with complete concurrency checking)

---

📺 [Watch the guide on YouTube](https://www.youtube.com/@NoahDoesCoding)
