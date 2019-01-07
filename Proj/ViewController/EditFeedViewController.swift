//
//  EditFeedViewController.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditFeedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var editButton: UIButton!

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imagePicker = UIImagePickerController()
    var image:UIImage?
    var feedID: String?
    var imageURL: String?
    var beforeText: String?
    var user: User?
    var random: String = ""
    var once = true
    
    override func viewDidLoad() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        self.random = randomNumber(MIN: 0, MAX: 100000)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if ( once ){
            User_Manager.instance.getFeed(feedId: feedID!, onSuccess: { (feed) in
                
                self.textField.text = self.beforeText
                
                if self.imageURL != "" {
                    User_Manager.instance.getImage(url: self.imageURL!) { (image:UIImage?) in
                        if image != nil {
                            self.imageView.image = image!
                        }
                    }
                }
                self.spinner.isHidden = true
                self.once = false
            })
        }
    }
    
    @IBAction func EditClicked(_ sender: Any) {
        let ref = Database.database().reference()
        self.editButton.isHidden = true
        if image != nil {
            User_Manager.instance.saveImage(image: image!, text: "photo" + self.random){ (url:String?) in
                var _url = ""
                if url != nil {
                    _url = url!
                    ref.child("Feeds").child(self.feedID!).updateChildValues(["text": self.textField.text!,
                                                                              "urlImage":_url])
                    //self.editButton.isEnabled = false
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            ref.child("Feeds").child(self.feedID!).updateChildValues(["text": self.textField.text!])
            //self.editButton.isEnabled = false
            self.dismiss(animated: true, completion: nil)
        }
        
        self.spinner.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func randomNumber(MIN: Int, MAX: Int)-> String{
        return String(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN));
    }
    // Camera + Gallery
    
    @IBAction func chooseFeedImage(_ sender: Any) {
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
