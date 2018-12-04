//
//  SignUpViewController.swift
//  Proj
//
//  Created by Darkidan on 23/11/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var addImageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeBtnImage(image: UIImage(named: "TODO: add defult image name")!)
    }
    
    @IBAction func addImage(_ sender: Any) {
        //TODO get new image
        //let image = newImage
        //   changeBtnImage(image)
    }
    
    func changeBtnImage(image: UIImage){
        addImageBtn.setImage(image, for: .normal)
    }
}
