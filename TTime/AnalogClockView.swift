import SwiftUI

struct AnalogClockView: View {
    let timezone: TimeZone
    let isDark: Bool

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
            let angles = self.angles(for: timeline.date)

            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height)
                let diameter = size * 0.52
                let handWidth: CGFloat = 3.0

                ZStack {
                    glassDisc(diameter: diameter)

                    glassHand(
                        length: diameter * 0.28,
                        width: handWidth,
                        angle: angles.hour
                    )

                    glassHand(
                        length: diameter * 0.38,
                        width: handWidth,
                        angle: angles.minute
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }

    // MARK: - Clock Angles

    private struct ClockAngles {
        let hour: Angle
        let minute: Angle
    }

    private func angles(for date: Date) -> ClockAngles {
        var calendar = Calendar.current
        calendar.timeZone = timezone
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)

        return ClockAngles(
            hour: .degrees(Double(hour % 12) * 30 + Double(minute) * 0.5),
            minute: .degrees(Double(minute) * 6 + Double(second) * 0.1)
        )
    }

    // MARK: - Glass Disc

    @ViewBuilder
    private func glassDisc(diameter: CGFloat) -> some View {
        if isDark {
            darkGlassDisc(diameter: diameter)
        } else {
            lightGlassDisc(diameter: diameter)
        }
    }

    @ViewBuilder
    private func darkGlassDisc(diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.22))
                .frame(width: diameter, height: diameter)
                .blur(radius: 30)
                .offset(x: 4, y: 8)

            ZStack {
                RadialGradient(
                    stops: [
                        .init(color: Color(white: 0.20, opacity: 0.28), location: 0.0),
                        .init(color: Color(white: 0.15, opacity: 0.34), location: 0.55),
                        .init(color: Color(white: 0.08, opacity: 0.52), location: 0.88),
                        .init(color: Color(white: 0.05, opacity: 0.62), location: 1.0),
                    ],
                    center: UnitPoint(x: 0.42, y: 0.38),
                    startRadius: 0,
                    endRadius: diameter / 2
                )

                RadialGradient(
                    colors: [
                        Color(red: 0.52, green: 0.46, blue: 0.38).opacity(0.045),
                        Color.clear,
                    ],
                    center: UnitPoint(x: 0.68, y: 0.28),
                    startRadius: 0,
                    endRadius: diameter * 0.4
                )

                RadialGradient(
                    colors: [
                        Color(red: 0.38, green: 0.42, blue: 0.52).opacity(0.04),
                        Color.clear,
                    ],
                    center: UnitPoint(x: 0.28, y: 0.72),
                    startRadius: 0,
                    endRadius: diameter * 0.4
                )
            }
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())

            Ellipse()
                .fill(
                    RadialGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.22), location: 0.0),
                            .init(color: Color.white.opacity(0.08), location: 0.55),
                            .init(color: Color.clear, location: 1.0),
                        ],
                        center: UnitPoint(x: 0.48, y: 0.35),
                        startRadius: 0,
                        endRadius: diameter * 0.2
                    )
                )
                .frame(width: diameter * 0.52, height: diameter * 0.28)
                .offset(y: -diameter * 0.2)
                .blur(radius: 5)

            Ellipse()
                .fill(Color.white.opacity(0.10))
                .frame(width: diameter * 0.16, height: diameter * 0.035)
                .offset(x: -diameter * 0.02, y: -diameter * 0.32)
                .blur(radius: 2)

            Circle()
                .trim(from: 0.56, to: 0.70)
                .stroke(
                    Color.white.opacity(0.055),
                    style: StrokeStyle(lineWidth: diameter * 0.018, lineCap: .round)
                )
                .frame(width: diameter * 0.72, height: diameter * 0.72)
                .blur(radius: 4)

            Circle()
                .stroke(
                    AngularGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.20), location: 0.0),
                            .init(color: Color.white.opacity(0.07), location: 0.22),
                            .init(color: Color.white.opacity(0.01), location: 0.45),
                            .init(color: Color.white.opacity(0.01), location: 0.7),
                            .init(color: Color.white.opacity(0.10), location: 0.9),
                            .init(color: Color.white.opacity(0.20), location: 1.0),
                        ],
                        center: .center,
                        startAngle: .degrees(-60),
                        endAngle: .degrees(300)
                    ),
                    lineWidth: 1
                )
                .frame(width: diameter, height: diameter)
        }
    }

    @ViewBuilder
    private func lightGlassDisc(diameter: CGFloat) -> some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.08))
                .frame(width: diameter, height: diameter)
                .blur(radius: 30)
                .offset(x: 3, y: 6)

            ZStack {
                RadialGradient(
                    stops: [
                        .init(color: Color(white: 1.0, opacity: 0.55), location: 0.0),
                        .init(color: Color(white: 0.98, opacity: 0.50), location: 0.45),
                        .init(color: Color(white: 0.92, opacity: 0.45), location: 0.8),
                        .init(color: Color(white: 0.88, opacity: 0.42), location: 1.0),
                    ],
                    center: UnitPoint(x: 0.42, y: 0.38),
                    startRadius: 0,
                    endRadius: diameter / 2
                )

                RadialGradient(
                    colors: [
                        Color(red: 0.58, green: 0.52, blue: 0.46).opacity(0.035),
                        Color.clear,
                    ],
                    center: UnitPoint(x: 0.68, y: 0.28),
                    startRadius: 0,
                    endRadius: diameter * 0.4
                )

                RadialGradient(
                    colors: [
                        Color(red: 0.44, green: 0.48, blue: 0.58).opacity(0.03),
                        Color.clear,
                    ],
                    center: UnitPoint(x: 0.28, y: 0.72),
                    startRadius: 0,
                    endRadius: diameter * 0.4
                )
            }
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())

            Ellipse()
                .fill(
                    RadialGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.65), location: 0.0),
                            .init(color: Color.white.opacity(0.25), location: 0.55),
                            .init(color: Color.clear, location: 1.0),
                        ],
                        center: UnitPoint(x: 0.48, y: 0.35),
                        startRadius: 0,
                        endRadius: diameter * 0.2
                    )
                )
                .frame(width: diameter * 0.52, height: diameter * 0.28)
                .offset(y: -diameter * 0.2)
                .blur(radius: 5)

            Ellipse()
                .fill(Color.white.opacity(0.35))
                .frame(width: diameter * 0.16, height: diameter * 0.035)
                .offset(x: -diameter * 0.02, y: -diameter * 0.32)
                .blur(radius: 2)

            Circle()
                .trim(from: 0.56, to: 0.70)
                .stroke(
                    Color.white.opacity(0.18),
                    style: StrokeStyle(lineWidth: diameter * 0.018, lineCap: .round)
                )
                .frame(width: diameter * 0.72, height: diameter * 0.72)
                .blur(radius: 4)

            Circle()
                .stroke(
                    AngularGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.65), location: 0.0),
                            .init(color: Color.white.opacity(0.30), location: 0.22),
                            .init(color: Color.white.opacity(0.08), location: 0.45),
                            .init(color: Color.white.opacity(0.08), location: 0.7),
                            .init(color: Color.white.opacity(0.35), location: 0.9),
                            .init(color: Color.white.opacity(0.65), location: 1.0),
                        ],
                        center: .center,
                        startAngle: .degrees(-60),
                        endAngle: .degrees(300)
                    ),
                    lineWidth: 1
                )
                .frame(width: diameter, height: diameter)

            Circle()
                .stroke(
                    AngularGradient(
                        stops: [
                            .init(color: Color.black.opacity(0.06), location: 0.0),
                            .init(color: Color.black.opacity(0.02), location: 0.22),
                            .init(color: Color.black.opacity(0.08), location: 0.5),
                            .init(color: Color.black.opacity(0.10), location: 0.72),
                            .init(color: Color.black.opacity(0.04), location: 0.9),
                            .init(color: Color.black.opacity(0.06), location: 1.0),
                        ],
                        center: .center,
                        startAngle: .degrees(-60),
                        endAngle: .degrees(300)
                    ),
                    lineWidth: 1
                )
                .frame(width: diameter + 2, height: diameter + 2)
        }
    }

    // MARK: - Glass Hand

    @ViewBuilder
    private func glassHand(length: CGFloat, width: CGFloat, angle: Angle) -> some View {
        let handColor = isDark
            ? Color.white
            : Color(white: 0.15)

        ClockHandShape()
            .fill(
                LinearGradient(
                    colors: isDark
                        ? [
                            handColor.opacity(0.78),
                            handColor.opacity(0.55),
                            Color(white: 0.5).opacity(0.45),
                        ]
                        : [
                            handColor.opacity(0.72),
                            handColor.opacity(0.52),
                            Color(white: 0.4).opacity(0.38),
                        ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: width, height: length)
            .overlay {
                ClockHandShape()
                    .strokeBorder(
                        LinearGradient(
                            colors: isDark
                                ? [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.15),
                                ]
                                : [
                                    Color.white.opacity(0.8),
                                    Color.black.opacity(0.08),
                                ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .shadow(
                color: .black.opacity(isDark ? 0.3 : 0.15),
                radius: isDark ? 3 : 2,
                x: 1, y: 2
            )
            .offset(y: -length / 2)
            .rotationEffect(angle)
    }
}

// MARK: - Clock Hand Shape

struct ClockHandShape: InsettableShape {
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        let r = rect.insetBy(dx: insetAmount, dy: insetAmount)
        let radius = r.width / 2

        var path = Path()
        path.move(to: CGPoint(x: r.minX, y: r.maxY))
        path.addLine(to: CGPoint(x: r.minX, y: r.minY + radius))
        path.addArc(
            center: CGPoint(x: r.midX, y: r.minY + radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: r.maxX, y: r.maxY))
        path.closeSubpath()

        return path
    }

    func inset(by amount: CGFloat) -> ClockHandShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}
