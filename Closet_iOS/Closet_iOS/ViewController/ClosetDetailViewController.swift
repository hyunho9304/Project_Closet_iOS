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
        
        
        closetDetailBackBtn.addTarget(self, action: #selector(self.pressedClosetDetailBackBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedClosetDetailBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil)
    }

}
