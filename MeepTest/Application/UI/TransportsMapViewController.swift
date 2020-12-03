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
        guard let center = input?.mapRegion.center else { return }
        mapView.region = .init(center: center, span: MKCoordinateSpan())
    }
}

extension TransportsMapViewController: TransportsMapOutput {
    func stateChanged() {
        guard let input = input else { return }
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(input.transports.map(\.annotation))
    }
}

// MARK: - MKMapViewDelegate

extension TransportsMapViewController: MKMapViewDelegate { }
