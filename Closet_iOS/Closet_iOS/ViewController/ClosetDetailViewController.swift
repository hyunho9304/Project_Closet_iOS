//
//  ClosetDetailViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 29..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ClosetDetailViewController: UIViewController {

    var detailClothes : Clothes?
    var tempText : String?
    
    @IBOutlet weak var closetDetailBackBtn: UIButton!
    @IBOutlet weak var closetDetailDeleteBtn: UIButton!
    
    @IBOutlet weak var closetDetailImageView: UIImageView!
    @IBOutlet weak var closetDetailTypeTextField: UITextField!
    @IBOutlet weak var closetDetailMemoTextField: UITextView!
    @IBOutlet weak var closetDetailDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTarget()

    }

    func settingTarget() {
        
        closetDetailImageView.kf.setImage( with : URL( string : gsno( detailClothes?.closet_image ) ) )
        closetDetailMemoTextField.text = detailClothes?.closet_memo
        closetDetailDateLabel.text = detailClothes?.closet_uploadtime
        closetDetailTypeTextField.text = tempText
        
        closetDetailBackBtn.addTarget(self, action: #selector(self.pressedClosetDetailBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        closetDetailDeleteBtn.addTarget(self, action: #selector(self.pressedClosetDetailDeleteBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedClosetDetailBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pressedClosetDetailDeleteBtn( _ sender : UIButton ) {
        
        let mainAlert = UIAlertController(title: "옷 삭제", message: "정말 삭제하실겁니까..?", preferredStyle: .alert )
        let ok = UIAlertAction(title: "확인", style: .default, handler: { (_) in
            
            Server.reqClosetDrop(closet_index: (self.detailClothes?.closet_index)!) { (rescode) in
                
                if rescode == 201 {
                    
                    let alert = UIAlertController(title: "옷 삭제", message: "옷을 헌옷함에 버렸습니다", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: { (_) in self.dismiss(animated: true, completion: nil ) } )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
            
        })
        
        let cancle = UIAlertAction(title: "취소", style: .cancel, handler: nil )
        mainAlert.addAction( ok )
        mainAlert.addAction( cancle )
        present( mainAlert , animated: true , completion:  nil )
    }

}
