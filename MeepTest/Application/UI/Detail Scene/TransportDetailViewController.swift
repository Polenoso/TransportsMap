//
//  TransportDetailViewController.swift
//  MeepTest
//
//  Created by Aitor on 04/12/2020.
//

import UIKit

final class TransportDetailViewController: UIViewController {
    private var mainView: TransportDetailView { view as! TransportDetailView }
    
    var input: TransportDetailInput?
    
    override func loadView() {
        super.loadView()
        view = TransportDetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        guard let input = input else { return }
        mainView.apply(state: input.viewState)
    }
}

extension TransportDetailViewController: TransportDetailViewDelegate {
    func didTapClose() {
        input?.onCloseTap()
    }
}
