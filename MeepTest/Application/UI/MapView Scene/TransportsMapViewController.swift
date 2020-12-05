//
//  TransportsMapViewController.swift
//  MeepTest
//
//  Created by Aitor on 02/12/2020.
//

import UIKit
import MapKit

final class TransportsMapViewController: UIViewController {
    private let mapView: MKMapView = MKMapView()
    
    var input: TransportsMapInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [mapView.topAnchor.constraint(equalTo: view.topAnchor),
                           mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                           mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
        NSLayoutConstraint.activate(constraints)
        
        setupMapView()
        
        input?.onLoad()
    }
    
    private func setupMapView() {
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        mapView.register(PinView.self, forAnnotationViewWithReuseIdentifier: "PinViewReuseIdentifier")
        guard let center = input?.mapRegion.center else { return }
        mapView.region = .init(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}

extension TransportsMapViewController: TransportsMapOutput {
    func stateChanged() {
        guard let input = input else { return }
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(input.transportPins.map(\.annotation))
    }
}

// MARK: - MKMapViewDelegate

extension TransportsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: PinView.reuseIdentifier, for: annotation) as? PinView
        guard let pinState = input?.transportPins.first(where: { $0.annotation.coordinate.latitude == annotation.coordinate.latitude && $0.annotation.coordinate.longitude == annotation.coordinate.longitude}) else { return nil }
        
        view?.applyState(pinState)
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
        input?.onPinSelected(coordinate: coordinate)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard !(input?.isLoading ?? false) && !animated else { return }
        let bottomLeft = mapView.convert(CGPoint(x: 0, y: mapView.frame.height),
                                         toCoordinateFrom: mapView)
        let topRight = mapView.convert(CGPoint(x: mapView.frame.width,
                                               y: 0),
                                       toCoordinateFrom: mapView)
        let request = MapViewRegionChangesRequest(center: mapView.centerCoordinate,
                                                  maxY: topRight.latitude,
                                                  minY: bottomLeft.latitude,
                                                  minX: bottomLeft.longitude,
                                                  maxX: topRight.longitude)
        
        input?.onRegionChanged(request: request)
    }
}

class PinView: MKPinAnnotationView {
    static let reuseIdentifier: String = "PinViewReuseIdentifier"
    
    func applyState(_ state: TransportViewState) {
        pinTintColor = state.companyZoneColor
        annotation = state.annotation
        clusteringIdentifier = state.companyCluster
        cluster?.tintColor = state.companyZoneColor
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        collisionMode = .circle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        annotation = nil
        clusteringIdentifier = nil
    }
}
