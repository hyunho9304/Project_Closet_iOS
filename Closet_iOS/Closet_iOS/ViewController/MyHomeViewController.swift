//
//  MyHomeViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 29..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class MyHomeViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    let typeArray = [ "SUMMER" , "OUTER" , "KNIT" , "TOP" , "BLOUSE" , "DRESS" , "SKIRT" , "PANTS" , "SHOES" , "BAG" , "ACC" ]
    var closet : [ Clothes ] = [Clothes]()
    
    @IBOutlet weak var homeClosetUploadBtn: UIButton!
    @IBOutlet weak var homeClosetCodyRoomBtn: UIButton!
    
    @IBOutlet weak var homeClosetMainType: UILabel!
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var clothesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTarget()
    }
    
    func settingTarget() {
        
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        
        clothesCollectionView.delegate = self
        clothesCollectionView.dataSource = self
        
        homeClosetUploadBtn.addTarget(self, action: #selector(self.pressedhomeClosetUploadBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //  새 옷 등록
    @objc func pressedhomeClosetUploadBtn( _ sender : UIButton ) {
        
        guard let closetUploadVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClosetUploadViewController") as? ClosetUploadViewController else { return }
        
        self.present( closetUploadVC , animated: true , completion: nil )
    }
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == typeCollectionView {
            return typeArray.count
        } else {
            return closet.count
        }
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == typeCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TypeCollectionViewCell", for: indexPath) as! TypeCollectionViewCell
            
            cell.homeTypeLabel.text = typeArray[ indexPath.row ]
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothesCollectionViewCell", for: indexPath) as! ClothesCollectionViewCell
            
            cell.homeImageView.kf.setImage( with: URL( string:gsno(closet[indexPath.row].closet_image)) )
            cell.homeDateLabel.text = closet[ indexPath.row ].closet_uploadtime
            cell.homeMemoTextView.text = closet[ indexPath.row ].closet_memo
            
            return cell
        }
    }
    
    //  cell 선택했을 때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == typeCollectionView {
            
            var typeName : String?
            typeName = typeArray[ indexPath.row ]
            
            Server.reqCloset(closet_type: gsno(typeName) ) { (clothesData , rescode ) in
                
                if rescode == 200 {
                    
                    self.closet = clothesData
                    self.clothesCollectionView.reloadData()
                    
                    self.homeClosetMainType.text = typeName
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인하거라", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
            
        } else {
            
            guard let closetDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClosetDetailViewController" ) as? ClosetDetailViewController else { return }
            
            closetDetailVC.detailClothes = closet[ indexPath.row ]
            
            closetDetailVC.tempText = self.homeClosetMainType.text
            
            
            present( closetDetailVC, animated: true)
        }
    }
    
    //  cell 크기 비율
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == typeCollectionView {
            return CGSize(width: 82 * self.view.frame.width/375 , height: 71 * self.view.frame.height/667 )
        }
        else {
            return CGSize(width: self.view.frame.width , height: 478 * self.view.frame.height/667 )
        }
    }
 
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == typeCollectionView {
            return 0
        }
        else {
            return 0
        }
    }


}
