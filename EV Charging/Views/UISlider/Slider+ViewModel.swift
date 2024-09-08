//
//  Slider+ViewModel.swift
//  EV Charging Calculator
//
//  Created by Olivier Miserez on 06/09/2024.
//

import Foundation
import UIKit

extension Slider {
    public struct ViewModel {
        public var maximumValue: Double = 100
        public var minimumValue: Double = 0
        public var value: Double = 20
        public var interacting: Bool = false
        public var sliderName: String = ""
    }
}
