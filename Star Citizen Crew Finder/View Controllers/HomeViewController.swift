//
//  HomeViewController.swift
//  Star Citizen Crew Finder
//
//  Created by Kyler Gronner on 3/24/20.
//  Copyright © 2020 Kyler Gronner. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var myGroupsTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myGroupsLabel: UILabel!
    @IBOutlet weak var openGroupsLabel: UILabel!
    @IBOutlet weak var noGroupsLabel: UILabel!
    
    
    var groups = [Group]()
    var mygroups = [Group]()
    let dispoop = DispatchGroup()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // used to test that its setting correctly
//        UserDefaults.standard.set(nil, forKey: "screenName")


        // Do any additional setup after loading the view.
        setUpElements()
        
        getGroupDataIntoArray()
        
    }

    func setUpElements(){

        // styles the elements
        //Utilities.styleTextField(usernameTextField)
    }

    func getGroupDataIntoArray() {
        dispoop.enter()
        var tempGroupArray: [Group] = []
        var tempMyGroupArray: [Group] = []
        
        let db = Firestore.firestore()
        // read doc
        db.collection("groups").whereField("active", isEqualTo: true).order(by: "currCount", descending: true).getDocuments{ (snapshot, error) in
        
            if error == nil && snapshot != nil {

                
                //, "active", "currCount", "location", "maxPlayers", "playerList", "ship", "timeCreated"
                
                for document in (snapshot!.documents){
                    //let reName = document.data()["name"] as! String
                    let reActive = document.data()["active"] as! Bool
                    let reCurrCount = document.data()["currCount"] as! Int
                    let reLocation = document.data()["location"] as! String
                    let reMaxPlayers = document.data()["maxPlayers"] as! Int
                    let rePlayerList = document.data()["playerList"] as! [String]
                    let reShip = document.data()["ship"] as! String
                    let reTimeCreated = document.data()["timeCreated"] as! Int
                    
                    
                    if let reName = document.data()["name"] as? String {
                        //let user = NStore(username)
                        let groupName = Group(name:reName, active:reActive, currCount:reCurrCount,location:reLocation, maxPlayers:reMaxPlayers, playerList: rePlayerList, ship: reShip, timeCreated: reTimeCreated, isExpanded: false)
                        
                        
                        if reMaxPlayers != reCurrCount {
                            tempGroupArray.append(groupName)
                        }
                        
                        if reName == "new" {
                            tempMyGroupArray.append(groupName)
                        }
                        
                    }
                    
                    
                    
                }
                self.dispoop.leave()
                
                self.dispoop.notify(queue: .main) {
                    self.groups = tempGroupArray
                    self.mygroups = tempMyGroupArray
                    self.tableView.reloadData()
                    self.myGroupsTableView.reloadData()
//                    print("Count afty")
//                    print(self.groups.count)
                }
                
            }
        }

//        return tempGroupArray

    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == myGroupsTableView {
            return self.mygroups.count;
        }
        else {
            if groups.count == 0 { // there are no groups
                tableView.alpha = 0
                noGroupsLabel.alpha = 1
            }
            else {
                tableView.alpha = 1
                noGroupsLabel.alpha = 0
            }
            return self.groups.count;
        }
        
        
//        return groups.count
    
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == myGroupsTableView {
            let grp = mygroups[indexPath.row]
            print("truedMyGRoup")
            let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupsCell") as! myGroupTableViewCell
            
            cell.setMyGroup(group: grp)
            cell.mygroupLeaveButton.tag = indexPath.row
            cell.mygroupLeaveButton.addTarget(self, action: #selector(mygroupCellWasTapped(sender:)), for: .touchUpInside)

            cell.mygroupPeopleButton.tag = indexPath.row
            cell.mygroupPeopleButton.addTarget(self, action: #selector(mygroupCellExpandWasTapped(sender:)), for: .touchUpInside)
            
            
            return cell
        }
        else {
            let grp = groups[indexPath.row]
            print("falsedOpenGroup")
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "groupCell") as! GroupTableViewCell
            
            cell2.setGroup(group: grp)
            cell2.groupJoinButton.tag = indexPath.row
            cell2.groupJoinButton.addTarget(self, action: #selector(groupCellWasTapped(sender:)), for: .touchUpInside)
            
            return cell2
        }

        //return cell
    }
    

    @objc
    func mygroupCellExpandWasTapped(sender:UIButton) {
        print("try to expand")
        
        let rowIndex:Int = sender.tag
        
        // at this key of array, do the database stuff

        let selGroup = groups[rowIndex]
        
        print(selGroup.playerList.count)
        
        var indexPaths = [Int]()
        for row in selGroup.playerList {
            print(rowIndex, row)
            
//            Firestore.firestore().collection("users").document(row).getDocument(){ (snapshot, error) in
//                if error == nil && snapshot != nil {
//                    for document in (snapshot!.data()!) {
//                        if let reScreenName = document.["screenName"] as? String {
//                            print(reScreenName)
//                            let indexPath = IndexPath(row: rowIndex, userID: row, screenName: reScreenName)
//                            indexPaths.append(row)
//                        }
//                    }
//                }
//            }
            
            
//            let indexPath = row
//            indexPaths.append(rowIndex, indexPath)
            
        }
        
        // if fail
    }



    @objc
    func groupCellWasTapped(sender:UIButton) {
        let rowIndex:Int = sender.tag
        
        // at this key of array, do the database stuff

        let selGroup = groups[rowIndex]
        
        // add to group
            
        // if successful
            let alertTitle = "Hey"
            let alertMessage = "OK you join \(selGroup.name)"

            let alert = UIAlertController(title:alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Nice", style: .default, handler: nil ))
            present(alert, animated: true, completion: nil )
            self.tableView.reloadData()
        // if fail
    }
    
    @objc
    func mygroupCellWasTapped(sender:UIButton) {
        let rowIndex:Int = sender.tag
        
        // at this key of array, do the database stuff

        let selGroup = mygroups[rowIndex]
        
        // leave the group
            
        // if successful
            let alertTitle = "Hey"
            let alertMessage = "OK you leave \(selGroup.name)"

            let alert = UIAlertController(title:alertTitle, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Nice", style: .default, handler: nil ))
            present(alert, animated: true, completion: nil )
            self.myGroupsTableView.reloadData()
        // if fail
    }
    

}
