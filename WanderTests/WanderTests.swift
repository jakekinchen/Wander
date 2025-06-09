//
//  WanderTests.swift
//  WanderTests
//
//  Created by Jake Kinchen on 10/13/24.
//

import Testing
import CoreLocation
@testable import Wander

struct WanderTests {

    @Test func example() async throws {
        // Example placeholder test
    }

    @Test func localInformationServiceReturnsEmptyOnLinux() async throws {
        #if os(Linux)
        let service = LocalInformationService()
        let pois = try await service.fetchNearbyPoints(for: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        #expect(pois.isEmpty)
        #endif
    }
}
