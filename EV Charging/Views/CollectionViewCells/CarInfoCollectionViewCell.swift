//
//  CarInfoCollectionViewCell.swift
//  EV Charging
//
//  Created by Olivier Miserez on 08/09/2024.
//

import UIKit

class CarInfoCollectionViewCell: CustomCollectionViewCell {
    var viewModel: CollectionViewViewModel?
    
    private lazy var carTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "car title label"
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
    
    private lazy var motorLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "motor label"
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
    
    private func setupViews() {
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = Colors.blue.cgColor
        
        contentView.addSubview(carTitleLabel)
        NSLayoutConstraint.activate([
            carTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding.large),
            carTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding.large),
            carTitleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        contentView.addSubview(motorLabel)
        NSLayoutConstraint.activate([
            motorLabel.topAnchor.constraint(equalTo: carTitleLabel.bottomAnchor, constant: padding.large),
            motorLabel.leadingAnchor.constraint(equalTo: carTitleLabel.leadingAnchor),
            motorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding.large)
        ])
        
        contentView.addSubview(seperatorLabel)
        NSLayoutConstraint.activate([
            seperatorLabel.centerYAnchor.constraint(equalTo: motorLabel.centerYAnchor),
            seperatorLabel.leadingAnchor.constraint(equalTo: motorLabel.trailingAnchor, constant: 10)
        ])
        
        contentView.addSubview(batterySizePrimaryLabel)
        NSLayoutConstraint.activate([
            batterySizePrimaryLabel.bottomAnchor.constraint(equalTo: motorLabel.bottomAnchor),
            batterySizePrimaryLabel.leadingAnchor.constraint(equalTo: seperatorLabel.trailingAnchor, constant: 10)
        ])
        
        contentView.addSubview(batterySizeSecondaryLabel)
        NSLayoutConstraint.activate([
            batterySizeSecondaryLabel.topAnchor.constraint(equalTo: motorLabel.topAnchor),
            batterySizeSecondaryLabel.leadingAnchor.constraint(equalTo: batterySizePrimaryLabel.trailingAnchor, constant: 10)
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
        motorLabel.text = text
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
