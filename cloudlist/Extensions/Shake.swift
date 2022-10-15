//
//  Shake.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 13/10/2022.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 4
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

