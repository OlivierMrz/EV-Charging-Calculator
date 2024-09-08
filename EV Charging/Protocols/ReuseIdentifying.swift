//
//  ReuseIdentifying.swift
//  EV Charging
//
//  Created by Olivier Miserez on 08/09/2024.
//

import UIKit

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
