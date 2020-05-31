//
//  CareBabyTimeVC.swift
//  iFitnessMan
//
//  Created by Apple on 2019/4/12.
//  Copyright © 2019年 whitelok.com. All rights reserved.
//

import UIKit

class CareBabyTimeVC: UIViewController, UITableViewDataSource {
    @IBOutlet weak var recordTable: UITableView!
    @IBOutlet weak var hourLabel0: UILabel!
    @IBOutlet weak var hourLabel1: UILabel!
    @IBOutlet weak var minLabel0: UILabel!
    @IBOutlet weak var minLabel1: UILabel!
    @IBOutlet weak var secLabel0: UILabel!
    @IBOutlet weak var secLabel1: UILabel!
    @IBOutlet weak var mainBtn: UIImageView!
    @IBOutlet weak var cancleBtn: UIImageView!
    @IBOutlet weak var milkType: UIView!
    @IBOutlet weak var milkView: UIView!
    @IBOutlet weak var milkLabel: UILabel!
    @IBOutlet weak var foodType: UIView!
    @IBOutlet weak var foodView: UIView!
    @IBOutlet weak var foodLabel: UILabel!
    
    let userDefault = UserDefaults.standard
    var timer: Timer?
    var status = 0 // 0start。 1stop。 2record。
    var recordTime = 0
    var type: CareBabyType = .milk
    var listData = [CareBabyTimeMode]()
    let dateFormat:DateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormat.dateFormat = "MM月dd日"
        
        recordTable.register(UINib(nibName: "CareBabyTimeCell", bundle: nil), forCellReuseIdentifier: "CareBabyTimeCell")
        
        milkLabel.text = CareBabyType.milk.name
        foodLabel.text = CareBabyType.food.name
        
        setTapGestureRecognizer()
        
        getData()
        recordTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Data
    func getData() {
        if let type = self.userDefault.array(forKey: "CareBabyType") {
            CareBabyData.type = (type as? [String])!
        }
        if let date = self.userDefault.array(forKey: "CareBabyDate") {
            CareBabyData.date = (date as? [String])!
        }
        if let time = self.userDefault.array(forKey: "CareBabyTime") {
            CareBabyData.time = (time as? [String])!
        }
        if CareBabyData.type.count > 0 { organizeData() }
    }
    func organizeData() {
        for i in 0...CareBabyData.type.count - 1 {
            var stype = CareBabyType.milk
            if CareBabyData.type[i] == "食物" { stype = .food }
            listData.append(CareBabyTimeMode.init(type: stype, date: CareBabyData.date[i], time: CareBabyData.time[i]))
        }
    }
    
    // MARK: - UITapGestureRecognizer
    func setTapGestureRecognizer() {
        mainBtn.isUserInteractionEnabled = true
        mainBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(mainBtnEvent(tapGestureRecognizer:))))
        cancleBtn.isUserInteractionEnabled = true
        cancleBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelViewTapped(tapGestureRecognizer:))))
        milkType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(milkViewTapped(tapGestureRecognizer:))))
        foodType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(foodViewTapped(tapGestureRecognizer:))))
    }
    @objc func milkViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        type = .milk
        changeTypeColor()
    }
    @objc func foodViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        type = .food
        changeTypeColor()
    }
    @objc func cancelViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        cancelBtnEvent()
    }
    // MARK: - Event
    // mainBtn
    @objc func mainBtnEvent(tapGestureRecognizer: UITapGestureRecognizer) {
        switch status {
        case 0:
            status = 1
            registerTimer()
        case 1:
            status = 2
            timer?.invalidate()
            timer = nil
        case 2:
            saveData()
            clearDate()
            recordTable.reloadData()
            cancelBtnEvent()
            status = 0
        default:
            return
        }
        mainBtn.image = UIImage(named: CareBabyData.mainBtnImage[status])
    }
    // cancleBtn
    func cancelBtnEvent() {
        if status == 2 {
            recordTime = 0
            changeTimeLabel()
            status = 0
            mainBtn.image = UIImage(named: CareBabyData.mainBtnImage[status])
        }
    }
    // view type color
    func changeTypeColor() {
        switch type {
        case .milk:
            milkType.backgroundColor = UIColor.white
            milkView.backgroundColor = themeType.milkView.color
            milkLabel.textColor = themeType.milkText.color
            foodType.backgroundColor = UIColor.clear
            foodView.backgroundColor = themeType.darkView.color
            foodLabel.textColor = themeType.darkText.color
        case .food:
            foodType.backgroundColor = UIColor.white
            foodView.backgroundColor = themeType.foodView.color
            foodLabel.textColor = themeType.foodText.color
            milkType.backgroundColor = UIColor.clear
            milkView.backgroundColor = themeType.darkView.color
            milkLabel.textColor = themeType.darkText.color
        }
    }
    func changeTimeLabel() {
        let hour = Int(recordTime / 3600)
        hourLabel0.text = "\(Int(hour / 10))"
        hourLabel1.text = "\(hour - (Int(hour / 10) * 10))"
        let min = Int((recordTime - (hour * 3600)) / 60)
        minLabel0.text = "\(Int(min / 10))"
        minLabel1.text = "\(min - (Int(min / 10) * 10))"
        let sec = Int(recordTime - (hour * 3600) - (min * 60))
        secLabel0.text = "\(Int(sec / 10))"
        secLabel1.text = "\(sec - (Int(sec / 10) * 10))"
    }
    // MARK: - Timer
    func registerTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runCareBaby(_:)), userInfo: nil, repeats: true)
    }
    
    @objc func runCareBaby(_ timer: Timer) -> Void {
        recordTime += 1
        self.changeTimeLabel()
    }
    // MARK: - save record
    func saveData() {
        let date = dateFormat.string(from: Date())
        let time = recordTime.toTimeString()
        listData.insert(CareBabyTimeMode.init(type: type, date: date, time: time), at: 0)
        CareBabyData.type.insert(type.name, at: 0)
        CareBabyData.date.insert(date, at: 0)
        CareBabyData.time.insert(time, at: 0)
        self.userDefault.set(CareBabyData.type, forKey: "CareBabyType")
        self.userDefault.set(CareBabyData.date, forKey: "CareBabyDate")
        self.userDefault.set(CareBabyData.time, forKey: "CareBabyTime")
        self.userDefault.synchronize()
    }
    func clearDate() {
        if listData.count > 50 {
            for _ in 50...listData.count - 1{
                listData.remove(at: 50)
            }
        }
    }
    // MARK: - Table Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = listData[indexPath.row]
        let cell = recordTable.dequeueReusableCell(withIdentifier: "CareBabyTimeCell", for: indexPath) as! CareBabyTimeCell
        cell.typeView.backgroundColor = cellData.type.viewColor
        cell.typeLabel.text = cellData.type.name
        cell.typeLabel.textColor = cellData.type.textColor
        cell.dateLabel.text = cellData.date
        cell.dateLabel.textColor = cellData.type.textColor
        cell.timeLabel.text = cellData.time
        cell.timeLabel.textColor = cellData.type.textColor
        
        return cell
    }
}
