//
//  CreateGroupViewController.swift
//  Star Citizen Crew Finder
//
//  Created by Kyler Gronner on 3/28/20.
//  Copyright © 2020 Kyler Gronner. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var createGroupOuterView: UIView!
    @IBOutlet weak var createGroupStackView: UIStackView!
    @IBOutlet weak var groupNameInput: UITextField!
    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var shipPicker: UIPickerView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var createGroupLabel: UILabel!
    @IBOutlet weak var currentGroupNumberLabel: UILabel!
    @IBOutlet weak var currentGroupNumberPicker: UIPickerView!
    
    
    var shipsArr = [Ship]()
    var locationsArr = [Location]()
    var playerNeededNumbers = [Int](1...100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationPicker.delegate = self
        locationPicker.dataSource = self
        shipPicker.delegate = self
        shipPicker.dataSource = self
        
        getPickerDataIntoArrays()
        
    }

    
    func createGroup() {
        
        let groupName = groupNameInput.text!
        let groupShip = shipPicker.selectedRow(inComponent: 0)
        let groupCurr = 1
        let playersNeeded = currentGroupNumberPicker.selectedRow(inComponent: 0)
        let maxPlayers = 1 + Int(playersNeeded)
        let groupLocation = locationPicker.selectedRow(inComponent: 0)
        let userEmail = UserDefaults.standard.string(forKey: "email")
        let screenName = UserDefaults.standard.string(forKey: "screenName")
        var creator = ""
        
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: userEmail).getDocuments{ (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in (snapshot!.documents){
                    if let reScreenName = document.data()["screenName"] as? String {
                        if screenName == reScreenName {
                            let document = document.documentID
                            var creator = document

                            let playerList = [creator]
                            let createdBy = creator
                            
                            // find the max number of players in the group based on the ship
                            let groupShipName = self.shipsArr[groupShip].name
                            //let maxPlayers = self.shipsArr[groupShip].maxPlayers
                            
                            let groupRole = self.shipsArr[groupShip].role
                            
                            let groupLocationName = self.locationsArr[groupLocation].name
                            
                            // convert Date to TimeInterval (typealias for Double)
                            let timeInterval = Date().timeIntervalSince1970

                            // convert to Integer
                            let DateAsInt = Int(timeInterval)
                            
                            db.collection("groups").addDocument(data: ["active": true, "currCount": groupCurr, "location": groupLocationName, "maxPlayers": maxPlayers, "name": groupName, "playerList": playerList, "ship": groupShipName, "createdBy": createdBy, "timeCreated": DateAsInt]) { error in

                                if error != nil {
                                    self.showError("Error saving group data")
                                }
                                else {
                                   // transition to home screen
                                   self.transitionToHome()

                                }

                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func getPickerDataIntoArrays() {
        var tempShipsArray: [Ship] = []
        var tempLocationsArray: [Location] = []

        
        let db = Firestore.firestore()
        
        // read doc
        db.collection("ships").order(by: "name", descending: true).getDocuments{ (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in (snapshot!.documents){

                    let reRole = document.data()["role"] as? String
                    let reMaxPlayers = document.data()["maxPlayers"] as? Int

                    if let reShip = document.data()["name"] as? String {
                        let ship = Ship(name:reShip, role:reRole!, maxPlayers: reMaxPlayers ?? 100)
                            tempShipsArray.append(ship)

                    }
                }
            }
            self.shipsArr = tempShipsArray
            self.shipPicker.reloadAllComponents()
        }

        db.collection("locations").order(by: "name", descending: true).getDocuments{ (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in (snapshot!.documents){
                    if let reLocation = document.data()["name"] as? String {
                            let location = Location(name:reLocation)
                            tempLocationsArray.append(location)
                    }
                }
            }
            self.locationsArr = tempLocationsArray
            self.locationPicker.reloadAllComponents()
        }
    }
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == shipPicker {
            return shipsArr.count
        }
        else if pickerView == locationPicker {
            return locationsArr.count
        }
        else { //pickerView == currentGroupNumberPicker
            return playerNeededNumbers.count
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == shipPicker {
//            // change the max on current players possible
//            print("redo max num")
//            var maxNum = shipsArr[row].maxPlayers - 1
//            if maxNum >= 1 {
//                playerNeededNumbers = [Int](1...maxNum)
//                self.currentGroupNumberPicker.reloadAllComponents()
//            }
//        }
//    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == shipPicker {
            return shipsArr[row].name
        }
        else if pickerView == locationPicker {
            return locationsArr[row].name
        }
        else { //pickerView == currentGroupNumberPicker
            return String(playerNeededNumbers[row])
        }
        
    }
    
    @IBAction func createGroupButtonTapped(_ sender: Any) {
        print("write to db")
        createGroup()
    }
    
    func showError(_ message:String) {
        errorTextLabel.text = message
        errorTextLabel.alpha = 1
    }
    
    
    func transitionToHome(){
       //self.performSegue(withIdentifier: "segueToTabs1", sender: nil)
        
        
        let alertTitle = "Hey"
        let alertMessage = "OK you joined a team"

        let alert = UIAlertController(title:alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Nice", style: .default, handler: nil ))
        present(alert, animated: true, completion: nil )
    }
    
    
    
}
