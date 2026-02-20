//
//  AnimatedGradientBackground.swift
//  TTime
//
//  Created by Tomas Hustoles on 22/1/26.
//

import SwiftUI

struct AnimatedGradientBackground: View {
    @Environment(\.theme) private var theme
    let gradientPreset: GradientPreset
    
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let phase = sin(time / theme.motion.gradientAnimationDuration) * 0.5 + 0.5
            
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    // Row 0
                    .init(x: 0, y: 0),
                    .init(x: 0.5 + Float(phase) * 0.1, y: 0 + Float(sin(time / 15)) * 0.05),
                    .init(x: 1, y: 0),
                    // Row 1
                    .init(x: 0, y: 0.5 + Float(cos(time / 18)) * 0.08),
                    .init(x: 0.5 + Float(sin(time / 12)) * 0.05, y: 0.5 + Float(cos(time / 16)) * 0.05),
                    .init(x: 1, y: 0.5 + Float(sin(time / 14)) * 0.06),
                    // Row 2
                    .init(x: 0, y: 1),
                    .init(x: 0.5 + Float(cos(time / 17)) * 0.07, y: 1),
                    .init(x: 1, y: 1)
                ],
                colors: [
                    gradientPreset.colors[0],
                    gradientPreset.colors[1],
                    gradientPreset.colors[0],
                    gradientPreset.colors[1],
                    gradientPreset.colors[2],
                    gradientPreset.colors[1],
                    gradientPreset.colors[0],
                    gradientPreset.colors[1],
                    gradientPreset.colors[0]
                ]
            )
            .ignoresSafeArea()
        }
    }
}
