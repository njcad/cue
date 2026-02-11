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
    var isDestructive: Bool = false
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
                Spacer()
            }
            .foregroundStyle(isDestructive ? Color.red : Color.white)
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
