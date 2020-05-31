//
//  Int++convert.swift
//  iHealthS
//
//  Created by Apple on 2019/4/5.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

extension Int {
    func toCGFloat() -> CGFloat {
        return CGFloat(integerLiteral: self)
    }
    func toTimeString() -> String {
        var value = ""
        if Int(self / 3600) < 10 {
            value = "0\(Int(self / 3600))"
        } else {
            value = "\(Int(self / 3600))"
        }
        value += ":"
        let m = self - (Int(self / 3600) * 3600)
        if Int(m / 60) < 10 {
            value += "0\(Int(m / 60))"
        } else {
            value += "\(Int(m / 60))"
        }
        value += ":"
        let s = m - (Int(m / 60) * 60)
        if s < 10 {
            value += "0\(s)"
        } else {
            value += "\(s)"
        }
        return value
    }
}
