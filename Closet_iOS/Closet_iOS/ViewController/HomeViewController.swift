//
//  HomeViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 25..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeClosetUploadBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTarget()

    }
    
    func settingTarget() {
        
        homeClosetUploadBtn.addTarget(self, action: #selector(self.pressedhomeClosetUploadBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedhomeClosetUploadBtn( _ sender : UIButton ) {
        
        guard let closetUploadVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClosetUploadViewController") as? ClosetUploadViewController else { return }
        
        self.present( closetUploadVC , animated: true , completion: nil )
    }

}
