//
//  ClosetUploadViewController.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 27..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ClosetUploadViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource , Gallery {
    
    var homeController: UIViewController?
    let imagePicker : UIImagePickerController = UIImagePickerController()
    
    @IBOutlet weak var closetUploadBackBtn: UIButton!
    @IBOutlet weak var closetUploadCompletionBtn: UIButton!
    @IBOutlet weak var closetUploadImageView: UIImageView!
    @IBOutlet weak var closetUploadTypeTextField: UITextField!
    @IBOutlet weak var closetUploadMemoTextField: UITextView!
    
    let typePickerView = UIPickerView()
    let typeArray : [String] = [ "OUTER" , "TOP" , "BLOUSE" , "BOTTOM" , "ACC" , "SHOES" ]
    
    //  keyboard
    @IBOutlet var mainView: UIView!
    var keyboardUp : Bool!
    var keyboardDismissGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTarget()
        setKeyboardSetting()
    }
    
    func settingTarget() {
        
        homeController = self
        
        keyboardUp = false
        
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
        closetUploadBackBtn.addTarget(self, action: #selector(self.pressedClosetUploadBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        closetUploadCompletionBtn.addTarget(self, action: #selector(self.pressedClosetUploadCompletionBtn(_:)), for: UIControlEvents.touchUpInside)
        
        setType(textField: closetUploadTypeTextField , selector: #selector(selectedTypePicker), inputView: typePickerView)
    }
    
    @IBAction func openImagePicker(_ sender: Any) {
    
        openGalleryCamera()
    }
    
    
    //  뒤로가기 버튼 클릭
    @objc func pressedClosetUploadBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    //  새옷 업로드버튼 클릭
    @objc func pressedClosetUploadCompletionBtn( _ sender : UIButton ) {
        
        if( !(closetUploadTypeTextField.text?.isEmpty)! && !( (closetUploadMemoTextField.text?.isEmpty)!) &&  (closetUploadImageView.image != #imageLiteral(resourceName: "uploadImage.png") )) {
            
            Server.reqClosetUpload(closet_type: closetUploadTypeTextField.text! , closet_memo: closetUploadMemoTextField.text! , closet_image: closetUploadImageView.image!) { (rescode) in
                
                if rescode == 201 {
                    
                    let alert = UIAlertController(title: "옷 등록", message: "새 옷을 등록하였습니다^^", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: { (_) in self.dismiss(animated: true, completion: nil ) } )
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
            
            let alert = UIAlertController(title: "옷 등록", message: "모두 입력해주세요", preferredStyle: .alert )
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
            
            alert.addAction( ok )
            
            present( alert , animated: true , completion: nil )
        }
        
    }
    
    func setType(textField:UITextField, selector : Selector, inputView : Any){
        
        let bar = UIToolbar()
        bar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "확인", style: .done
            , target: self, action: selector)
        
        bar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = bar
        
        
        if let tempView = inputView as? UIPickerView {    //  UIView
            textField.inputView = tempView
        }
        if let tempView = inputView as? UIDatePicker { //  UIControl
            textField.inputView = tempView
        }
    }
    
    @objc func selectedTypePicker(){
        
        let row = typePickerView.selectedRow(inComponent: 0)
        
        closetUploadTypeTextField.text = typeArray[row]

        view.endEditing(true)
    }
    
//  ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡdelegate & datasource ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return typeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return typeArray[row]
    }
}

//  카메라 , 겔러리
extension ClosetUploadViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
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
        closetUploadImageView.image = image
    }
}


//  키보드
extension ClosetUploadViewController {
    
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

