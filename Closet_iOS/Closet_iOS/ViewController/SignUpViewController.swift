//
//  SignUpViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpProfileImageView: UIImageView!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpNicknameTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpBackBtn: UIButton!
    @IBOutlet weak var signUpCompletionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTarget()
    }
    
    func settingTarget() {
        
        signUpBackBtn.addTarget(self, action: #selector(self.pressedBackBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }

}
