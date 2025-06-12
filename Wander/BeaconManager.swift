import Foundation
import CoreLocation

/// Handles Bluetooth beacon ranging with graceful permission checks.
@MainActor
final class BeaconManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var detectedBeacons: [CLBeacon] = []
    private var region: CLBeaconRegion?

    override init() {
        super.init()
        manager.delegate = self
    }

    /// Configure a beacon region using the provided UUID.
    func configure(uuidString: String, identifier: String) {
        guard let uuid = UUID(uuidString: uuidString) else { return }
        region = CLBeaconRegion(uuid: uuid, identifier: identifier)
    }

    /// Start ranging for beacons if authorized.
    func startRanging() {
        requestAuthorization()
        guard let region else { return }
        manager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: region.uuid))
    }

    private func requestAuthorization() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        detectedBeacons = beacons
    }
}
