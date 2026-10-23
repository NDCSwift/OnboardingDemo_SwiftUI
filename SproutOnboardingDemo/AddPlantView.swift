//
//  Project: SproutOnboardingDemo
//  File: AddPlantView.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import SwiftUI

// The app's first real action. This exact view is reused in three places:
// the toolbar's + button, the empty state's button, and the LAST page of
// onboarding. Reusing the real sheet (not a fake "demo" step) is the whole
// point — finishing onboarding *is* the user's first win.
struct AddPlantView: View {
    // The view doesn't know where the plant goes. Whoever presents it
    // decides — ContentView appends to its list, OnboardingView hands the
    // plant back through onFinish. A closure keeps this view reusable.
    let onSave: (Plant) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var days = 7

    var body: some View {
        NavigationStack {
            Form {
                TextField("Plant name", text: $name)
                    .autocorrectionDisabled()
                Stepper("Water every \(days) days", value: $days, in: 1...30)
            }
            .navigationTitle("New plant")
            .toolbar {
                Button("Save") {
                    onSave(Plant(name: name, daysBetweenWatering: days))
                    dismiss()
                }
                // Keep the win real: no saving a plant with no name.
                .disabled(name.isEmpty)
            }
        }
    }
}

#Preview {
    AddPlantView { _ in }
}
