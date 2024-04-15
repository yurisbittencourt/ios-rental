
import Foundation
import SwiftUI
import MapKit

struct MapRepresentable: UIViewRepresentable {
    
    @ObservedObject var mapViewModel = MapViewModel(location: nil, properties: [], radius: 1000)
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isUserInteractionEnabled = true
        map.showsUserLocation = true
        map.delegate = mapViewModel
        
        if let location = mapViewModel.location {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            map.setRegion(region, animated: true)
            
            let circle = MKCircle(center: location.coordinate, radius: mapViewModel.radius)
            map.addOverlay(circle)
        } else {
            let defaultLocation = CLLocationCoordinate2D(latitude: 43.64732, longitude: -79.38279)
            let region = MKCoordinateRegion(center: defaultLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            map.setRegion(region, animated: true)
            
            let circle = MKCircle(center: defaultLocation, radius: mapViewModel.radius)
            map.addOverlay(circle)
        }
        
        for property in mapViewModel.properties {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: property.lat, longitude: property.lon)
            annotation.title = property.title
            map.addAnnotation(annotation)
        }
        
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let map = uiView
        map.mapType = .standard
        map.isZoomEnabled = true
        map.isUserInteractionEnabled = true
        map.showsUserLocation = true
        map.delegate = mapViewModel
        map.removeOverlays(map.overlays)
        
        if let location = mapViewModel.location {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            map.setRegion(region, animated: true)
            
            let circle = MKCircle(center: location.coordinate, radius: mapViewModel.radius)
            map.addOverlay(circle)
        } else {
            let defaultLocation = CLLocationCoordinate2D(latitude: 43.64732, longitude: -79.38279)
            let region = MKCoordinateRegion(center: defaultLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            map.setRegion(region, animated: true)
            
            let circle = MKCircle(center: defaultLocation, radius: mapViewModel.radius)
            map.addOverlay(circle)
        }
    }
    
    typealias UIViewType = MKMapView
}
