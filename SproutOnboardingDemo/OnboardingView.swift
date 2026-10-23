//
//  Project: SproutOnboardingDemo
//  File: OnboardingView.swift
//  Created by Noah Carpenter
//
//  📺 YouTube: Noah Does Coding
//  https://www.youtube.com/@NoahDoesCoding
//  Like and Subscribe for coding tutorials and fun! 💻✨
//  Dream Big. Code Bigger 🚀
//

import SwiftUI

// Three pages, a way out on every one, and a last page whose button is
// the app's first real action — not "Get Started".
struct OnboardingView: View {
    // Reports back how onboarding ended: a Plant if the user added one,
    // nil if they skipped. ContentView decides what to do with either.
    let onFinish: (Plant?) -> Void
    @State private var page = 0
    @State private var isAddingPlant = false

    // Each page points at the first win. Page three names it outright
    // ("Start with one plant") so the button underneath feels like the
    // obvious next step, not a surprise.
    private let pages = [
        (symbol: "drop.fill", title: "Never guess when to water", detail: "Sprout knows which plant is thirsty, and when."),
        (symbol: "calendar", title: "Every plant, its own schedule", detail: "A fern and a cactus shouldn't share a reminder."),
        (symbol: "leaf.fill", title: "Start with one plant", detail: "The one on your windowsill. It takes ten seconds."),
    ]

    var body: some View {
        VStack(spacing: 24) {
            // TabView(selection:) + .page style gives native swipe paging.
            // Binding to `page` lets the Next button and our custom
            // indicator stay in sync with swipes.
            TabView(selection: $page) {
                ForEach(pages.indices, id: \.self) { index in
                    VStack(spacing: 16) {
                        Image(systemName: pages[index].symbol)
                            .font(.system(size: 72))
                            .foregroundStyle(.green)
                            // Decorative — the title already says it.
                            .accessibilityHidden(true)
                        Text(pages[index].title)
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)
                        Text(pages[index].detail)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(32)
                    .tag(index)
                }
            }
            // .never hides the system dots so we can draw our own.
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom page indicator: the current page's capsule stretches
            // wider, so progress reads at a glance.
            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Capsule()
                        .fill(index == page ? Color.green : Color.secondary.opacity(0.4))
                        .frame(width: index == page ? 24 : 8, height: 8)
                }
            }
            .animation(.spring, value: page)
            // Custom indicators are invisible to VoiceOver by default
            // (they're just shapes). Collapse them into one element that
            // says where you are.
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Page \(page + 1) of \(pages.count)")

            VStack(spacing: 12) {
                if page < pages.count - 1 {
                    Button("Next") {
                        withAnimation { page += 1 }
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    // The key move: the final button opens the REAL add
                    // sheet. Save there and onboarding is over — with a
                    // plant already in the list.
                    Button("Add your first plant") {
                        isAddingPlant = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                // Always offer a way out. Skippers aren't lost — the empty
                // state in ContentView guides them to the same win.
                Button("Skip") {
                    onFinish(nil)
                }
            }
            .controlSize(.large)
            .padding(.bottom, 32)
        }
        .sheet(isPresented: $isAddingPlant) {
            AddPlantView { plant in
                onFinish(plant)
            }
        }
    }
}

#Preview {
    OnboardingView { _ in }
}
