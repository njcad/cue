//
//  Completed.swift
//  cue
//
//  Created by Nate Cadicamo on 2/6/26.
//

import SwiftUI

// For use animated in after SliderButton is marked complete
struct Completed: View {
    var body: some View {
        HStack {
            Text("Completed today")
                .font(.body)
                .bold()
                .foregroundStyle(Color.brandGreen)
            Image(systemName: "checkmark")
                .foregroundStyle(Color.brandGreen)
        }
        .frame(height: 60) // Match SliderButton height
    }
}

#Preview {
    Completed()
}
