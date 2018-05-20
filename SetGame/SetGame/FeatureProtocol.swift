//
//  FeatureProtocol.swift
//  SetGame
//
//  Created by Yeh, Louis on 2018/5/8.
//  Copyright © 2018年 Yeh, Louis. All rights reserved.
//

import Foundation
import UIKit

protocol FeatureProtocol {
    var feature: Feature { get set }
    func applyFeature(to baseString: NSMutableAttributedString) -> NSMutableAttributedString
}

struct ColorFeature: FeatureProtocol {
    var feature: Feature
    static private var colorMap = [FeatureValue.valueA: UIColor.blue, FeatureValue.valueB: UIColor.red, FeatureValue.valueC: UIColor.green]
    func applyFeature(to baseString: NSMutableAttributedString) -> NSMutableAttributedString {
        var output = NSMutableAttributedString(attributedString: baseString)
        if let color = ColorFeature.colorMap[feature.value] {
            output.setAttributes([NSAttributedStringKey.foregroundColor: color], range: NSMakeRange(0, baseString.string.count))
        }
        return output
    }
}
struct ShapeFeature: FeatureProtocol {
    var feature: Feature
    static private var shapeMap = [FeatureValue.valueA: "▲", FeatureValue.valueB: "●", FeatureValue.valueC: "■"]
    func applyFeature(to baseString: NSMutableAttributedString) -> NSMutableAttributedString {
        var output = NSMutableAttributedString(attributedString: baseString)
        if let shape = ShapeFeature.shapeMap[feature.value] {
            output.replaceCharacters(in: NSMakeRange(0, baseString.string.count), with: shape)
        }
        return output
    }
}
struct NumberFeature: FeatureProtocol {
    var feature: Feature
    static private var numberMap = [FeatureValue.valueA: 1, FeatureValue.valueB: 2, FeatureValue.valueC: 3]
    func applyFeature(to baseString: NSMutableAttributedString) -> NSMutableAttributedString {
        var output = NSMutableAttributedString(attributedString: baseString)
        if let number = NumberFeature.numberMap[feature.value] {
            let newString = (0..<number).reduce("") { (a, _) -> String in return a + baseString.string }
            output.replaceCharacters(in: NSMakeRange(0, output.string.count), with: newString)
        }
        return output
    }
}
struct ShadeFeature: FeatureProtocol {
    var feature: Feature
    static private var shadeMap = [
        FeatureValue.valueA: { (striped: UIColor) in [NSAttributedStringKey.foregroundColor: striped.withAlphaComponent(CGFloat(0.15))] },
        FeatureValue.valueB: { (filled: UIColor) in [NSAttributedStringKey.foregroundColor: filled] },
        FeatureValue.valueC: { (outline: UIColor) in [NSAttributedStringKey.strokeColor: outline, NSAttributedStringKey.strokeWidth: 3] }
    ]
    func applyFeature(to baseString: NSMutableAttributedString) -> NSMutableAttributedString {
        var output = NSMutableAttributedString(attributedString: baseString)
        let color = baseString.attributes(at: 0, effectiveRange: nil).filter() { $0.key == NSAttributedStringKey.foregroundColor }.first?.value as? UIColor ?? UIColor.black
        if let shade = ShadeFeature.shadeMap[feature.value] {
            output.setAttributes(shade(color), range: NSMakeRange(0, baseString.string.count))
        }
        return output
    }
}

