//
//  SignUpViewController.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnChooseAvatar: UIButton!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var registerBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var image:UIImage?
    var random: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.random = randomNumber(MIN: 0, MAX: 100000)
        self.spinner.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func randomNumber(MIN: Int, MAX: Int)-> String{
        return String(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN));
    }
    
    
    func signUpUser(email: String, password: String,url: String){

        User_Manager.instance.signUpUser(email: emailLabel.text!, password: password, username: usernameLabel.text!, url: url ,onSuccess: {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateInitialViewController()
                            self.present(vc!, animated: true, completion: nil)
        }) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let username = usernameLabel.text, !username.isEmpty else {
            alert(title: "Username Error", message: "Username is empty")
            return
        }
        guard let password = passwordLabel.text, !password.isEmpty else {
                alert(title: "Password Error", message: "Password is empty")
                return
        }
        guard let confirmPass = confirmPasswordLabel.text, !confirmPass.isEmpty else {
                alert(title: "Confirm Password Error", message: "Confirm Password is empty")
                return
        }
        guard password == confirmPass else {
            alert(title: "Password Error", message: "Passwords does not match")
            return
        }
        guard let email = emailLabel.text, !email.isEmpty else {
            alert(title: "Email Error", message: "Email is empty")
            return
        }
        guard let email2 = emailLabel.text, email2.contains("@") else {
            alert(title: "Email Error", message: "Email is missing @")
            return
        }
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        if image != nil {
            User_Manager.instance.saveImage(image: image!, text: "avatar" + self.random){ (url:String?) in
                var _url = ""
                if url != nil {
                    _url = url!
                }
                self.signUpUser(email: self.emailLabel.text!, password: self.passwordLabel.text!,url: _url)
            }
        }else{
           self.signUpUser(email: self.emailLabel.text!, password: self.passwordLabel.text!,url: "")
        }
    }
    
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Avatar For User //
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Design the avatar
        self.imgAvatar.contentMode = .scaleAspectFill
        self.imgAvatar.layer.cornerRadius = 50
        self.imgAvatar.clipsToBounds = true
    }
    
    @IBAction func btnChooseAvatarOnClick(_ sender: UIButton) {
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
    
    //MARK: - Choose image from camera roll
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        image = info[.originalImage] as? UIImage
        self.imgAvatar.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
