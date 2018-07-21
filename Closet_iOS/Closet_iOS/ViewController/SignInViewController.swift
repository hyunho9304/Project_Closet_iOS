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
        hideKeyboardWhenTappedAround()
    }
    
    func settingTarget() {
        
        signUpBtn.addTarget(self, action: #selector(self.pressedSignUpBtn(_:)), for: UIControlEvents.touchUpInside)
        signInBtn.addTarget(self, action: #selector(self.pressedSignInBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedSignUpBtn( _ sender : UIButton ) {
        
        guard let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        
        self.present( signUpVC , animated: true , completion: nil )
    }
    
    @objc func pressedSignInBtn( _ sender : UIButton ) {
        
        if( !(emailTextField.text?.isEmpty)! && !( (passwordTextField.text?.isEmpty)!) ) {
            
            userdefault.set(gsno(emailTextField.text), forKey: "member_email")
            
            Server.reqSignIn(email: emailTextField.text! , password: passwordTextField.text!) { (rescode , flag ) in
                
                if rescode == 201 {
                    
                    let myHomeVCtap = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "myHomeVCtap")

                    self.present( myHomeVCtap , animated: true , completion: nil )
                    
                } else if rescode == 401 {
                    
                    if flag == 1 {
                        
                        
                        let alert = UIAlertController(title: "로그인 실패", message: "이메일이 없습니다", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                        alert.addAction( ok )
                        self.present(alert , animated: true , completion: nil)
                        
                    }
                    else if flag == 2 {
                        
                        let alert = UIAlertController(title: "로그인 실패", message: "비밀번호 틀렸는데요..?", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                        alert.addAction( ok )
                        self.present(alert , animated: true , completion: nil)
                        
                        
                    }
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
        } else {
            
            let alert = UIAlertController(title: "로그인", message: "이메일과 비밀번호를 입력해주세요!!", preferredStyle: .alert )
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
            
            alert.addAction( ok )
            
            present( alert , animated: true , completion: nil )
        }
    }
}
