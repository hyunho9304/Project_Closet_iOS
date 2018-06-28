//
//  HomeViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 25..
//  Copyright © 2018년 박현호. All rights reserved.
//

/*
 Description :  새 옷을 등록하는 화면이다.
*/

import UIKit
import Kingfisher

class HomeViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var closet : [ Clothes ] = [Clothes]()

    @IBOutlet weak var homeClosetUploadBtn: UIButton!
    @IBOutlet weak var homeClosetCodyRoomBtn: UIButton!
    @IBOutlet weak var homeClosetOuterTypeBtn: UIButton!
    @IBOutlet weak var homeClosetTopTypeBtn: UIButton!
    @IBOutlet weak var homeClosetBottomTypeBtn: UIButton!
    @IBOutlet weak var homeClosetAccTypeBtn: UIButton!
    @IBOutlet weak var homeClosetShoesTypeBtn: UIButton!
    
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTarget()
    }
    
    func settingTarget() {
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        homeClosetUploadBtn.addTarget(self, action: #selector(self.pressedhomeClosetUploadBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  카테고리 버튼
        homeClosetOuterTypeBtn.addTarget(self, action: #selector(self.pressedhomeClosetOuterTypeBtn(_:)), for: UIControlEvents.touchUpInside)
        homeClosetTopTypeBtn.addTarget(self, action: #selector(self.pressedhomeClosetTopTypeBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedhomeClosetUploadBtn( _ sender : UIButton ) {
        
        guard let closetUploadVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClosetUploadViewController") as? ClosetUploadViewController else { return }
        
        self.present( closetUploadVC , animated: true , completion: nil )
    }
    
    @objc func pressedhomeClosetOuterTypeBtn( _ sender : UIButton ) {
        
        Server.reqCloset(closet_type: "OUTER" ) { (clothesData , rescode ) in
            
            if rescode == 200 {
                
                self.closet = clothesData
                self.homeCollectionView.reloadData()
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인하거라", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    @objc func pressedhomeClosetTopTypeBtn( _ sender : UIButton ) {
        
        Server.reqCloset(closet_type: "Top" ) { (clothesData , rescode ) in
            
            if rescode == 200 {
                
                self.closet = clothesData
                self.homeCollectionView.reloadData()
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인하거라", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return closet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath ) as! HomeCollectionViewCell
        
        cell.homeImageView.kf.setImage( with: URL( string:gsno(closet[indexPath.row].closet_image)) )
        cell.homeDateLabel.text = closet[ indexPath.row ].closet_uploadtime
        cell.homeMemoTextView.text = closet[ indexPath.row ].closet_memo
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard let closetDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClosetDetailViewController" ) as? ClosetDetailViewController else { return }
        
        closetDetailVC.detailClothes = closet[ indexPath.row ]
        
        present( closetDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width , height: 473 * self.view.frame.height/667 )
    }

}
