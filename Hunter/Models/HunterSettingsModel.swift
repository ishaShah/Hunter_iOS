//
//  HunterSettingsModel.swift
//  Hunter
//
//  Created by Ajith Kumar on 05/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import Foundation

public class HunterSettingsModel {
    public var notification_status : Bool?
    public var show_me_on_app : Bool?
    public var acccount_status : Int?
    
    public var show_me_on_hunterapp : Bool?
    public var account_status : Int?
    
    func initWithDict(dictionary: NSDictionary) -> HunterSettingsModel{
        notification_status = dictionary["notification_status"] as? Bool
        show_me_on_app = dictionary["show_me_on_app"] as? Bool
        acccount_status = dictionary["acccount_status"] as? Int
        
        show_me_on_hunterapp = dictionary["show_me_on_hunterapp"] as? Bool
        account_status = dictionary["account_status"] as? Int
        
        return self
    }
}
