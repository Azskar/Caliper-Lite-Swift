//
//  ContentView.swift
//  Caliper Lite
//
//  Created by Азар Аскаров on 20.07.2025.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        let transparentAppearence = UITabBarAppearance()
        UITabBar
            .appearance()
            .unselectedItemTintColor = UIColor(Color.white)
        UITabBar
            .appearance()
            .standardAppearance = transparentAppearence
    }
    
    var body: some View {
        TabView {
            MeasurementsView()
                .tabItem {
                    Label("Measurements", systemImage: "list.bullet.clipboard.fill")
                }
            UserProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
