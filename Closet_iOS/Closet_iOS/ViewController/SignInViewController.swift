//
//  SignInViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

/*
 Description : 로그인 화면으로 시작하면 뜨는 화면이다.
*/

import UIKit

class SignInViewController: UIViewController {

    let userdefault = UserDefaults.standard
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTarget()

    }
    
    func settingTarget() {
        
        signUpBtn.addTarget(self, action: #selector(self.signUp(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func signUp( _ sender : UIButton ) {
        
        guard let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        
        self.present( signUpVC , animated: true , completion: nil )
    }

}
