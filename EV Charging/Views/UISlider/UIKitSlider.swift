//
//  UIKitSlider.swift
//  EV Charging Calculator
//
//  Created by Olivier Miserez on 06/09/2024.
//

import Foundation
import UIKit

open class UIKitSlider: UISlider, Slidable {
    open var direction: Direction {
        .leadingToTrailing
    }
    
    open func fit(_ viewModel: Slider.ViewModel) {
        // no scale transform
        maximumValue = Float(viewModel.maximumValue)
        minimumValue = Float(viewModel.minimumValue)
        value = Float(viewModel.value)
    }
}
