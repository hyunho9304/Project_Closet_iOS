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
    
    //  keyboard
    @IBOutlet var mainView: UIView!
    var keyboardUp : Bool!
    var keyboardDismissGesture: UITapGestureRecognizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
        setKeyboardSetting()
    }
    
    func setting() {
        
        homeController = self
        keyboardUp = false
        
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

//  겔러리 , 카메라
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


//  키보드
extension SignUpViewController {
    
    func setKeyboardSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: true)
        
        if keyboardUp == false {
         
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                mainView.frame.origin.y -= keyboardSize.height
                self.view.layoutIfNeeded()
                keyboardUp = true
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        adjustKeyboardDismissGesture(isKeyboardVisible: false)
        
        if keyboardUp == true {
         
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

                mainView.frame.origin.y += keyboardSize.height
                self.view.layoutIfNeeded()
                keyboardUp = false
            }
        }
    }
    
    func adjustKeyboardDismissGesture(isKeyboardVisible: Bool) {
        if isKeyboardVisible {
            if keyboardDismissGesture == nil {
                keyboardDismissGesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground))
                view.addGestureRecognizer(keyboardDismissGesture!)
            }
        } else {
            if keyboardDismissGesture != nil {
                view.removeGestureRecognizer(keyboardDismissGesture!)
                keyboardDismissGesture = nil
            }
        }
    }
    
    @objc func tapBackground() {
        self.view.endEditing(true)
    }
}

