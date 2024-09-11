//
//  ChargingPowerAndCostCollectionViewCell.swift
//  EV Charging
//
//  Created by Olivier Miserez on 09/09/2024.
//

import UIKit

protocol ChargingPowerAndCostCellDelegate {
    func additionalViewTapped(isNoFeeSelected: Bool)
    func ChargingKWOrChargingCostSliderMoved()
}

class ChargingPowerAndCostCollectionViewCell: CustomCollectionViewCell {
    var delegate: ChargingPowerAndCostCellDelegate?
    var viewModel: CollectionViewViewModel?
    
    private lazy var powerCostView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var chargingAtLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Charging at"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chargingAtValueLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "100.0"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var kwLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Kw"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var kwSlider: UISlider = {
        let slider: UISlider = .init()
        let image = UIImage(named: "thumb_bolt")
        slider.minimumValue = 0
        slider.maximumValue = 250
        slider.value = 100
        slider.tintColor = Colors.green
        slider.addTarget(self, action: #selector(kwSliderValueChanged(sender:)), for: .allEvents)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var chargingCostLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Charging cost"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var chargingCostValueLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "0.69"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var kwhLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "/ kWh"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var kwhSlider: UISlider = {
        let slider: UISlider = .init()
        slider.minimumValue = 0
        slider.maximumValue = 2
        slider.value = 0.69
        slider.tintColor = Colors.green
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(kwhSliderValueChanged(sender:)), for: .allEvents)
        return slider
    }()
    
    private lazy var infoIconButton: UIButton = {
        let button: UIButton = .init()
        let image: UIImage = .init(systemName: "info.circle", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30))) ?? UIImage()
        button.tintColor = Colors.blue
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var noFeeView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = Colors.green.cgColor
        view.layer.borderWidth = 1.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(feeValidationTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 1
        view.alpha = 1
        return view
    }()
    
    private lazy var noFeeLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "No Fee"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var oneTimeFeeView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = Colors.white.cgColor
        view.layer.borderWidth = 1.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(feeValidationTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 2
        view.alpha = 0.5
        return view
    }()
    
    private lazy var oneTimeFeeLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "1 Time Fee"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var additionalCostView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.white
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = Colors.white.cgColor
        view.layer.borderWidth = 1.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(feeValidationTapped(sender:)))
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = 99
        view.alpha = 0.5
        return view
    }()
    
    private lazy var additionalCostLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Additional Cost"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var additionalCostValueLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        
        // Current Slider View
        contentView.addSubview(powerCostView)
        NSLayoutConstraint.activate([
            powerCostView.topAnchor.constraint(equalTo: contentView.topAnchor),
            powerCostView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            powerCostView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        powerCostView.addSubview(chargingAtLabel)
        NSLayoutConstraint.activate([
            chargingAtLabel.topAnchor.constraint(equalTo: powerCostView.topAnchor, constant: padding.large),
            chargingAtLabel.leadingAnchor.constraint(equalTo: powerCostView.leadingAnchor, constant: padding.default)
        ])
        powerCostView.addSubview(chargingAtValueLabel)
        NSLayoutConstraint.activate([
            chargingAtValueLabel.bottomAnchor.constraint(equalTo: chargingAtLabel.bottomAnchor, constant: 4),
            chargingAtValueLabel.leadingAnchor.constraint(equalTo: chargingAtLabel.trailingAnchor, constant: 10)
        ])
        powerCostView.addSubview(kwLabel)
        NSLayoutConstraint.activate([
            kwLabel.bottomAnchor.constraint(equalTo: chargingAtLabel.bottomAnchor),
            kwLabel.leadingAnchor.constraint(equalTo: chargingAtValueLabel.trailingAnchor, constant: 10)
        ])
        
        powerCostView.addSubview(kwSlider)
        NSLayoutConstraint.activate([
            kwSlider.topAnchor.constraint(equalTo: chargingAtLabel.bottomAnchor, constant: padding.default),
            kwSlider.leadingAnchor.constraint(equalTo: powerCostView.leadingAnchor, constant: padding.default),
            kwSlider.trailingAnchor.constraint(equalTo: powerCostView.trailingAnchor, constant: -padding.default)
        ])
        
        
        powerCostView.addSubview(chargingCostLabel)
        NSLayoutConstraint.activate([
            chargingCostLabel.topAnchor.constraint(equalTo: kwSlider.bottomAnchor, constant: padding.large),
            chargingCostLabel.leadingAnchor.constraint(equalTo: powerCostView.leadingAnchor, constant: padding.default)
        ])
        powerCostView.addSubview(chargingCostValueLabel)
        NSLayoutConstraint.activate([
            chargingCostValueLabel.bottomAnchor.constraint(equalTo: chargingCostLabel.bottomAnchor, constant: 4),
            chargingCostValueLabel.leadingAnchor.constraint(equalTo: chargingCostLabel.trailingAnchor, constant: 10)
        ])
        powerCostView.addSubview(kwhLabel)
        NSLayoutConstraint.activate([
            kwhLabel.bottomAnchor.constraint(equalTo: chargingCostLabel.bottomAnchor),
            kwhLabel.leadingAnchor.constraint(equalTo: chargingCostValueLabel.trailingAnchor, constant: 10)
        ])
        
        powerCostView.addSubview(kwhSlider)
        NSLayoutConstraint.activate([
            kwhSlider.topAnchor.constraint(equalTo: chargingCostLabel.bottomAnchor, constant: padding.default),
            kwhSlider.leadingAnchor.constraint(equalTo: powerCostView.leadingAnchor, constant: padding.default),
            kwhSlider.trailingAnchor.constraint(equalTo: powerCostView.trailingAnchor, constant: -padding.default),
            kwhSlider.bottomAnchor.constraint(equalTo: powerCostView.bottomAnchor, constant: -padding.large)
        ])
        
        powerCostView.addSubview(infoIconButton)
        NSLayoutConstraint.activate([
            infoIconButton.topAnchor.constraint(equalTo: powerCostView.topAnchor, constant: padding.default),
            infoIconButton.trailingAnchor.constraint(equalTo: powerCostView.trailingAnchor, constant: -padding.default),
            infoIconButton.widthAnchor.constraint(equalToConstant: 30),
            infoIconButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // No Fee View
        noFeeView.addSubview(noFeeLabel)
        contentView.addSubview(noFeeView)
        NSLayoutConstraint.activate([
            noFeeLabel.centerXAnchor.constraint(equalTo: noFeeView.centerXAnchor),
            noFeeLabel.centerYAnchor.constraint(equalTo: noFeeView.centerYAnchor),
            noFeeLabel.widthAnchor.constraint(equalToConstant: 50),
            noFeeView.topAnchor.constraint(equalTo: powerCostView.bottomAnchor, constant: padding.default),
            noFeeView.leadingAnchor.constraint(equalTo: powerCostView.leadingAnchor, constant: 0),
            noFeeView.widthAnchor.constraint(equalToConstant: 80),
            noFeeView.heightAnchor.constraint(equalToConstant: 80),
            noFeeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // 1 Time Fee View
        oneTimeFeeView.addSubview(oneTimeFeeLabel)
        contentView.addSubview(oneTimeFeeView)
        NSLayoutConstraint.activate([
            oneTimeFeeLabel.centerXAnchor.constraint(equalTo: oneTimeFeeView.centerXAnchor),
            oneTimeFeeLabel.centerYAnchor.constraint(equalTo: oneTimeFeeView.centerYAnchor),
            oneTimeFeeLabel.widthAnchor.constraint(equalToConstant: 50),
            oneTimeFeeView.topAnchor.constraint(equalTo: noFeeView.topAnchor),
            oneTimeFeeView.leadingAnchor.constraint(equalTo: noFeeView.trailingAnchor, constant: padding.default),
            oneTimeFeeView.widthAnchor.constraint(equalToConstant: 80),
            oneTimeFeeView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Additional Cost View
        let additionalCostStackView: UIStackView = .init(arrangedSubviews: [additionalCostLabel, additionalCostValueLabel])
        additionalCostStackView.alignment = .center
        additionalCostStackView.axis = .vertical
        additionalCostStackView.translatesAutoresizingMaskIntoConstraints = false
        
        additionalCostView.addSubview(additionalCostStackView)
        contentView.addSubview(additionalCostView)
        NSLayoutConstraint.activate([
            additionalCostStackView.centerYAnchor.constraint(equalTo: additionalCostView.centerYAnchor),
            additionalCostStackView.centerXAnchor.constraint(equalTo: additionalCostView.centerXAnchor),
            
            additionalCostView.topAnchor.constraint(equalTo: oneTimeFeeView.topAnchor),
            additionalCostView.leadingAnchor.constraint(equalTo: oneTimeFeeView.trailingAnchor, constant: padding.default),
            additionalCostView.trailingAnchor.constraint(equalTo: powerCostView.trailingAnchor),
            additionalCostView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func updateData() {
        additionalCostValueLabel.text = "\(String(format: "%.2f", self.viewModel?.additionalCost ?? 0.0))"
        chargingAtValueLabel.text = "\(String(format: "%.1f", self.viewModel?.chargingSpeed ?? 0.0))"
        chargingCostValueLabel.text = "\(String(format: "%.2f", self.viewModel?.chargingCost ?? 0.0))"
        
        viewModel?.calculateChargingCost()
    }
    
    @objc private func feeValidationTapped(sender: UITapGestureRecognizer) {
        guard let tag = sender.view?.tag else { return }
        
        switch tag {
        case 2, 99:
            print("1 Fee view tapped / additional cost tapped")
            noFeeView.layer.borderColor = Colors.white.cgColor
            noFeeView.alpha = 0.5
            oneTimeFeeView.layer.borderColor = Colors.green.cgColor
            oneTimeFeeView.alpha = 1
            additionalCostView.layer.borderColor = Colors.white.cgColor
            additionalCostView.alpha = 1
            viewModel?.setIsNoFeeSelected(value: false)
            delegate?.additionalViewTapped(isNoFeeSelected: false)
        default:
            print("No Fee view tapped / default")
            noFeeView.layer.borderColor = Colors.green.cgColor
            noFeeView.alpha = 1
            oneTimeFeeView.layer.borderColor = Colors.white.cgColor
            oneTimeFeeView.alpha = 0.5
            additionalCostView.layer.borderColor = Colors.white.cgColor
            additionalCostView.alpha = 0.5
            viewModel?.setIsNoFeeSelected(value: true)
            delegate?.additionalViewTapped(isNoFeeSelected: true)
        }
    }
    
    @objc private func kwSliderValueChanged(sender: UISlider) {
        viewModel?.setChargingSpeed(value: Double(sender.value))
        updateData()
        delegate?.ChargingKWOrChargingCostSliderMoved()
    }
    
    @objc private func kwhSliderValueChanged(sender: UISlider) {
        viewModel?.setChargingCost(value: Double(sender.value))
        updateData()
        delegate?.ChargingKWOrChargingCostSliderMoved()
    }
    
    @objc private func infoButtonTapped() {
        print("info button tapped")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChargingPowerAndCostCollectionViewCell: ReuseIdentifying {}
