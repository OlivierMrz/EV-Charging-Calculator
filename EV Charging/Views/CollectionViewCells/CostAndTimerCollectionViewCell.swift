//
//  CostAndTimerCollectionViewCell.swift
//  EV Charging
//
//  Created by Olivier Miserez on 10/09/2024.
//

import UIKit

class CostAndTimerCollectionViewCell: CustomCollectionViewCell {
    var viewModel: CollectionViewViewModel?
    
    private lazy var estimateChargingCostLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Estimate Charging Cost"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var estimateChargingCostValueView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.green
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var estimateChargingCostValueLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "53.06"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var estimateChargingTimeLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Estimate Charging time"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = .zero
        
        contentView.addSubview(estimateChargingCostLabel)
        NSLayoutConstraint.activate([
            estimateChargingCostLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            estimateChargingCostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        ])

        contentView.addSubview(estimateChargingCostValueView)
        NSLayoutConstraint.activate([
            estimateChargingCostValueView.topAnchor.constraint(equalTo: estimateChargingCostLabel.bottomAnchor, constant: padding.default),
            estimateChargingCostValueView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding.large),
            estimateChargingCostValueView.widthAnchor.constraint(equalToConstant: 180),
            estimateChargingCostValueView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        estimateChargingCostValueView.addSubview(estimateChargingCostValueLabel)
        NSLayoutConstraint.activate([
            estimateChargingCostValueLabel.centerXAnchor.constraint(equalTo: estimateChargingCostValueView.centerXAnchor),
            estimateChargingCostValueLabel.centerYAnchor.constraint(equalTo: estimateChargingCostValueView.centerYAnchor)
        ])
        
        contentView.addSubview(estimateChargingTimeLabel)
        NSLayoutConstraint.activate([
            estimateChargingTimeLabel.topAnchor.constraint(equalTo: estimateChargingCostValueView.bottomAnchor, constant: padding.large),
            estimateChargingTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            
            estimateChargingTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    func updateData() {
        guard let viewModel = viewModel else { return }

        estimateChargingCostValueLabel.text = String(format: "%.2f", viewModel.estimateChargingCost)
//        currentSoCSlider.viewModel.value = viewModel.currentSoCValue
//        currentPercentageLabel.text = "\(String(format: "%.0f", viewModel.currentSoCValue)) %"
//        targetSoCSlider.viewModel.value = viewModel.targetSoCValue
//        targetPercentageLabel.text = "\(String(format: "%.0f", viewModel.targetSoCValue)) %"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CostAndTimerCollectionViewCell: ReuseIdentifying {}
