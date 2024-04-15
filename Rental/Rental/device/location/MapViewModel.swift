
import Foundation
import SwiftUI
import MapKit

class MapViewModel: NSObject, ObservableObject, MKMapViewDelegate {
    @Published var location: CLLocation?
    @Published var properties: [Property]
    @Published var radius: CLLocationDistance
    
    init(location: CLLocation?, properties: [Property], radius: CLLocationDistance) {
        self.location = location
        self.properties = properties
        self.radius = radius
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.fillColor = UIColor.blue.withAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)
            circleRenderer.lineWidth = 1
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
}
