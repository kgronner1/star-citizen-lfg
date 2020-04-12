//
//  SignUpViewController.swift
//  Star Citizen Crew Finder
//
//  Created by Kyler Gronner on 3/24/20.
//  Copyright © 2020 Kyler Gronner. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    

    @IBOutlet weak var screenNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        // Hide the error label
        errorLabel.alpha = 0
        
        // styles the elements
        //Utilities.styleTextField(usernameTextField)
    }

    // check fields and validate
    // if correct returns nil
    // if not returns err as string
    func validateFields() -> String? {
        
        // check all fields filled in
        if screenNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        
        //check password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }

        //check email is correct
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanedEmail) == false {
            return "Please make sure your email is valid and correct."
        }
        
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        
        // validate fields
        let error = validateFields()
        
        
        if error != nil {
            // if something wrong show error message
            showError(error!)
        }
        else {
            
            let userEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let userPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let screenName = screenNameTextField.text!
            
            // create the user
            Auth.auth().createUser(withEmail: userEmail, password: userPassword) { (results, err) in
                //check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    // User created successfully
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["screenName": screenName, "email": userEmail, "timeCreated": NSDate().timeIntervalSince1970]) { error in
                        
                        if error != nil {
                            self.showError("Error saving user data")
                        }
                        else {
                            UserDefaults.standard.set("\(screenName)", forKey: "screenName")
                           
                            UserDefaults.standard.set("\(userEmail)", forKey: "email")
                            UserDefaults.standard.synchronize()
                        }
                        
                    }
                    
                    // transition to home screen
                    self.transitionToHome()
                    
                }
            }
            
        }
        
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
       self.performSegue(withIdentifier: "segueToTabs1", sender: nil)
    }
    
}
