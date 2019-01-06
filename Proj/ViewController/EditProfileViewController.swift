//
//  EditProfileViewController.swift
//  Instant
//
//  Copyright © 2018-2019 All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var chooseAvatar: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var confirmNewPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    var imagePicker = UIImagePickerController()
    var image:UIImage?
    var user: User?
    var urlFromUser = UserDefaults.standard.string(forKey: "AvatarName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        User_Manager.instance.getUser { (user) in
            self.usernameText.text = user.username
            self.emailText.text = user.email
            
            if user.url != "" {
                User_Manager.instance.getImage(url: user.url) { (image:UIImage?) in
                    if image != nil {
                        self.avatar.image = image!
                    }
                }
            }
            self.spinner.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.avatar.contentMode = .scaleAspectFill
        self.avatar.layer.cornerRadius = 50
        self.avatar.clipsToBounds = true
    }
    
    @IBAction func editProfile(_ sender: Any) {
        guard self.newPasswordText.text == self.confirmNewPasswordText.text else {
            alert(title: "Password Error", message: "Passwords does not match")
            return
        }
        
        let avatarName = UserDefaults.standard.string(forKey: "AvatarName")

        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        if image != nil {
            User_Manager.instance.editImage(image: image!, text: avatarName!){ (url:String?) in
                var _url = ""
                if url != nil {
                    _url = url!
                }
                self.EditUserInfo(url: _url)
            }
        } else {
            self.EditUserInfo(url: (user?.url)!)
        }
        print("User was edited!")
    }
    
    func EditUserInfo(url:String)  {
        let userid = User_Manager.instance.user?.id
        
       // User_Manager.instance.saveFeedsForUser{ (feeds) in
       
        if self.newPasswordText.text! != "" {
            User_Manager.instance.ChangePass(password: self.newPasswordText.text!)
        }
        let user = User(_id: userid!, _username: self.usernameText.text!, _email: self.emailText.text!, _url: url)
        User_Manager.instance.EditUser(user: user)
        self.navigationController?.popViewController(animated: true)
    }
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Camera + Gallery
    
    @IBAction func chooseAvatar(_ sender: Any) {
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
        self.avatar.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
