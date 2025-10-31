//
//  TargetLookAroundView.swift
//  MarketingDeck
//
//  Created by Michael Crawford on 10/30/25.
//

import MapKit
import SwiftUI

struct TargetLookAroundView: View {

    var coordinate: CLLocationCoordinate2D

    @State private var lookAroundScene: MKLookAroundScene?

    var body: some View {
        VStack {
            LookAroundPreview(initialScene: lookAroundScene)
        }
        .onAppear {
            getLookAroundScene()
        }
    }

    private func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(coordinate: coordinate)
            lookAroundScene = try? await request.scene
        }
    }
}
