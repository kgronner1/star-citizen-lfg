//
//  LoginViewController.swift
//  Star Citizen Crew Finder
//
//  Created by Kyler Gronner on 3/24/20.
//  Copyright © 2020 Kyler Gronner. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
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
         if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
             passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
         {
             return "Please fill in all fields."
         }

         //check email is correct
         let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
         if Utilities.isEmailValid(cleanedEmail) == false {
             return "Please make sure your email is valid and correct."
         }
         
         
         return nil
     }

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        
        // validate fields
        let error = validateFields()
        
        
        if error != nil {
            // if something wrong show error message
            showError(error!)
        }
        else {
            let screenName = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let userEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let userPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create the user
            Auth.auth().signIn(withEmail: userEmail, password: userPassword) { (results, err) in
                //check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError("Error logging in user")
                }
                else {
                    
                    Firestore.firestore().collection("users").whereField("email", isEqualTo: userEmail).getDocuments{ (snapshot, error) in
                    if error == nil && snapshot != nil {
                        for document in (snapshot!.documents){
                            if let reScreenName = document.data()["screenName"] as? String {
                                print(reScreenName)
                                UserDefaults.standard.set("\(reScreenName)", forKey: "screenName")
                                UserDefaults.standard.set("\(userEmail)", forKey: "email")
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                    // transition to home screen
                    self.transitionToHome()
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
      func showError(_ message:String) {
          errorLabel.text = message
          errorLabel.alpha = 1
      }
      
      func transitionToHome(){
        self.performSegue(withIdentifier: "segueToTabs2", sender: nil)
      }
    
    
}
