//
//  Project: SproutOnboardingDemo
//  File: Reminders.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import UserNotifications

// A caseless enum is just a namespace: nothing to create, no state to own.
// Every UNUserNotificationCenter call the app needs lives here, using the
// async versions of the API so callers can simply `await`.
enum Reminders {
    // Read the current permission without prompting. ContentView uses this
    // to decide whether the primer is worth showing (.notDetermined = the
    // system alert hasn't been used yet).
    static func status() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    // Shows the real system alert — iOS only ever shows it once. Call this
    // from a user tap after priming, never at launch.
    static func requestPermission() async -> Bool {
        let granted = try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound])
        return granted ?? false
    }

    static func schedule(_ title: String, on date: Date) async {
        let content = UNMutableNotificationContent()
        content.title = title
        // Keep only the calendar day, then pin it to 9 AM — a reminder at
        // "exactly 7×24 hours after you added the plant" could land at
        // 2 AM. A calendar trigger fires at a sensible local time.
        var day = Calendar.current.dateComponents([.year, .month, .day], from: date)
        day.hour = 9
        let trigger = UNCalendarNotificationTrigger(dateMatching: day, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        try? await UNUserNotificationCenter.current().add(request)
    }

    // Debug helper: prints every pending reminder and when it'll fire, so
    // you can confirm scheduling worked without waiting a week. In the video
    // it's called once after "Remind me", then the call is removed.
    static func logPending() async {
        for request in await UNUserNotificationCenter.current().pendingNotificationRequests() {
            let trigger = request.trigger as? UNCalendarNotificationTrigger
            print(request.content.title, trigger?.nextTriggerDate()?.formatted() ?? "no date")
        }
    }
}
