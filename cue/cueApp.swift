//
//  cueApp.swift
//  cue
//
//  Created by Nate Cadicamo on 2/3/26.
//

import SwiftUI
import SwiftData

@main
struct cueApp: App {
    var body: some Scene {
        WindowGroup {
            VerticalPager()
                .preferredColorScheme(.dark)
        }
        // Use SwiftData model container. This creates an SQLite container with GoalModel schema
        .modelContainer(for: GoalModel.self)
    }
}
