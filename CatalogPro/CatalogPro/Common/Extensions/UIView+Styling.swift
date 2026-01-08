//
//  UIView+Styling.swift
//  CatalogPro
//
//  Created by Swapnil Vinayak Shinde on 2025-12-27.
//

import UIKit

extension UIView {

    // MARK: - Corner Radius

    /// Apply corner radius
    func setCornerRadius(_ radius: CGFloat, clipsToBounds: Bool = true) {
        layer.cornerRadius = radius
        layer.masksToBounds = clipsToBounds
    }

    /// Make view perfectly circular
    func makeCircular() {
        layoutIfNeeded()
        let radius = min(bounds.width, bounds.height) / 2
        setCornerRadius(radius)
    }

    /// Apply corner radius to specific corners (iOS 11+)
    func setCornerRadius(
        _ radius: CGFloat,
        maskedCorners: CACornerMask
    ) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
        layer.masksToBounds = true
    }

    // MARK: - Border

    /// Apply border
    func setBorder(
        width: CGFloat,
        color: UIColor
    ) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    /// Remove border
    func removeBorder() {
        layer.borderWidth = 0
        layer.borderColor = nil
    }

    // MARK: - Shadow

    /// Apply shadow
    func setShadow(
        color: UIColor = .black,
        opacity: Float = 0.2,
        radius: CGFloat = 4,
        offset: CGSize = .zero
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }

    /// Remove shadow
    func removeShadow() {
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.shadowOffset = .zero
        layer.shadowColor = nil
    }

    // MARK: - Border + Corner + Shadow (Common Combo)

    /// Card style appearance
    func applyCardStyle(
        cornerRadius: CGFloat = 12,
        shadowColor: UIColor = .black,
        shadowOpacity: Float = 0.1,
        shadowRadius: CGFloat = 6,
        shadowOffset: CGSize = CGSize(width: 0, height: 2)
    ) {
        setCornerRadius(cornerRadius)
        setShadow(
            color: shadowColor,
            opacity: shadowOpacity,
            radius: shadowRadius,
            offset: shadowOffset
        )
    }
}

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let cgColor = layer.shadowColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
}
