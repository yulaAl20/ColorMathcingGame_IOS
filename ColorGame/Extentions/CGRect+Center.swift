//
//  CGRect+Center.swift
//  ColorGame
//
//  Created by Yulani on 2026-01-16.
//
import CoreGraphics

extension CGRect {
    var centerPoint: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

