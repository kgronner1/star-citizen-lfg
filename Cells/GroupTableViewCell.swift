//
//  GroupTableViewCell.swift
//  Star Citizen Crew Finder
//
//  Created by Kyler Gronner on 3/29/20.
//  Copyright © 2020 Kyler Gronner. All rights reserved.
//

import UIKit


class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupcellContentView: UIView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupShipLabel: UILabel!
    @IBOutlet weak var groupCurrCountLabel: UILabel!
    @IBOutlet weak var groupLocationLabel: UILabel!
    @IBOutlet weak var groupJoinButton: UIButton!

    
    func setGroup(group: Group){
        //print("Got here")
        groupNameLabel.text = group.name
        groupShipLabel.text = group.ship
        groupLocationLabel.text = group.location
        groupCurrCountLabel.text = String(group.currCount) + "/" + String(group.maxPlayers)
    }
    
    
    struct celledGroup {
        var opened = Bool()
    }
    
    
}
