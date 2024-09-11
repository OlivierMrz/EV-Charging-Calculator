//
//  ChargingPercentageCollectionViewCell.swift
//  EV Charging
//
//  Created by Olivier Miserez on 08/09/2024.
//

import UIKit

protocol sliderMovementDelegate {
    func isSliderMoving(bool: Bool)
}

enum SliderTypeString: String {
    case current, target
    
    var description: String {
        switch self {
        case .current:
            return "current"
        case .target:
            return "target"
        }
    }
}

class ChargingPercentageCollectionViewCell: OMCustomCollectionView {
    var viewModel: CollectionViewViewModel?

    private lazy var currentSoCView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currentSoCLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Current SoC"
        label.text = label.text?.capitalized
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentPercentageLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "20 %"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currentSoCSlider: Slider = {
        let slider: Slider = .init(slider: ThumblessSlider(
            direction: .bottomToTop,
            scaling: .none,
            cornerRadius: .fixed(21)
        ))
        slider.sliderDataSource = self
        slider.tintColor = Colors.green
        slider.viewModel.sliderName = SliderTypeString.current.rawValue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var targetSoCView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var targetSoCLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Target SoC"
        label.text = label.text?.capitalized
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var targetPercentageLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "80 %"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var targetSoCSlider: Slider = {
        let slider: Slider = .init(slider: ThumblessSlider(
            direction: .bottomToTop,
            scaling: .none,
            cornerRadius: .fixed(21)
        ))
        slider.viewModel.value = 80
        slider.sliderDataSource = self
        slider.tintColor = Colors.green
        slider.viewModel.sliderName = SliderTypeString.target.rawValue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var sliderMovementDelegate: sliderMovementDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    internal func setupViews() {
        contentView.backgroundColor = .clear
        
        // Current Slider View
        contentView.addSubview(currentSoCView)
        NSLayoutConstraint.activate([
            currentSoCView.topAnchor.constraint(equalTo: contentView.topAnchor),
            currentSoCView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currentSoCView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            currentSoCView.widthAnchor.constraint(equalToConstant: (self.contentView.frame.width / 2) - padding.large),
        ])
        
        currentSoCView.addSubview(currentSoCLabel)
        NSLayoutConstraint.activate([
            currentSoCLabel.topAnchor.constraint(equalTo: currentSoCView.topAnchor, constant: padding.default),
            currentSoCLabel.centerXAnchor.constraint(equalTo: currentSoCView.centerXAnchor)
        ])
        
        currentSoCView.addSubview(currentPercentageLabel)
        NSLayoutConstraint.activate([
            currentPercentageLabel.topAnchor.constraint(equalTo: currentSoCLabel.bottomAnchor, constant: padding.default),
            currentPercentageLabel.centerXAnchor.constraint(equalTo: currentSoCView.centerXAnchor)
        ])
        
        currentSoCView.addSubview(currentSoCSlider)
        NSLayoutConstraint.activate([
            currentSoCSlider.topAnchor.constraint(equalTo: currentPercentageLabel.bottomAnchor, constant: padding.default),
            currentSoCSlider.widthAnchor.constraint(equalToConstant: 80),
            currentSoCSlider.heightAnchor.constraint(equalToConstant: 200),
            currentSoCSlider.centerXAnchor.constraint(equalTo: currentSoCView.centerXAnchor),
            currentSoCSlider.bottomAnchor.constraint(equalTo: currentSoCView.bottomAnchor, constant: -padding.large)
        ])
        
        // Target Slider View
        contentView.addSubview(targetSoCView)
        NSLayoutConstraint.activate([
            targetSoCView.topAnchor.constraint(equalTo: contentView.topAnchor),
            targetSoCView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            targetSoCView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            targetSoCView.widthAnchor.constraint(equalToConstant: (self.contentView.frame.width / 2) - padding.large),
        ])
        
        targetSoCView.addSubview(targetSoCLabel)
        NSLayoutConstraint.activate([
            targetSoCLabel.topAnchor.constraint(equalTo: targetSoCView.topAnchor, constant: padding.default),
            targetSoCLabel.centerXAnchor.constraint(equalTo: targetSoCView.centerXAnchor)
        ])
        
        targetSoCView.addSubview(targetPercentageLabel)
        NSLayoutConstraint.activate([
            targetPercentageLabel.topAnchor.constraint(equalTo: targetSoCLabel.bottomAnchor, constant: padding.default),
            targetPercentageLabel.centerXAnchor.constraint(equalTo: targetSoCView.centerXAnchor)
        ])
        
        targetSoCView.addSubview(targetSoCSlider)
        NSLayoutConstraint.activate([
            targetSoCSlider.topAnchor.constraint(equalTo: targetPercentageLabel.bottomAnchor, constant: padding.default),
            targetSoCSlider.widthAnchor.constraint(equalToConstant: 80),
            targetSoCSlider.heightAnchor.constraint(equalToConstant: 200),
            targetSoCSlider.centerXAnchor.constraint(equalTo: targetSoCView.centerXAnchor),
            targetSoCSlider.bottomAnchor.constraint(equalTo: targetSoCView.bottomAnchor, constant: -padding.large)
        ])
        
        updateData()
    }
    
    func configure(viewModel: CollectionViewViewModel?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel
        // configure all propties
    }
    
    func updateData() {
        guard let viewModel = viewModel else { return }

        currentSoCSlider.viewModel.value = viewModel.currentSoCValue
        currentPercentageLabel.text = "\(String(format: "%.0f", viewModel.currentSoCValue)) %"
        targetSoCSlider.viewModel.value = viewModel.targetSoCValue
        targetPercentageLabel.text = "\(String(format: "%.0f", viewModel.targetSoCValue)) %"
        
        viewModel.calculateChargingCost()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChargingPercentageCollectionViewCell: ReuseIdentifying {}

extension ChargingPercentageCollectionViewCell: SliderDelegate {
    func valueDidChange(newValue: Double, for cell: String) {
        guard let cellType = SliderTypeString(rawValue: cell) else { return }
        
        switch cellType {
        case .current:
            if newValue > Double(viewModel!.targetSoCValue) {
                return
            }
            self.viewModel?.setCurrentSoC(value: newValue)
            updateData()
        case .target:
            if newValue < Double(viewModel!.currentSoCValue) {
                return
            }
            self.viewModel?.setTargetSoC(value: newValue)
            updateData()
        }
    }

    func movementTracking(changed: SliderMovementTrackingChanged) {        
        sliderMovementDelegate?.isSliderMoving(bool: changed == .began ? false : true)
    }
}
