//
//  MapView.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/27/25.
//

import MapKit
import SwiftUI

struct MapView: View {

    static private let defaultRegion: MKCoordinateRegion = .init(center: .zero, latitudinalMeters: 10000, longitudinalMeters: 10000)

    var target: MarketingTarget

    @State private var cameraPosition: MapCameraPosition = .region(defaultRegion)

    var body : some View {
        Map(position: $cameraPosition, interactionModes: .all) {
            Annotation("\(target.name)", coordinate: target.location!.coordinate2D, anchor: .bottom) {
                TargetView(label: target.address.streetAddress)
            }
        }
        .mapStyle(.standard)
        .mapControls {
            // If no map controls are specified the compass and scale will be included by default. By specifying the
            // user-location button, the defaults are overridden so you have to specify every option you want or you
            // will not get them.
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .onAppear {
            cameraPosition = .region(MKCoordinateRegion(center: target.location!.coordinate2D,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
        }
    }
}

private struct TargetView: View {

    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: "house.fill")
                .padding(4)
                .foregroundStyle(.white)
                .background(.blue)
                .cornerRadius(4)
            Text(label)
                .font(.caption2)
                .padding(2)
                .background(.thinMaterial)
                .cornerRadius(3)
        }
    }
}

extension CLLocationCoordinate2D {
    static let home = CLLocationCoordinate2D(latitude: 32.47765, longitude: -110.91509)
    static let zero = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
}
