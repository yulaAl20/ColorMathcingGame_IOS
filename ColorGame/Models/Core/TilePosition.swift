//
//  TilePosition.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-16.
//
import SwiftUI

struct TilePositionKey: PreferenceKey {
    static var defaultValue: [UUID: CGPoint] = [:]

    static func reduce(
        value: inout [UUID: CGPoint],
        nextValue: () -> [UUID: CGPoint]
    ) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}


