//
//  CarInfoCollectionViewCell.swift
//  EV Charging
//
//  Created by Olivier Miserez on 08/09/2024.
//

import UIKit

class CarInfoCollectionViewCell: OMCustomCollectionView {
    var viewModel: CollectionViewViewModel?
    
    private lazy var carTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
//        label.text = "Tesla Model Y"
        label.text = label.text?.capitalized
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var carImageView: UIImageView = {
        let imageView: UIImageView = .init()
        let iconImage: UIImage = .init(named: "car_icon")!
        imageView.image = iconImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var engineLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
//        label.text = "Long Range Dual Motor"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.text = label.text?.capitalized
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var seperatorLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var batterySizePrimaryLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var batterySizeSecondaryLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "kWh"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    internal func setupViews() {
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = Colors.blue.cgColor
        
        contentView.addSubview(carTitleLabel)
        NSLayoutConstraint.activate([
            carTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.large),
            carTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding.large),
            carTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        contentView.addSubview(engineLabel)
        NSLayoutConstraint.activate([
            engineLabel.topAnchor.constraint(equalTo: carTitleLabel.bottomAnchor, constant: padding.large),
            engineLabel.leadingAnchor.constraint(equalTo: carTitleLabel.leadingAnchor),
            engineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding.large)
        ])
        
        contentView.addSubview(seperatorLabel)
        NSLayoutConstraint.activate([
            seperatorLabel.centerYAnchor.constraint(equalTo: engineLabel.centerYAnchor),
            seperatorLabel.leadingAnchor.constraint(equalTo: engineLabel.trailingAnchor, constant: 5)
        ])
        
        contentView.addSubview(batterySizePrimaryLabel)
        NSLayoutConstraint.activate([
            batterySizePrimaryLabel.bottomAnchor.constraint(equalTo: engineLabel.bottomAnchor),
            batterySizePrimaryLabel.leadingAnchor.constraint(equalTo: seperatorLabel.trailingAnchor, constant: 5)
        ])
        
        contentView.addSubview(batterySizeSecondaryLabel)
        NSLayoutConstraint.activate([
            batterySizeSecondaryLabel.topAnchor.constraint(equalTo: engineLabel.topAnchor),
            batterySizeSecondaryLabel.leadingAnchor.constraint(equalTo: batterySizePrimaryLabel.trailingAnchor, constant: 5)
        ])
        
        contentView.addSubview(carImageView)
        NSLayoutConstraint.activate([
            carImageView.widthAnchor.constraint(equalToConstant: 90),
            carImageView.heightAnchor.constraint(equalToConstant: 90),
            carImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            carImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding.large)
        ])
    }
    
    
    func updateData() {
        guard let viewModel = viewModel else { return }

        batterySizePrimaryLabel.text = "\(viewModel.carBatteryCapacity)"
    }
    
    func setSublabelWith(text: String) {
        engineLabel.text = text
    }
    
    func configure(viewModel: CollectionViewViewModel?) {
        guard let viewModel = viewModel else { return }

        self.viewModel = viewModel
        carTitleLabel.text = viewModel.carName
        engineLabel.text = viewModel.carEngine
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CarInfoCollectionViewCell: ReuseIdentifying {}

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
