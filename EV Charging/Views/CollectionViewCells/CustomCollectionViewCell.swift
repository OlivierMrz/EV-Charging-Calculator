//
//  CustomCollectionViewCell.swift
//  EV Charging
//
//  Created by Olivier Miserez on 08/09/2024.
//

import UIKit

protocol CustomCollectionViewProtocol {
    func setupViews()
    func updateData()
    func configure(viewModel: CollectionViewViewModel?)
}

typealias OMCustomCollectionView = CustomCollectionViewCell & CustomCollectionViewProtocol

class CustomCollectionViewCell: UICollectionViewCell {
    typealias padding = Design.Padding
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = Colors.white
        contentView.layer.cornerRadius = Design.cornerRadius.default
        contentView.layer.masksToBounds = true
        contentView.layer.cornerCurve = .continuous
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: padding.default),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.default),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.default),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.default)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
