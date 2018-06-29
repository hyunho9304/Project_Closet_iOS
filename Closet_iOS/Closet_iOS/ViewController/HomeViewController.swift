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
        homeClosetOuterTypeBtn.addTarget(self, action: #selector(self.pressedhomeClosetTypeBtn(_:)), for: UIControlEvents.touchUpInside)
        homeClosetTopTypeBtn.addTarget(self, action: #selector(self.pressedhomeClosetTypeBtn(_:)), for: UIControlEvents.touchUpInside)
        homeClosetBottomTypeBtn.addTarget(self, action: #selector(self.pressedhomeClosetTypeBtn(_:)), for: UIControlEvents.touchUpInside)
        homeClosetAccTypeBtn.addTarget(self, action: #selector(self.pressedhomeClosetTypeBtn(_:)), for: UIControlEvents.touchUpInside)
        homeClosetShoesTypeBtn.addTarget(self, action: #selector(self.pressedhomeClosetTypeBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //  클릭한 버튼만 색갈 검은색으로
    func changeBtnColor( _ sender : UIButton ) {
        
        homeClosetOuterTypeBtn.setTitleColor( #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal )
        homeClosetTopTypeBtn.setTitleColor( #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal )
        homeClosetBottomTypeBtn.setTitleColor( #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal )
        homeClosetAccTypeBtn.setTitleColor( #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal )
        homeClosetShoesTypeBtn.setTitleColor( #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal )
        
        sender.setTitleColor( UIColor.black , for: .normal )
        
    }
    
    //  새 옷 등록
    @objc func pressedhomeClosetUploadBtn( _ sender : UIButton ) {
        
        guard let closetUploadVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClosetUploadViewController") as? ClosetUploadViewController else { return }
        
        self.present( closetUploadVC , animated: true , completion: nil )
    }
    
    //  카테고리별 서버 통신
    @objc func pressedhomeClosetTypeBtn( _ sender : UIButton ) {
        
        Server.reqCloset(closet_type: gsno(sender.titleLabel?.text) ) { (clothesData , rescode ) in
            
            if rescode == 200 {
                
                self.closet = clothesData
                self.homeCollectionView.reloadData()
                
                self.changeBtnColor( sender )
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인하거라", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return closet.count
    }
    
    //  cell 넣을 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath ) as! HomeCollectionViewCell
        
        cell.homeImageView.kf.setImage( with: URL( string:gsno(closet[indexPath.row].closet_image)) )
        cell.homeDateLabel.text = closet[ indexPath.row ].closet_uploadtime
        cell.homeMemoTextView.text = closet[ indexPath.row ].closet_memo
        
        return cell
    }
    
    //  cell 선택했을때
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        guard let closetDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClosetDetailViewController" ) as? ClosetDetailViewController else { return }
        
        closetDetailVC.detailClothes = closet[ indexPath.row ]
        
        closetDetailVC.tempText = currentType()
        
        
        present( closetDetailVC, animated: true)
    }
    
    //  cell Type 알아내는 함수
    func currentType() -> String {
        
        let typeArr = [ homeClosetOuterTypeBtn , homeClosetTopTypeBtn , homeClosetBottomTypeBtn , homeClosetAccTypeBtn , homeClosetShoesTypeBtn ]

        var index = -1
        
        for i in 0..<5 {
            
            if typeArr[i]?.titleLabel?.textColor == UIColor.black  {
                index = i
                break
            }
        }
        
        return (typeArr[index]?.titleLabel?.text)!
    }
    
    //  cell 사이즈비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width , height: 473 * self.view.frame.height/667 )
    }
    
    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
   

}
