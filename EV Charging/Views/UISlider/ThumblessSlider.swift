//
//  ThumblessSlider.swift
//  EV Charging Calculator
//
//  Created by Olivier Miserez on 06/09/2024.
//

import Foundation
import UIKit

open class ThumblessSlider: UIView, Slidable {
    public enum CornerRadius {
        case full
        case fixed(CGFloat)
    }
    
    public struct ScaleRatio {
        @available(*, deprecated, renamed: "onAxis", message: "")
        public var ratioOnAxis: CGFloat {
            onAxis
        }
        @available(*, deprecated, renamed: "againstAxis", message: "")
        public var ratioAgainstAxis: CGFloat {
            againstAxis
        }
        @available(*, deprecated, renamed: "init(onAxis:againstAxis:)", message: "")
        public init(ratioOnAxis: CGFloat, ratioAgainstAxis: CGFloat) {
            self.onAxis = ratioOnAxis
            self.againstAxis = ratioAgainstAxis
        }
        
        public var onAxis: CGFloat
        public var againstAxis: CGFloat
        public init(onAxis: CGFloat, againstAxis: CGFloat) {
            self.onAxis = onAxis
            self.againstAxis = againstAxis
        }
    }
    
    public let direction: Direction
    
    public let scaleRatio: ScaleRatio
    
    public var cornerRadius: CornerRadius
    open var visualEffect: UIVisualEffect? {
        didSet {
            visualEffectView.backgroundColor = Colors.background
        }
    }
    
    open class var defaultScaleRatio: ScaleRatio {
        ScaleRatio(onAxis: 1, againstAxis: 1)
    }
    
    open class var defaultDirection: Direction {
        .leadingToTrailing
    }
    
    open class var defaultCornerRadius: CornerRadius {
        .fixed(17)
    }
    
    open class var defaultVisualEffect: UIVisualEffect {
        UIBlurEffect(style: .systemUltraThinMaterial)
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        fillingView?.backgroundColor = .tintColor
    }
    
    struct VisualEffectViewConstraints {
        var width: NSLayoutConstraint!
        var height: NSLayoutConstraint!
        
        var scaledWidth: NSLayoutConstraint!
        var scaledHeight: NSLayoutConstraint!
        
        var scaled: Bool {
            get {
                width.isActive == false && scaledWidth.isActive
            }
            set {
                let scaled = newValue
                // deactivate before activating to avoid ambiguity complains
                if scaled {
                    width.isActive = false
                    height.isActive = false
                    scaledWidth.isActive = true
                    scaledHeight.isActive = true
                } else {
                    scaledWidth.isActive = false
                    scaledHeight.isActive = false
                    width.isActive = true
                    height.isActive = true
                }
            }
        }
    }
    
    var visualEffectViewConstraints = VisualEffectViewConstraints()
    
    public init(
        direction: Direction = defaultDirection,
        scaleRatio: ScaleRatio = defaultScaleRatio,
        cornerRadius: CornerRadius = defaultCornerRadius,
        visualEffect: UIVisualEffect = defaultVisualEffect
    ) {
        self.direction = direction
        self.scaleRatio = scaleRatio
        self.cornerRadius = Self.defaultCornerRadius
        self.visualEffect = Self.defaultVisualEffect
        super.init(frame: .zero)
        buildView()
    }
    
    public convenience init(
        direction: Direction = defaultDirection,
        scaling: Scaling,
        cornerRadius: CornerRadius = defaultCornerRadius,
        visualEffect: UIVisualEffect = defaultVisualEffect
    ) {
        self.init(
            direction: direction,
            scaleRatio: scaling.scaleRatio,
            cornerRadius: cornerRadius,
            visualEffect: visualEffect
        )
    }
    
    public required init?(coder: NSCoder) {
        self.direction = Self.defaultDirection
        self.scaleRatio = Self.defaultScaleRatio
        self.cornerRadius = Self.defaultCornerRadius
        self.visualEffect = Self.defaultVisualEffect
        super.init(coder: coder)
        buildView()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        fitValueRatio(valueRatio, when: isInteracting)
    }
    
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateCornerRadius(getCornerRadius())
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else {
            return
        }
        resetVariableAndFixedConstraint()
    }
    
    open override var semanticContentAttribute: UISemanticContentAttribute {
        get {
            super.semanticContentAttribute
        }
        set {
            super.semanticContentAttribute = newValue
            visualEffectView.semanticContentAttribute = newValue
            visualEffectView.semanticContentAttribute = newValue
            fillingView.semanticContentAttribute = newValue
        }
    }
    
     weak var fillingView: UIView!
    private weak var variableConstraint: NSLayoutConstraint?
    private weak var fixedConstraint: NSLayoutConstraint?
    private weak var visualEffectView: UIView!
    
    private var isInteracting: Bool = false
    
    public var valueRatio: CGFloat = 0 {
        didSet {
            fitValueRatio(valueRatio, when: isInteracting)
        }
    }
    
    private func getCornerRadius() -> CGFloat {
        switch cornerRadius {
        case .fixed(let fixedValue):
            return fixedValue
        case .full:
            return projection(
                of: visualEffectView.frame.size,
                on: direction.axis.counterpart
            ) / 2
        }
    }
    
    private func updateCornerRadius(_ cornerRadius: CGFloat) {
        if self.layer.cornerRadius != cornerRadius {
            self.layer.cornerRadius = cornerRadius
            visualEffectView.layer.cornerRadius = cornerRadius
        }
    }
    
    public func fit(_ viewModel: Slider.ViewModel) {
        let valueRatio = viewModel.value / (viewModel.maximumValue + viewModel.minimumValue)
        if self.valueRatio != valueRatio {
            self.valueRatio = valueRatio
        }
        
        isInteracting = viewModel.interacting
        let shouldScale = viewModel.interacting
        if visualEffectViewConstraints.scaled != shouldScale {
            visualEffectViewConstraints.scaled = shouldScale
            UIView.animate(
                withDuration: 0.4,
                delay: 0,
                usingSpringWithDamping: {
                    if shouldScale {
                        return 0.8
                    } else {
                        return 0.55
                    }
                }(),
                initialSpringVelocity: {
                    if shouldScale {
                        return 20
                    } else {
                        return 0
                    }
                }()
            ) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
}


// MARK: filling
private extension ThumblessSlider {
    func getFillingViewLength(
        byRatio ratio: CGFloat,
        when interacting: Bool
    ) -> CGFloat {
        let size = bounds.size
        if interacting{
            return ratio * scaleRatio.onAxis * projection(of: size, on: direction.axis)
        } else {
            return ratio * projection(of: size, on: direction.axis)
        }
    }
    
    func fitValueRatio(_ valueRatio: CGFloat, when isInteracting: Bool) {
        let fillingLength = getFillingViewLength(
            byRatio: valueRatio,
            when: isInteracting
        )
        if variableConstraint?.constant != fillingLength {
            variableConstraint?.constant = fillingLength
        }
    }
}



// MARK: build
private extension ThumblessSlider {
    func buildView() {
        layer.masksToBounds = false
        
        let visualEffectView = UIView()
        self.visualEffectView = visualEffectView
        visualEffectView.backgroundColor = Colors.background
        visualEffectView.layer.cornerCurve = .continuous
        visualEffectView.clipsToBounds = true
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualEffectView)
        visualEffectView.centerYAnchor.constraint(equalTo: centerYAnchor)
            .isActive = true
        visualEffectView.centerXAnchor.constraint(equalTo: centerXAnchor)
            .isActive = true
        
        visualEffectViewConstraints.width = visualEffectView.widthAnchor.constraint(equalTo: widthAnchor)
        visualEffectViewConstraints.height = visualEffectView.heightAnchor.constraint(equalTo: heightAnchor)
        visualEffectViewConstraints.scaledWidth = visualEffectView.widthAnchor.constraint(
            equalTo: widthAnchor,
            multiplier: {
                switch direction.axis {
                case .xAxis:
                    return scaleRatio.onAxis
                case .yAxis:
                    return scaleRatio.againstAxis
                }
            }()
        )
        visualEffectViewConstraints.scaledHeight = visualEffectView.heightAnchor.constraint(
            equalTo: heightAnchor,
            multiplier: {
                switch direction.axis {
                case .xAxis:
                    return scaleRatio.againstAxis
                case .yAxis:
                    return scaleRatio.onAxis
                }
            }()
        )
        visualEffectViewConstraints.scaled = false
        
        let fillingView = UIView()
        self.fillingView = fillingView
        fillingView.backgroundColor = tintColor
        visualEffectView.addSubview(fillingView)
        fillingView.translatesAutoresizingMaskIntoConstraints = false
        
        switch direction.axis {
        case .xAxis:
            fillingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor)
                .isActive = true
            fillingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor)
                .isActive = true
        case .yAxis:
            fillingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor)
                .isActive = true
            fillingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor)
                .isActive = true
        }
        
        let sv = UIStackView()
        sv.spacing = 18
        sv.axis = .vertical
        // this means each arranged subview will take up the same amount of space
        sv.distribution = .fillEqually

        sv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sv)
        
        NSLayoutConstraint.activate([
            sv.topAnchor.constraint(equalTo: self.topAnchor),
            sv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            sv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            sv.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        for _ in 0..<11 {
            let lineView = UIView()
            lineView.backgroundColor = Colors.background
            sv.addArrangedSubview(lineView)
        }
        
        sv.subviews.first?.backgroundColor = .clear
        sv.subviews.last?.backgroundColor = .clear
    }
    
    func resetVariableAndFixedConstraint() {
        let variableConstraint: NSLayoutConstraint = {
            switch direction.axis {
            case .xAxis:
                return fillingView.widthAnchor.constraint(equalToConstant: 0)
            case .yAxis:
                return fillingView.heightAnchor.constraint(equalToConstant: 0)
            }
        }()
        
        self.variableConstraint?.isActive = false
        variableConstraint.isActive = true
        self.variableConstraint = variableConstraint
        
        let fixedConstraint: NSLayoutConstraint = {
            switch direction {
            case .leadingToTrailing:
                return fillingView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor)
            case .trailingToLeading:
                return fillingView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor)
            case .leftToRight:
                return fillingView.leftAnchor.constraint(equalTo: visualEffectView.leftAnchor)
            case .rightToLeft:
                return fillingView.rightAnchor.constraint(equalTo: visualEffectView.rightAnchor)
            case .topToBottom:
                return fillingView.topAnchor.constraint(equalTo: visualEffectView.topAnchor)
            case .bottomToTop:
                return fillingView.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor)
            }
        }()
        self.fixedConstraint?.isActive = false
        fixedConstraint.isActive = true
        self.fixedConstraint = fixedConstraint
    }
}
