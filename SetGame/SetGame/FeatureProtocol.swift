//
//  FeatureProtocol.swift
//  SetGame
//
//  Created by Yeh, Louis on 2018/5/8.
//  Copyright © 2018年 Yeh, Louis. All rights reserved.
//

import Foundation

protocol FeatureProtocol {
    var feature: Feature { get set }
    func applyFeature(to string: NSMutableAttributedString) -> NSMutableAttributedString
}
extension FeatureProtocol {
    init(with feature: Feature) {
        self.init(with: feature)
    }
}
struct ColorFeature: FeatureProtocol {
    var feature: Feature

    func applyFeature(to string: NSMutableAttributedString) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "")
    }
}
struct ShapeFeature: FeatureProtocol {
    var feature: Feature

    func applyFeature(to string: NSMutableAttributedString) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "")
    }
}
struct NumberFeature: FeatureProtocol {
    var feature: Feature

    func applyFeature(to string: NSMutableAttributedString) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "")
    }
}
struct ShadeFeature: FeatureProtocol {
    var feature: Feature

    func applyFeature(to string: NSMutableAttributedString) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "")
    }
}
