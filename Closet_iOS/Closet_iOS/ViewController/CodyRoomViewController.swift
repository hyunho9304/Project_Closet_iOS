//
//  CodyRoomViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 30..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class CodyRoomViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var codyRoomOuterCloset : [String] = [String]()
    var codyRoomDressCloset : [String] = [String]()
    var codyRoomKnitCloset : [String] = [String]()
    var codyRoomTopCloset : [String] = [String]()
    var codyRoomBlouseCloset : [String] = [String]()
    var codyRoomPantsCloset : [String] = [String]()
    var codyRoomSkirtCloset : [String] = [String]()
    var codyRoomBagCloset : [String] = [String]()
    var codyRoomShoesCloset : [String] = [String]()
    var codyRoomAccCloset : [String] = [String]()
    
    
    @IBOutlet weak var codyRoomBactBtn: UIButton!
    
    @IBOutlet weak var outerCollectionView: UICollectionView!
    @IBOutlet weak var dressCollectionView: UICollectionView!
    @IBOutlet weak var knitCollectionView: UICollectionView!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var blouseCollectionView: UICollectionView!
    @IBOutlet weak var pantsCollectionView: UICollectionView!
    @IBOutlet weak var skirtCollectionView: UICollectionView!
    @IBOutlet weak var bagCollectionView: UICollectionView!
    @IBOutlet weak var shoesCollectionView: UICollectionView!
    @IBOutlet weak var accCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTarget()
        codyRoomDataInit()
    }
    
    func settingTarget() {
        
        outerCollectionView.delegate = self
        outerCollectionView.dataSource = self
        
        dressCollectionView.delegate = self
        dressCollectionView.dataSource = self
        
        knitCollectionView.delegate = self
        knitCollectionView.dataSource = self
        
        topCollectionView.delegate = self
        topCollectionView.dataSource = self
        
        blouseCollectionView.delegate = self
        blouseCollectionView.dataSource = self
        
        pantsCollectionView.delegate = self
        pantsCollectionView.dataSource = self
        
        skirtCollectionView.delegate = self
        skirtCollectionView.dataSource = self
        
        bagCollectionView.delegate = self
        bagCollectionView.dataSource = self
        
        shoesCollectionView.delegate = self
        shoesCollectionView.dataSource = self
        
        accCollectionView.delegate = self
        accCollectionView.dataSource = self
        
        
        
        codyRoomBactBtn.addTarget(self, action: #selector(self.pressedCodyRoomBactBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    //  뒤로가기 버튼 클릭
    @objc func pressedCodyRoomBactBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    //  서버에서 데이터 가져오기
    func codyRoomDataInit() {
        
        let typeArray : [String] = [ "OUTER" , "KNIT" , "TOP" , "BLOUSE" , "DRESS" , "SKIRT" , "PANTS" , "SHOES" , "BAG" , "ACC" ]
        
        for i in 0..<10 {
            
            Server.reqCodyRoom(closet_type: gsno( typeArray[i] )) { (codyRoomData, rescode) in
                
                if rescode == 200 {
                    
                    if i == 0 {
                        self.codyRoomOuterCloset = codyRoomData
                        self.outerCollectionView.reloadData()
                    } else if i == 1 {
                        self.codyRoomKnitCloset = codyRoomData
                        self.knitCollectionView.reloadData()
                    } else if i == 2 {
                        self.codyRoomTopCloset = codyRoomData
                        self.topCollectionView.reloadData()
                    } else if i == 3 {
                        self.codyRoomBlouseCloset = codyRoomData
                        self.blouseCollectionView.reloadData()
                    } else if i == 4 {
                        self.codyRoomDressCloset = codyRoomData
                        self.dressCollectionView.reloadData()
                    } else if i == 5 {
                        self.codyRoomSkirtCloset = codyRoomData
                        self.skirtCollectionView.reloadData()
                    } else if i == 6 {
                        self.codyRoomPantsCloset = codyRoomData
                        self.pantsCollectionView.reloadData()
                    } else if i == 7 {
                        self.codyRoomShoesCloset = codyRoomData
                        self.shoesCollectionView.reloadData()
                    } else if i == 8 {
                        self.codyRoomBagCloset = codyRoomData
                        self.bagCollectionView.reloadData()
                    } else {
                        self.codyRoomAccCloset = codyRoomData
                        self.accCollectionView.reloadData()
                    }
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인하거라", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
            
        }
    }
    
    //  cell 의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == outerCollectionView {
            return codyRoomOuterCloset.count
        } else if collectionView == dressCollectionView {
            return codyRoomDressCloset.count
        } else if collectionView == knitCollectionView {
            return codyRoomKnitCloset.count
        } else if collectionView == topCollectionView {
            return codyRoomTopCloset.count
        } else if collectionView == blouseCollectionView {
            return codyRoomBlouseCloset.count
        } else if collectionView == pantsCollectionView {
            return codyRoomPantsCloset.count
        } else if collectionView == skirtCollectionView {
            return codyRoomSkirtCloset.count
        } else if collectionView == bagCollectionView {
            return codyRoomBagCloset.count
        } else if collectionView == shoesCollectionView {
            return codyRoomShoesCloset.count
        } else {
            return codyRoomAccCloset.count
        }
    }
    
    //  cell 의 내용
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == outerCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyOuterCollectionViewCell", for: indexPath) as! CodyOuterCollectionViewCell
            
            cell.outerImageView.kf.setImage(with: URL( string: gsno( codyRoomOuterCloset[ indexPath.row] )))
            
            return cell

        } else if collectionView == dressCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyDressCollectionViewCell", for: indexPath) as! CodyDressCollectionViewCell
            
            cell.dressImageView.kf.setImage(with: URL( string: gsno( codyRoomDressCloset[ indexPath.row] )))
            
            return cell
            
        } else if collectionView == knitCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyKnitCollectionViewCell", for: indexPath) as! CodyKnitCollectionViewCell
            
            cell.knitImageView.kf.setImage(with: URL( string: gsno( codyRoomKnitCloset[ indexPath.row] )))
            
            return cell
            
        } else if collectionView == topCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyTopCollectionViewCell", for: indexPath) as! CodyTopCollectionViewCell
            
            cell.topImageView.kf.setImage(with: URL( string: gsno( codyRoomTopCloset[ indexPath.row] )))
            
            return cell
            
        } else if collectionView == blouseCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyBlouseCollectionViewCell", for: indexPath) as! CodyBlouseCollectionViewCell
            
            cell.blouseImageView.kf.setImage(with: URL( string: gsno( codyRoomBlouseCloset[ indexPath.row] )))
            
            return cell
            
        } else if collectionView == pantsCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyPantsCollectionViewCell", for: indexPath) as! CodyPantsCollectionViewCell
            
            cell.pantsImageView.kf.setImage(with: URL( string: gsno( codyRoomPantsCloset[ indexPath.row] )))
            
            return cell
            
        } else if collectionView == skirtCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodySkirtCollectionViewCell", for: indexPath) as! CodySkirtCollectionViewCell
            
            cell.skirtImageView.kf.setImage(with: URL( string: gsno( codyRoomSkirtCloset[ indexPath.row] )))
            
            return cell
            
        } else if collectionView == bagCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyBagCollectionViewCell", for: indexPath) as! CodyBagCollectionViewCell
            
            cell.bagImageView.kf.setImage(with: URL( string: gsno( codyRoomBagCloset[ indexPath.row] )))
            
            return cell
            
        } else if collectionView == shoesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyShoesCollectionViewCell", for: indexPath) as! CodyShoesCollectionViewCell
            
            cell.shoesImageView.kf.setImage(with: URL( string: gsno( codyRoomShoesCloset[ indexPath.row] )))
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CodyAccCollectionViewCell", for: indexPath) as! CodyAccCollectionViewCell
            
            cell.accImageView.kf.setImage(with: URL( string: gsno( codyRoomAccCloset[ indexPath.row] )))
            
            return cell
            
        }
    }
    
    //  cell 크기 비율
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == outerCollectionView {
            return CGSize(width: 140 * self.view.frame.width/375 , height: 140 * self.view.frame.height/667 )
        } else if collectionView == dressCollectionView {
            return CGSize(width: 140 * self.view.frame.width/375 , height: 140 * self.view.frame.height/667 )
        } else if collectionView == knitCollectionView {
            return CGSize(width: 125 * self.view.frame.width/375 , height: 125 * self.view.frame.height/667 )
        } else if collectionView == topCollectionView {
            return CGSize(width: 125 * self.view.frame.width/375 , height: 125 * self.view.frame.height/667 )
        } else if collectionView == blouseCollectionView {
            return CGSize(width: 125 * self.view.frame.width/375 , height: 125 * self.view.frame.height/667 )
        } else if collectionView == pantsCollectionView {
            return CGSize(width: 125 * self.view.frame.width/375 , height: 125 * self.view.frame.height/667 )
        } else if collectionView == skirtCollectionView {
            return CGSize(width: 125 * self.view.frame.width/375 , height: 125 * self.view.frame.height/667 )
        } else if collectionView == bagCollectionView {
            return CGSize(width: 100 * self.view.frame.width/375 , height: 100 * self.view.frame.height/667 )
        } else if collectionView == shoesCollectionView {
            return CGSize(width: 100 * self.view.frame.width/375 , height: 100 * self.view.frame.height/667 )
        } else {
            return CGSize(width: 100 * self.view.frame.width/375 , height: 100 * self.view.frame.height/667 )
        }
    }

    //  cell 간 가로 간격 ( horizental 이라서 가로를 사용해야 한다 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }

}
