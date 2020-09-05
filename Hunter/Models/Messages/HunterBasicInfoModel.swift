//
//  HunterBasicInfoModel.swift
//  Hunter
//
//  Created by Ajith Kumar on 05/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import Foundation

public class HunterBasicInfoModel {
    public var first_name : String?
    public var last_name : String?
    public var email : String?
    
    func initWithDict(dictionary: NSDictionary) -> HunterBasicInfoModel{
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        
        return self
    }
}
