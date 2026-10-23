//
//  Project: SproutOnboardingDemo
//  File: ContentView.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import SwiftUI

// The home screen, and the hub that ties the whole first-run path together:
// download → onboarding → first plant (the win) → one well-timed ask.
struct ContentView: View {
    // @AppStorage writes to UserDefaults, so this survives relaunches.
    // It starts true on a fresh install and flips to false the moment the
    // user finishes OR skips onboarding — either way, they never see it
    // again. Delete the app to get a true first launch back.
    @AppStorage("showOnboarding") private var showOnboarding = true
    @State private var plants: [Plant] = []
    @State private var isAddingPlant = false
    // Only true right after a win, and only if we've never asked before.
    @State private var shouldAskForReminders = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(plants) { plant in
                    VStack(alignment: .leading) {
                        Text(plant.name)
                            .font(.headline)
                        Text("Water on \(plant.nextWatering, format: .dateTime.weekday(.wide).month().day())")
                            .foregroundStyle(.secondary)
                    }
                }
                // The notification "primer" sits inline, under the plant the
                // user just added — not in a popup at launch. The ask shows
                // up next to the thing it helps with.
                if shouldAskForReminders, let plant = plants.first {
                    ReminderPrimer(plant: plant) {
                        shouldAskForReminders = false
                    }
                }
            }
            .overlay {
                // Skipping onboarding must not dump someone on a blank
                // screen. This empty state still points at the same first
                // win: a description of why, and a button that opens the
                // same add sheet the last onboarding page does.
                if plants.isEmpty {
                    ContentUnavailableView {
                        Label("No plants yet", systemImage: "leaf")
                    } description: {
                        Text("Add the one on your windowsill. Sprout will tell you when it needs water.")
                    } actions: {
                        Button("Add your first plant") {
                            isAddingPlant = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Sprout")
            .toolbar {
                Button("Add plant", systemImage: "plus") {
                    isAddingPlant = true
                }
            }
            .sheet(isPresented: $isAddingPlant) {
                AddPlantView { plant in
                    plants.append(plant)
                }
            }
            // fullScreenCover (not .sheet) so onboarding can't be swiped
            // away half-read. Binding it straight to the @AppStorage flag
            // means "is onboarding showing?" and "has the user been
            // onboarded?" are the same piece of state.
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView { plant in
                    // nil means the user tapped Skip. A plant means they
                    // finished on the last page's "Add your first plant".
                    if let plant {
                        plants.append(plant)
                    }
                    showOnboarding = false
                }
            }
            // .task(id:) re-runs whenever its id changes — here, every time
            // a plant is added. That's our "just had a win" moment. We only
            // show the primer if the system permission is still
            // .notDetermined: once someone has answered the real alert, iOS
            // won't show it again, so priming would be a broken promise.
            .task(id: plants.count) {
                guard !plants.isEmpty else { return }
                shouldAskForReminders = await Reminders.status() == .notDetermined
            }
        }
    }
}

#Preview {
    ContentView()
}
