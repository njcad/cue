//
//  Start.swift
//  cue
//
//  Created by Nate Cadicamo on 2/6/26.
//

import SwiftUI

struct Start: View {
    
    private let haptic = UIImpactFeedbackGenerator(style: .light)
    
    @State private var isShowingCreateSheet: Bool = false
    
    func onCreate() {
        haptic.impactOccurred()
        isShowingCreateSheet = true
    }
    
    var body: some View {
        VStack {
            
            (
                Text("What do you want to get ")
                // The + operator lets you combine like components
                + Text("done")
                    .bold()
                    .foregroundStyle(Color.brandGreen)
                + Text("?")
            )
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            
            
            Button(action: onCreate) {
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
                    .frame(width: 128, height: 128)
                    .background(Color.brandGray)
                    .clipShape(Circle())
            }
        }
        .frame(alignment: .center)
        .onAppear{ haptic.prepare() }
        
        // Create Goal view
        .sheet(isPresented: $isShowingCreateSheet) {
            CreateGoalView()
        }
    }
}

#Preview {
    Start()
        .preferredColorScheme(.dark)
}
