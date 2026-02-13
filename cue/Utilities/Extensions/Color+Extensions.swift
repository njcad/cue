//
//  Color+Extensions.swift
//  cue
//
//  Created by Nate Cadicamo on 2/6/26.
//
//  Note: I used this color converter: https://iosref.com/uihex
//  Apparently Swift uses some kind of special color system that isn't quite the Figma RGB

import SwiftUI

// Extensions allow you to add additional functionality to a pre-existing class, struct, enum or protocol.
// Here we extend the Swift Color struct with our own colors.
extension Color {
    static let brandGreen: Color = Color(red: 0, green: 0.855, blue: 0.561) // #00DA8F
    static let brandPink: Color = Color(red: 0.988, green: 0, blue: 0.647) // #FC00A5
    static let brandGray: Color = Color(red: 0.086, green: 0.086, blue: 0.086) // #161616
}
