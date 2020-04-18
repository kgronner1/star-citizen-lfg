//
//  myGroupTableViewCell.swift
//  Star Citizen Crew Finder
//
//  Created by Kyler Gronner on 4/5/20.
//  Copyright © 2020 Kyler Gronner. All rights reserved.
//

import UIKit

class myGroupTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mygroupcellContentView: UIView!
    @IBOutlet weak var mygroupNameLabel: UILabel!
    @IBOutlet weak var mygroupShipLabel: UILabel!
    @IBOutlet weak var mygroupLocationLabel: UILabel!
    @IBOutlet weak var mygroupCurrCountLabel: UILabel!
    @IBOutlet weak var mygroupLeaveButton: UIButton!
    @IBOutlet weak var mygroupPeopleButton: UIButton!
    
    func setMyGroup(group: Group){
        //print("Got here")
        mygroupNameLabel.text = group.name
        mygroupShipLabel.text = group.ship
        mygroupLocationLabel.text = group.location
        mygroupCurrCountLabel.text = String(group.currCount) + "/" + String(group.maxPlayers)
    }

    
    
    struct celledGroup {
        var opened = Bool()
    }

}
