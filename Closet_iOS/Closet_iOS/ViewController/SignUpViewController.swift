//
//  SignUpViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

/*
 Description : 회원가입 진행시 진행되는 뷰컨트롤러
*/

import UIKit

class SignUpViewController: UIViewController , Gallery {

    var homeController: UIViewController?
    let imagePicker : UIImagePickerController = UIImagePickerController()

    @IBOutlet weak var signUpProfileImageView: UIImageView!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpNicknameTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpBackBtn: UIButton!
    @IBOutlet weak var signUpCompletionBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
    }
    
    func setting() {
        
        homeController = self
        
        signUpBackBtn.addTarget(self, action: #selector(self.pressedBackBtn(_:)), for: UIControlEvents.touchUpInside)
        signUpCompletionBtn.addTarget(self, action: #selector(self.pressedSignUpBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @IBAction func openImagePicker(_ sender: Any) {
        
        openGalleryCamera()
    }
    
    
    //  뒤로가기버튼 클릭
    @objc func pressedBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    //  회원가입 진행
    @objc func pressedSignUpBtn( _ sender : UIButton ) {
        
        if( !(signUpEmailTextField.text?.isEmpty)! && !( (signUpPasswordTextField.text?.isEmpty)!) && !( (signUpNicknameTextField.text?.isEmpty)!) ) {
            
            Server.reqSignUp(email: signUpEmailTextField.text! , password: signUpPasswordTextField.text! , nickname: signUpNicknameTextField.text! , profile: signUpProfileImageView.image!) { (rescode) in
                
                if rescode == 201 {
                    
                    let alert = UIAlertController(title: "회원가입 성공", message: "환영환영", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: { (_) in
                        
                        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                        
                        self.present( homeVC , animated: true , completion: nil )
                        
                    } )
                    
                    alert.addAction( ok )
       
                    self.present(alert , animated: true , completion: nil)
                    
                } else if rescode == 401 {
                    
                    let alert = UIAlertController(title: "이메일중복", message: "다시 입력하거라", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인하거라", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            }
            
        } else {
            
            let alert = UIAlertController(title: "회원가입", message: "모두 입력해주세요", preferredStyle: .alert )
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
            
            alert.addAction( ok )
            
            present( alert , animated: true , completion: nil )
        }
    }

}

extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.dismiss(animated: true, completion:  {self.customFunction(image: pickedImage)} )
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func customFunction(image: UIImage) {
        signUpProfileImageView.image = image
    }
}
