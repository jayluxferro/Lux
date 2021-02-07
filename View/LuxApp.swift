//
//  LuxApp.swift
//  Shared
//
//  Created by Jay on 18/09/2020.
//

import SwiftUI

@main
struct LuxApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                // EnerSmart
                EnerSmartView()
                    .tabItem {
                        Image(systemName: "bolt.circle")
                    }
                
                // Momo
                MomoView()
                    .tabItem {
                        Image(systemName: "doc.text.magnifyingglass")
                    }
            }
        }
    }
}
