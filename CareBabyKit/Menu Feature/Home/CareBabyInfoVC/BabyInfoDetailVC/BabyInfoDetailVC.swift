//
//  BabyInfoDetailVC.swift
//  iFitnessMan
//
//  Created by Apple on 2019/4/12.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class BabyInfoDetailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UITextView!
    
    var parameter: [String:String]!
    
    init(_ parameter: [String:String]) {
        super.init(nibName: "BabyInfoDetailVC", bundle: nil)
        self.parameter = parameter
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Data
    func getData() {
        APIManager.shared.getData(parameter: parameter, completion: { (json) in
            let status: String = json["status"] as! String
            if status == "1" {
                self.organizeData(json["data"] as! AnyObject)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func organizeData(_ data: AnyObject) {
        titleLabel.text = data["title"] as! String
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 0
        let content = data["content"] as! [String]
        var infoContent = ""
        for i in 0...content.count - 1 {
            infoContent += "\(content[i])\n"
        }
        contentView.text = infoContent
    }
}
