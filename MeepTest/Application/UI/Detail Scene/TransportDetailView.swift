//
//  TransportDetailView.swift
//  MeepTest
//
//  Created by Aitor on 04/12/2020.
//

import UIKit

protocol TransportDetailViewDelegate: AnyObject {
    func didTapClose()
}

final class TransportDetailView: UIView {
    weak var delegate: TransportDetailViewDelegate?
    
    private var closeButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            button.setBackgroundImage(UIImage.init(systemName: "xmark.circle.fill"), for: .normal)
        } else {
            button.setTitle("X", for: .normal)
        }
        button.tintColor = .black
        button.backgroundColor = .clear
        return button
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Coordenadas"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var longitudeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var latitudeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var positionStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [latitudeLabel, longitudeLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, infoLabel, positionStack])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 12),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).withPriority(.defaultLow),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func apply(state: TransportDetailViewState) {
        nameLabel.text = state.name
        latitudeLabel.text = state.latitude
        longitudeLabel.text = state.longitude
    }
    
    @objc private func closeButtonTap() {
        delegate?.didTapClose()
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
