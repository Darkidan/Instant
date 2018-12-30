//
//  CreateNewFeedViewController.swift
//  Proj
//
//  Created by Darkidan on 30/12/2018.
//  Copyright © 2018 Darkidan. All rights reserved.
//

import UIKit

class CreateNewFeedViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var imagePicker = UIImagePickerController()
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func CreateFeed(_ sender: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        if image != nil {
            User_Manager.instance.saveImage(image: image!, text: "photo" + randomNumber(MIN: 0, MAX: 100000)){ (url:String?) in
                var _url = ""
                if url != nil {
                    _url = url!
                }
                self.saveFeedInfo(url: _url)
            }
        }else{
            self.saveFeedInfo(url: "")
        }
    }
    
    func saveFeedInfo(url:String)  {
        let feed = Feed(_id: "photo" + randomNumber(MIN: 0, MAX: 100000), _username: "", _urlImage: url, _likes: "0", _text: textField.text!)
        User_Manager.instance.addNewFeed(feed: feed)
        self.navigationController?.popViewController(animated: true)
    }
    
    func randomNumber(MIN: Int, MAX: Int)-> String{
        return String(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN));
    }
    
    // Avatar For User //
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Design the avatar
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.cornerRadius = 50
        self.imageView.clipsToBounds = true
    }
    
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else{
            let alert = UIAlertController(title: "Warning", message: "You don't have a camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        image = info[.originalImage] as? UIImage
            self.imageView.image = image
            self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
    
}