//
//  TimeAndCostInfoView.swift
//  EV Charging
//
//  Created by Olivier Miserez on 13/09/2024.
//

import Foundation
import UIKit

class TimeAndCostInfoView: UIView {
    private var viewModel: CollectionViewViewModel?
    private let labelWidth: CGFloat = 160
    private var seconds: Int = 0

    private lazy var chargingTimeStaticLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Estimate Charging Time"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var chargingTimeValueView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.green
        view.layer.cornerRadius = Design.cornerRadius.small
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chargingTimeValueLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "00:00:00"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chargingCostStaticLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Estimate Charging Cost"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var chargingCostValueView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.green
        view.layer.cornerRadius = Design.cornerRadius.small
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chargingCostValueLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "0.00"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure(viewModel: CollectionViewViewModel?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel

        chargingCostValueLabel.text = String(format: "%.2f", viewModel.estimateChargingCost)
        self.seconds = viewModel.chargingTimeSeconds
        chargingTimeValueLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func updateData() {
        guard let viewModel = self.viewModel else { return }
        self.viewModel = viewModel

        chargingCostValueLabel.text = String(format: "%.2f", viewModel.estimateChargingCost)
        self.seconds = viewModel.chargingTimeSeconds
        chargingTimeValueLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    private func setupViews() {
        self.backgroundColor = Colors.white
        
        // TIME
        addSubview(chargingTimeStaticLabel)
        NSLayoutConstraint.activate([
            chargingTimeStaticLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            chargingTimeStaticLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -labelWidth / 2),
            chargingTimeStaticLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        chargingTimeValueView.addSubview(chargingTimeValueLabel)
        NSLayoutConstraint.activate([
            chargingTimeValueLabel.centerXAnchor.constraint(equalTo: chargingTimeValueView.centerXAnchor),
            chargingTimeValueLabel.centerYAnchor.constraint(equalTo: chargingTimeValueView.centerYAnchor)
        ])
        addSubview(chargingTimeValueView)
        NSLayoutConstraint.activate([
            chargingTimeValueView.widthAnchor.constraint(equalToConstant: 110),
            chargingTimeValueView.heightAnchor.constraint(equalToConstant: 32),
            chargingTimeValueView.centerXAnchor.constraint(equalTo: chargingTimeStaticLabel.centerXAnchor),
            chargingTimeValueView.topAnchor.constraint(equalTo: chargingTimeStaticLabel.bottomAnchor, constant: 8)
        ])
        
        // COST
        addSubview(chargingCostStaticLabel)
        NSLayoutConstraint.activate([
            chargingCostStaticLabel.widthAnchor.constraint(equalToConstant: labelWidth),
            chargingCostStaticLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: labelWidth / 2),
            chargingCostStaticLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
        
        
        chargingCostValueView.addSubview(chargingCostValueLabel)
        NSLayoutConstraint.activate([
            chargingCostValueLabel.centerXAnchor.constraint(equalTo: chargingCostValueView.centerXAnchor),
            chargingCostValueLabel.centerYAnchor.constraint(equalTo: chargingCostValueView.centerYAnchor)
        ])
        
        addSubview(chargingCostValueView)
        NSLayoutConstraint.activate([
            chargingCostValueView.widthAnchor.constraint(equalToConstant: 110),
            chargingCostValueView.heightAnchor.constraint(equalToConstant: 32),
            chargingCostValueView.centerXAnchor.constraint(equalTo: chargingCostStaticLabel.centerXAnchor),
            chargingCostValueView.topAnchor.constraint(equalTo: chargingCostStaticLabel.bottomAnchor, constant: 8)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
            layer.cornerRadius = 21
            clipsToBounds = true
            layer.shadowRadius = 3
            layer.shadowOpacity = 0.1
            layer.shadowOffset = CGSize(width: 0, height: -1)
            layer.shadowColor = UIColor.gray.cgColor
            layer.masksToBounds = false
    }
    
    private func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
//        let hoursString = String(format:"%02i", hours)
//        let minutesString = String(format:"%02i", minutes)
//        let secondsString = String(format:"%02i", seconds)
        
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}
