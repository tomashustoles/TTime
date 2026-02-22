//
//  MapBackgroundView.swift
//  TTime
//

import SwiftUI
import MapKit

struct MapBackgroundView: View {
    let isDark: Bool

    @State private var position: MapCameraPosition = .userLocation(
        fallback: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 50.0755, longitude: 14.4378),
            span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        ))
    )

    var body: some View {
        Map(position: $position, interactionModes: []) {
        }
        .mapStyle(.standard(
            emphasis: .muted,
            pointsOfInterest: .excludingAll,
            showsTraffic: false
        ))
        .environment(\.colorScheme, isDark ? .dark : .light)
        .compositingGroup()
        .saturation(0)
        .contrast(isDark ? 0.55 : 0.3)
        .brightness(isDark ? -0.35 : 0.35)
        .allowsHitTesting(false)
        .focusable(false)
    }
}
