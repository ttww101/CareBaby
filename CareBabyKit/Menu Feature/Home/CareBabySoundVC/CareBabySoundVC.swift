//
//  CareBabySoundVC.swift
//  CareBaby
//
//  Created by Apple on 5/2/19.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

import UIKit
import AVFoundation

struct SoundModel {
    var image: String
    var play: AVAudioPlayer?
    init(image: String, playName: String, playType: String) {
        self.image = image
        do {
            let filePath = Bundle.main.url(forResource: playName, withExtension: playType)
            self.play = try AVAudioPlayer(contentsOf: filePath!, fileTypeHint: AVFileType.wav.rawValue)
        } catch {
            print("error")
        }
    }
}
class CareBabySoundModel {
    func getSoundData() -> [SoundModel] {
        var data = [SoundModel]()
        for i in 1...20 {
            data.append(SoundModel(image: "\(i).png", playName: "\(i)", playType: "wav"))
        }
        return data
    }
}

class CareBabySoundVC: UIViewController {
    
    var listData: [SoundModel]!
    var careBabySoundModel: CareBabySoundModel!
    var soundView: SoundView!
    var imageView: UIImageView!
    var timer: Timer?
    var runTimer = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        careBabySoundModel = CareBabySoundModel()
        self.view.backgroundColor = UIColor.white
        setupData()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        setupUI()
    }
    
    func setupUI() {
        setImage()
        setView()
    }
    
    func setupData() {
        self.listData = careBabySoundModel.getSoundData()
    }
}
// MARK: - UI & Business logic
extension CareBabySoundVC {
    func setImage() {
        imageView = UIImageView(image: UIImage(named: "baby.png"))
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        self.view.addViewLayout(imageView, 0, self.view.frame.size.height * 3 / 5, 0, 0)
    }
    func setView() {
        let viewFrame = CGRect(x: 10, y: self.view.frame.size.height * 2 / 5, width: self.view.frame.size.width - 20, height: self.view.frame.size.height * 3 / 5)
        soundView = SoundView(frame: viewFrame, listData: listData)
        self.view.addSubview(soundView)
        soundView.clickCallBack = { [weak self] in
            if ((self?.timer) != nil) {
                self?.runTimer = 2
            } else {
                self?.registerTimer()
            }
        }
    }
    func registerTimer() {
        imageView.image = UIImage(named: "baby2.png")
        self.runTimer = 2
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runBabyHappy(_:)), userInfo: nil, repeats: true)
    }
    @objc func runBabyHappy(_ timer: Timer) -> Void {
        runTimer -= 1
        if runTimer == 0 {
            imageView.image = UIImage(named: "baby.png")
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}

// MARK: - view
class SoundView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var listData: [SoundModel]!
    var clickCallBack: (() -> Void)?
    var soundCollection: UICollectionView!
    
    convenience init(frame: CGRect, listData: [SoundModel]) {
        self.init(frame: frame)
        self.listData = listData
        setupBuild()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupBuild() {
        self.addBackground(UIImageView(image: UIImage(named: "babyback.png")), .scaleToFill)
        setCollection()
    }
    func setCollection() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (self.frame.size.width - 80) / 5, height: (self.frame.size.height - 50) / 4)
        layout.minimumLineSpacing = CGFloat(integerLiteral: 10)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 10)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        soundCollection = UICollectionView(frame: CGRect(origin: .zero, size: CGSize(width: self.frame.size.width, height: self.frame.size.height)), collectionViewLayout: layout)
        self.soundCollection.dataSource = self
        self.soundCollection.delegate = self
        self.soundCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.soundCollection.backgroundColor = UIColor.clear
        self.addSubview(soundCollection)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let data = listData[indexPath.row]
        cell.addBackground(UIImageView(image: UIImage(named: data.image)), .scaleAspectFit)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = listData[indexPath.row]
        data.play?.play()
        clickCallBack?()
    }
}
