//
//  Project: SproutOnboardingDemo
//  File: Plant.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import Foundation

// A deliberately tiny model. The video is about onboarding, not
// persistence, so plants live in memory only — relaunch the app and the
// list is empty again (that's the "prediction" beat in the video).
// Swap this for a SwiftData @Model when you want plants to stick around.
struct Plant: Identifiable {
    let id = UUID()
    let name: String
    let daysBetweenWatering: Int

    // Computed, not stored: the next watering date is always "N days from
    // now". This one date powers the list row ("Water on …"), the primer's
    // promise ("One notification on …"), and the reminder's trigger — so
    // what the app tells the user and what it schedules can't drift apart.
    var nextWatering: Date {
        Calendar.current.date(byAdding: .day, value: daysBetweenWatering, to: .now)!
    }
}
