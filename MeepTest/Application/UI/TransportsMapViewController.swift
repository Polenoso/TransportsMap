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
//        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MKPinAnnotationView")
        guard let center = input?.mapRegion.center else { return }
        mapView.region = .init(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
}

extension TransportsMapViewController: TransportsMapOutput {
    func stateChanged() {
        guard let input = input else { return }
        mapView.showAnnotations(input.transports.map(\.annotation), animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension TransportsMapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        mapView.dequeueReusableAnnotationView(withIdentifier: "MKPinAnnotationView", for: annotation)
//    }
}

class PinView: MKAnnotationView {
    static let reuseIdentifier: String = "PinViewReuseIdentifier"
}
