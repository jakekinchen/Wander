import Foundation
import CoreLocation
#if canImport(MapKit)
import MapKit
#endif

/// A service responsible for enriching Wander's data by fetching
/// points of interest near a given coordinate.
struct PointOfInterest: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let address: String?
}

final class LocalInformationService {
    /// Search radius in meters. The default of 500m keeps requests localized.
    private let searchRadius: CLLocationDistance = 500

    /// Fetch nearby points of interest for the supplied coordinate.
    /// - Parameters:
    ///   - coordinate: The coordinate to search around.
    ///   - query: Optional query term, defaults to `"landmark"`.
    /// - Returns: An array of points of interest.
    @available(iOS 15.0, *)
    func fetchNearbyPoints(for coordinate: CLLocationCoordinate2D,
                           query: String? = nil) async throws -> [PointOfInterest] {
        #if canImport(MapKit)
        var request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query ?? "landmark"
        request.region = MKCoordinateRegion(center: coordinate,
                                            latitudinalMeters: searchRadius,
                                            longitudinalMeters: searchRadius)
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        return response.mapItems.map {
            PointOfInterest(name: $0.name ?? "Unknown",
                            coordinate: $0.placemark.coordinate,
                            address: $0.placemark.title)
        }
        #else
        // MapKit is unavailable on this platform. Returning an empty array
        // allows the rest of the app to behave deterministically.
        return []
        #endif
    }
}
