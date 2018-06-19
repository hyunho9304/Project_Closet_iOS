//
//  Extension.swift
//  Closet_iOS
//
//  Created by 박현호 on 2018. 6. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

/*
 Description : extension 함수 정의
*/

import Foundation
import UIKit

extension UIViewController {
    func gsno(_ value: String?) -> String {
        return value ?? ""
    }
    
    func gino(_ value: Int?) -> Int {
        return value ?? 0
    }
    
}

extension NSObject {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
