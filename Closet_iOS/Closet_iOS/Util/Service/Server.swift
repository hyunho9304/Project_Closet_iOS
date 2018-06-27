//
//  Server.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct Server : APIService {
    
    //  회원가입
    static func reqSignUp( email : String , password : String , nickname : String , profile : UIImage , completion : @escaping (_ status : Int) -> Void ) {
        
        let URL = url( "/member/signup" )
        
        let emailData = email.data(using: .utf8 )
        let passwordData = password.data(using: .utf8 )
        let nicknameData = nickname.data(using: .utf8 )
        let profileData = UIImageJPEGRepresentation(profile , 0.3)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append( emailData! , withName : "member_email" )
            multipartFormData.append(passwordData!, withName: "member_password")
            multipartFormData.append(nicknameData!, withName: "member_nickname")
            multipartFormData.append(profileData!, withName: "member_profile" , fileName:"member_profile.jpg" , mimeType : "image/jpeg")
            
        }, to: URL, method: .post, headers: nil) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(request: let upload , streamingFromDisk: _, streamFileURL: _) :
                
                upload.responseData(completionHandler: { (res) in
                    switch res.result {
                        
                    case .success :
                        
                        if( res.response?.statusCode == 201){
                            completion(201)
                        }
                        else if( res.response?.statusCode == 401 ) {
                            completion(401)
                        }
                        else {
                            completion(500)
                        }
                        
                        break
                        
                    case.failure(let err) :
                        print( err.localizedDescription)
                    }
                })
                
            case .failure(let err ) :
                print( err.localizedDescription)
            }
        }
    }
    
    //  로그인
    static func reqSignIn( email : String , password : String , completion : @escaping (_ status : Int , _ flag : Int) -> Void ) {
        
        let URL = url( "/member/signin" )
        
        let body: [String: Any] = [
            "member_email" : email ,
            "member_password" : password
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if( res.response?.statusCode == 201 ){
                    completion( 201 , 0 )
                }
                else if( res.response?.statusCode == 401 ) {
                    
                    if let value = res.result.value {
                        let message = JSON(value)["message"].string
                        
                        if message == "failed login_email"{
                            completion( 401 , 1 )
                        }
                        else if message == "failed login_password" {
                            completion( 401 , 2 )
                        }
                    }
                }
                else {
                    completion(500 , 0 )
                }
                break
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //  새옷 등록
    static func reqClosetUpload( closet_type : String , closet_memo : String , closet_image : UIImage , completion : @escaping (_ status : Int) -> Void ) {
        
        let URL = url( "/closet/upload" )
        
        let userdefault = UserDefaults.standard
        guard let member_email = userdefault.string( forKey: "member_email" ) else { return }
        
        let member_emailData = member_email.data(using: .utf8 )
        let closet_typeData = closet_type.data(using: .utf8 )
        let closet_memoData = closet_memo.data(using: .utf8 )
        let closet_imageData = UIImageJPEGRepresentation(closet_image , 0.3)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append( member_emailData! , withName : "member_email" )
            multipartFormData.append( closet_typeData!, withName: "closet_type")
            multipartFormData.append( closet_memoData!, withName: "closet_memo")
            multipartFormData.append( closet_imageData!, withName: "closet_image" , fileName:"closet_image.jpg" , mimeType : "image/jpeg")
            
        }, to: URL, method: .post, headers: nil) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(request: let upload , streamingFromDisk: _, streamFileURL: _) :
                
                upload.responseData(completionHandler: { (res) in
                    switch res.result {
                        
                    case .success :
                        
                        if( res.response?.statusCode == 201){
                            completion(201)
                        }
                        else {
                            completion(500)
                        }
                        
                        break
                        
                    case.failure(let err) :
                        print( err.localizedDescription)
                    }
                })
                
            case .failure(let err ) :
                print( err.localizedDescription)
            }
        }
    }

    
}
