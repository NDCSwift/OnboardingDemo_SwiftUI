//
//  Project: SproutOnboardingDemo
//  File: SproutOnboardingDemoApp.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import SwiftUI

// The app entry point stays empty on purpose. Onboarding is NOT decided
// here — ContentView owns the @AppStorage flag and presents onboarding
// over the real app, so the first screen a new user lands on after the
// intro is the app itself, not a separate "root" swap.
@main
struct SproutOnboardingDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
