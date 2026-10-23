//
//  Project: SproutOnboardingDemo
//  File: ReminderPrimer.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import SwiftUI

// A "primer": our own card that explains the ask BEFORE iOS shows its
// one-shot system alert. If the user taps "Not now" here, we've spent
// nothing — the real alert is still unused and we can ask again later.
// If we fired the system alert cold and they denied it, it's gone for good
// (they'd have to dig through Settings).
struct ReminderPrimer: View {
    let plant: Plant
    let onDone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Specific beats generic. "Notify you about Monstera on
            // Tuesday" earns a yes; "Enable notifications?" doesn't.
            Label("Want a nudge when \(plant.name) is thirsty?", systemImage: "bell.badge")
                .font(.headline)
            Text("One notification on \(plant.nextWatering, format: .dateTime.weekday(.wide)). Nothing else.")
                .foregroundStyle(.secondary)
            HStack {
                Button("Remind me") {
                    Task {
                        // Only now do we trigger the system alert — and if
                        // they allow it, we immediately keep the promise
                        // the card just made by scheduling that exact
                        // reminder.
                        if await Reminders.requestPermission() {
                            await Reminders.schedule("Time to water \(plant.name)", on: plant.nextWatering)
                        }
                        onDone()
                    }
                }
                .buttonStyle(.borderedProminent)
                Button("Not now", action: onDone)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        ReminderPrimer(plant: Plant(name: "Monstera", daysBetweenWatering: 7)) {}
    }
}
