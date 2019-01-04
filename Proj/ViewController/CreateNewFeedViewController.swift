//
//  CreateNewFeedViewController.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import UIKit

class CreateNewFeedViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    var image:UIImage?
    var random: String = ""
    var usernameText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.random = randomNumber(MIN: 0, MAX: 100000)
        self.spinner.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func CreateFeed(_ sender: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        if image != nil {
            User_Manager.instance.saveImage(image: image!, text: "photo" + self.random){ (url:String?) in
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
        let userid = UserDefaults.standard.string(forKey: "uid")
        self.usernameText = UserDefaults.standard.string(forKey: "Username")!
        let feed = Feed(_id: "feed" + self.random, _username: self.usernameText, _urlImage: url, _likes: "0", _text: textField.text!,_uid: userid!)
        User_Manager.instance.user?.feeds?.append(feed)
        User_Manager.instance.addNewFeed(feed: feed)
        self.navigationController?.popViewController(animated: true)
    }
    
    func randomNumber(MIN: Int, MAX: Int)-> String{
        return String(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN));
    }
    
    // Avatar For User //
    
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
