//
//  CareBabyData.swift
//  iFitnessMan
//
//  Created by Apple on 2019/4/12.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

struct CareBabyData {
    static var url = "http://47.75.131.189/1b01f11b1e0029f5a44e774ef0d809f6/"
    static var titleAPI = ["type":"title"]
    static var mainBtnImage = ["timestart.png", "timestop.png", "timerecord.png"]
    static var type = [String]()
    static var date = [String]()
    static var time = [String]()
}

enum themeType {
    case milkView, milkText, foodView, foodText, darkView, darkText
    
    var color: UIColor {
        switch self {
        case .milkView:
            return UIColor(red: 239/255, green: 210/255, blue: 170/255, alpha: 1)
        case .milkText:
            return UIColor(red: 176/255, green: 102/255, blue: 0/255, alpha: 1)
        case .foodView:
            return UIColor(red: 239/255, green: 170/255, blue: 174/255, alpha: 1)
        case .foodText:
            return UIColor(red: 124/255, green: 34/255, blue: 39/255, alpha: 1)
        case .darkView:
            return UIColor(red: 126/255, green: 126/255, blue: 126/255, alpha: 1)
        case .darkText:
            return UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1)
        }
    }
}

enum CareBabyType {
    case food, milk
    
    var name: String {
        switch self {
        case .food:
            return "食物"
        case .milk:
            return "牛奶"
        }
    }
    var viewColor: UIColor {
        switch self {
        case .food:
            return UIColor(red: 239/255, green: 170/255, blue: 174/255, alpha: 1)
        case .milk:
            return UIColor(red: 239/255, green: 210/255, blue: 170/255, alpha: 1)
        }
    }
    var textColor: UIColor {
        switch self {
        case .food:
            return UIColor(red: 124/255, green: 34/255, blue: 39/255, alpha: 1)
        case .milk:
            return UIColor(red: 176/255, green: 102/255, blue: 0/255, alpha: 1)
        }
    }
}
