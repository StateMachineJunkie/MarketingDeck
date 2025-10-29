//
//  MapView.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/27/25.
//

import MapKit
import SwiftUI

struct MapView: View {

    enum Error: Swift.Error {
        case noLocation
    }

    static private let defaultRegion: MKCoordinateRegion = .init(center: .zero, latitudinalMeters: 10000, longitudinalMeters: 10000)

    @Bindable var target: MarketingTarget

    @State private var cameraPosition: MapCameraPosition = .region(defaultRegion)
    @State private var coordinate: CLLocationCoordinate2D?

    var body : some View {
        Map(position: $cameraPosition, interactionModes: .all) {
            if let coord = target.location?.coordinate2D {
                Annotation("\(target.name)", coordinate: coord, anchor: .bottom) {
                    TargetView(label: target.address.streetAddress)
                }
            } else { // Fallback to a default location until geocoding completes
                Annotation("", coordinate: .zero, anchor: .bottom) {
                    TargetView(label: target.address.streetAddress)
                }
            }
        }
        .mapStyle(.standard)
        .onAppear {
            Task { @MainActor in
                guard target.location == nil else {
                    cameraPosition = .region(MKCoordinateRegion(center: target.location!.coordinate2D,
                                                                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                    return
                }
                do {
                    let coord = try await geocodeWithMapKit(address: target.address)
                    target.updateLocation(with: coord)
                    coordinate = coord
                    withAnimation(.easeOut) {
                        cameraPosition = .region(MKCoordinateRegion(center: coord,
                                                                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                    }
                } catch {
                    // TODO: Display error on map!
                }
            }
        }
    }

    private func geocodeWithMapKit(address: Address) async throws -> CLLocationCoordinate2D {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address.description
        // Optionally, you can bias the search to the current region
        request.resultTypes = [.address]

        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start()
            if let mapItem = response.mapItems.first {
                return mapItem.location.coordinate
            } else {
                throw Error.noLocation
            }
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
