//
//  CostAndTimerCollectionViewCell.swift
//  EV Charging
//
//  Created by Olivier Miserez on 10/09/2024.
//

import UIKit

class CostAndTimerCollectionViewCell: OMCustomCollectionView {
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
    
    private lazy var hourTimerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.green
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hourTimerLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "00"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var hourPlaceholderLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Hour(s)"
        label.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minuteTimerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.green
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var minuteTimerLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "00"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minutePlaceholderLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "Minute(s)"
        label.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var secondsTimerView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = Colors.green
        view.layer.cornerRadius = Design.cornerRadius.default
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secondsTimerLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "00"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var secondsPlaceholderLabel: UILabel = {
        let label: UILabel = .init()
        label.textColor = Colors.black
        label.text = "seconds(s)"
        label.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timerStartStopButton: UIButton = {
        let button: UIButton = .init()
        button.setTitle("START TIMER", for: .normal)
        button.backgroundColor = Colors.white
        button.setTitleColor(Colors.black, for: .normal)
        button.layer.cornerRadius = 13
        button.layer.masksToBounds = true
        button.layer.borderColor = Colors.green.cgColor
        button.layer.borderWidth = 1.0
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var seconds = 60
    private var timer = Timer()
 
    private var isTimerRunning = false
    private var resumeTapped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    internal func setupViews() {
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
            estimateChargingTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        ])
        
        contentView.addSubview(hourTimerView)
        contentView.addSubview(minuteTimerView)
        contentView.addSubview(secondsTimerView)
        
        NSLayoutConstraint.activate([
            minuteTimerView.topAnchor.constraint(equalTo: estimateChargingTimeLabel.bottomAnchor, constant: padding.default),
            minuteTimerView.widthAnchor.constraint(equalToConstant: 80),
            minuteTimerView.heightAnchor.constraint(equalToConstant: 80),
            minuteTimerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            hourTimerView.topAnchor.constraint(equalTo: minuteTimerView.topAnchor),
            hourTimerView.widthAnchor.constraint(equalToConstant: 80),
            hourTimerView.heightAnchor.constraint(equalToConstant: 80),
            hourTimerView.trailingAnchor.constraint(equalTo: minuteTimerView.leadingAnchor, constant: -padding.large),
            
            secondsTimerView.topAnchor.constraint(equalTo: minuteTimerView.topAnchor),
            secondsTimerView.widthAnchor.constraint(equalToConstant: 80),
            secondsTimerView.heightAnchor.constraint(equalToConstant: 80),
            secondsTimerView.leadingAnchor.constraint(equalTo: minuteTimerView.trailingAnchor, constant: padding.large)
        ])
        
        hourTimerView.addSubview(hourTimerLabel)
        hourTimerView.addSubview(hourPlaceholderLabel)
        minuteTimerView.addSubview(minuteTimerLabel)
        minuteTimerView.addSubview(minutePlaceholderLabel)
        secondsTimerView.addSubview(secondsTimerLabel)
        secondsTimerView.addSubview(secondsPlaceholderLabel)
        
        NSLayoutConstraint.activate([
            hourTimerLabel.centerXAnchor.constraint(equalTo: hourTimerView.centerXAnchor),
            hourTimerLabel.centerYAnchor.constraint(equalTo: hourTimerView.centerYAnchor),
            hourPlaceholderLabel.centerXAnchor.constraint(equalTo: hourTimerView.centerXAnchor),
            hourPlaceholderLabel.topAnchor.constraint(equalTo: hourTimerLabel.bottomAnchor, constant: 0),
            
            minuteTimerLabel.centerXAnchor.constraint(equalTo: minuteTimerView.centerXAnchor),
            minuteTimerLabel.centerYAnchor.constraint(equalTo: minuteTimerView.centerYAnchor),
            minutePlaceholderLabel.centerXAnchor.constraint(equalTo: minuteTimerView.centerXAnchor),
            minutePlaceholderLabel.topAnchor.constraint(equalTo: minuteTimerLabel.bottomAnchor, constant: 0),
            
            secondsTimerLabel.centerXAnchor.constraint(equalTo: secondsTimerView.centerXAnchor),
            secondsTimerLabel.centerYAnchor.constraint(equalTo: secondsTimerView.centerYAnchor),
            secondsPlaceholderLabel.centerXAnchor.constraint(equalTo: secondsTimerView.centerXAnchor),
            secondsPlaceholderLabel.topAnchor.constraint(equalTo: secondsTimerLabel.bottomAnchor, constant: 0)
        ])
        
        contentView.addSubview(timerStartStopButton)
        NSLayoutConstraint.activate([
            timerStartStopButton.heightAnchor.constraint(equalToConstant: 40),
            timerStartStopButton.topAnchor.constraint(equalTo: minuteTimerView.bottomAnchor, constant: padding.default),
            timerStartStopButton.leadingAnchor.constraint(equalTo: hourTimerView.leadingAnchor),
            timerStartStopButton.trailingAnchor.constraint(equalTo: secondsTimerView.trailingAnchor),

            timerStartStopButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    func configure(viewModel: CollectionViewViewModel?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel
        // set all properties
        
        resetButtonTapped()
    }
    
    func updateData() {
        guard let viewModel = viewModel else { return }

        estimateChargingCostValueLabel.text = String(format: "%.2f", viewModel.estimateChargingCost)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            timerStartStopButton.setTitle("STOP AND RESET TIMER", for: .normal)
        } else {
            resetButtonTapped()
            timerStartStopButton.setTitle("START TIMER", for: .normal)
        }
    }
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    private func resetButtonTapped() {
        guard let viewModel = viewModel else { return }

        timer.invalidate()
        self.seconds = viewModel.chargingTimeSeconds
        hourTimerLabel.text = timeString(time: TimeInterval(seconds))[0]
        minuteTimerLabel.text = timeString(time: TimeInterval(seconds))[1]
        secondsTimerLabel.text = timeString(time: TimeInterval(seconds))[2]
        isTimerRunning = false
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            hourTimerLabel.text = timeString(time: TimeInterval(seconds))[0]
            minuteTimerLabel.text = timeString(time: TimeInterval(seconds))[1]
            secondsTimerLabel.text = timeString(time: TimeInterval(seconds))[2]
        }
    }
        
    private func timeString(time:TimeInterval) -> [String] {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        let hoursString = String(format:"%02i", hours)
        let minutesString = String(format:"%02i", minutes)
        let secondsString = String(format:"%02i", seconds)
        
        return [hoursString, minutesString, secondsString]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CostAndTimerCollectionViewCell: ReuseIdentifying {}
