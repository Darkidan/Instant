//
//  CustomViewController.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func setDate(dateTime:Double)-> String{
        let date = NSDate(timeIntervalSince1970: (dateTime)/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date as Date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "dd/MM/yy, HH:mm"
        let finaldate = formatter.string(from: yourDate!)
        return finaldate
    }

}
