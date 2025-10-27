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

    @State var target: MarketingTarget

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D.zero,
                                                   span: .init(latitudeDelta: 0.0125, longitudeDelta: 0.0125))

    var body : some View {
        Map {
            #if false
            Marker(target.address.streetAddress, systemImage: "house.fill", coordinate: .home)
            #else
            Annotation(target.address.streetAddress, coordinate: target.location?.coordinate2D ?? .home, anchor: .bottom) {
                Image(systemName: "house.fill")
                    .padding(4)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .cornerRadius(4)
            }
            .annotationTitles(.automatic)
            #endif
        }
        .mapStyle(.standard)
        .onAppear {
            Task { @MainActor in
                do {
                    let coord = try await geocodeWithMapKit(address: target.address)
                    target.updateLocation(with: coord)
                    region.center = coord
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

extension CLLocationCoordinate2D {
    static let home = CLLocationCoordinate2D(latitude: 32.47765, longitude: -110.91509)
    static let zero = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
}
