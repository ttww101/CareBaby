//
//  CareBabyInfoVC.swift
//  iFitnessMan
//
//  Created by Apple on 2019/4/12.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class CareBabyInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var babyInfoTable: UITableView!
    var listData = [CareBabyInfoMode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI
    func setUI() {
        babyInfoTable = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        babyInfoTable.register(UINib(nibName: "CareBabyInfoCell", bundle: nil), forCellReuseIdentifier: "CareBabyInfoCell")
        babyInfoTable.backgroundColor = UIColor(red: 238/255, green: 237/255, blue: 232/255, alpha: 1)
        babyInfoTable.separatorStyle = .none
        babyInfoTable.dataSource = self
        babyInfoTable.delegate = self
        self.view.addSubview(babyInfoTable)
        self.view.addViewLayout(babyInfoTable, 0, 0, 0, 0)
    }
    
    // MARK: - Data
    func getData() {
        APIManager.shared.getData(parameter: CareBabyData.titleAPI, completion: { (json) in
            let status: String = json["status"] as! String
            if status == "1" {
                self.organizeData(json["data"] as! [AnyObject])
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func organizeData(_ data: [AnyObject]) {
        for i in 0...data.count - 1 {
            listData.append(CareBabyInfoMode.init(id: data[i]["id"] as! String, title: data[i]["title"] as! String, title_image: data[i]["title_image"] as! String, title_introduction: data[i]["title_introduction"] as! String))
        }
        babyInfoTable.reloadData()
    }
    
    // MARK: - tableview data souce
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = listData[indexPath.row]
        let cell = babyInfoTable.dequeueReusableCell(withIdentifier: "CareBabyInfoCell", for: indexPath) as! CareBabyInfoCell
        cell.infoTitle.text = cellData.title
        cell.infoTitle.lineBreakMode = .byCharWrapping
        cell.infoTitle.numberOfLines = 0
        cell.infoContent.text = cellData.title_introduction
        cell.infoImage.downloadedFrom(imageurl: cellData.title_image)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.babyInfoTable.deselectRow(at: indexPath, animated: true)
        let data = listData[indexPath.row]
        var param = [String:String]()
        param["type"] = "content"
        param["id"] = data.id
        
        guard let delegate = UIApplication.shared.delegate, let window = delegate.window, let resideVC = window?.rootViewController as? RESideMenu else { return }
        guard let nav = resideVC.contentViewController as? UINavigationController else { return }
        
        nav.pushViewController(BabyInfoDetailVC(param), animated: true)
    }
}
