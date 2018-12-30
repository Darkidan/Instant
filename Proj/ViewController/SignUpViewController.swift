//
//  SignUpViewController.swift
//  Instant
//
//  Copyright © 2018 All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnChooseAvatar: UIButton!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var registerBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func signUpUser(email: String, password: String){
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        User_Manager.instance.signUpUser(email: emailLabel.text!, password: password, username: usernameLabel.text!, url: "" ,onSuccess: {
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
            alert(title: "Password Error", message: "Password does not match")
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
        signUpUser(email: emailLabel.text!, password: passwordLabel.text!)
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
}

extension SignUpViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.imgAvatar.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.imgAvatar.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
