//
//  CollectionViewViewModel.swift
//  EV Charging
//
//  Created by Olivier Miserez on 10/09/2024.
//

import Foundation

class CollectionViewViewModel {
    private(set) var carBatteryCapacity: Int = 75
    private(set) var currentSoCValue: Double = 20
    private(set) var targetSoCValue: Double = 80
    private(set) var chargingSpeed: Double = 100.0
    private(set) var chargingCost: Double = 0.69
    private(set) var additionalCost: Float = 0.60
    private(set) var isNoFeeSelected: Bool = true
    private(set) var totalkWhToCharge: Double = 0.0
    
    private(set) var estimateChargingCost: Float = 0.00
    private(set) var chargingTimeSeconds: Int = 0
    
    init() {
        
    }
    
    var carName: String {
        "Tesla Model Y"
    }
    var carEngine: String {
        "Long Range Dual Motor"
    }
    
    func setCarBatteryCapacity(value: Int) {
        carBatteryCapacity = value
    }
    
    func setCurrentSoC(value: Double) {
        currentSoCValue = value
    }

    func setTargetSoC(value: Double) {
        targetSoCValue = value
    }

    func setChargingSpeed(value: Double) {
        chargingSpeed = value
    }
    
    func setChargingCost(value: Double) {
        chargingCost = value
    }

    func setAdditionalCost(value: Float) {
        additionalCost = value
    }
    
    func setIsNoFeeSelected(value: Bool) {
        isNoFeeSelected = value
    }
    
    func setEstimateChargingCost(value: Float) {
        estimateChargingCost = value
    }
    
    func calculateChargingCost() {
        let kWhLeftInBattery = Double(carBatteryCapacity) * (currentSoCValue / 100)
        let targetKwhInBattery = Double(carBatteryCapacity) * (targetSoCValue / 100)
        self.totalkWhToCharge = targetKwhInBattery - kWhLeftInBattery
        let totalPrice = (totalkWhToCharge * chargingCost) + (isNoFeeSelected ? 0 : Double(additionalCost))

        setEstimateChargingCost(value: Float(totalPrice))
        calculateChargingTime()
    }
    
    func calculateChargingTime() {
        let x = (chargingSpeed * 0.9)
        let hoursToCharge = totalkWhToCharge / x
        let secondsToCharge = hoursToCharge * 3600
        
        chargingTimeSeconds = Int(secondsToCharge)
    }
}
