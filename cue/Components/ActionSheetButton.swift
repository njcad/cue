//
//  ActionSheetButton.swift
//  cue
//
//  Created by Nate Cadicamo on 2/10/26.
//

import SwiftUI

struct ActionSheetButton: View {
    let label: String
    let icon: String
    
    // These need to be vars I think because we call this button and sometimes change the value
    // Equivalently, we could use let and manually pass in values, but I prefer to have them optional at call-site
    var isDestructive: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        } label: {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                Text(label)
                Spacer() // Push to edge: [ (icon) (text) ----------- ]
            }
            .foregroundStyle(
                isDisabled ? Color.gray.opacity(0.5) :
                isDestructive ? Color.red : Color.white
            )
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .disabled(isDisabled)
    }
}
