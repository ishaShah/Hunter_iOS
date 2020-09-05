//
//  HunterProfileModel.swift
//  Hunter
//
//  Created by Ajith Kumar on 05/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import Foundation

public class HunterProfileModel {
    public var id : Int?
    public var first_name : String?
    public var last_name : String?
    public var email : String?
    public var profile_img : String?
    public var phone_number : String?
    public var location_id : String?
    public var description : String?
    public var cv : String?
    public var status : String?
    public var email_verified : String?
    public var phone_verified : String?
    public var otp : String?
    public var preferred_work_type : String?
    public var preferred_salary : String?
    public var worked_in_uae : String?
    public var currently_working : String?
    public var show_me_on_app : String?
    public var notification_status : String?
    public var created_at : String?
    public var updated_at : String?
    
    func initWithDict(dictionary: NSDictionary) -> HunterProfileModel{
        id = dictionary["id"] as? Int
        first_name = dictionary["first_name"] as? String
        last_name = dictionary["last_name"] as? String
        email = dictionary["email"] as? String
        profile_img = dictionary["profile_img"] as? String
        phone_number = dictionary["phone_number"] as? String
        location_id = dictionary["location_id"] as? String
        description = dictionary["description"] as? String
        cv = dictionary["cv"] as? String
        status = dictionary["status"] as? String
        email_verified = dictionary["email_verified"] as? String
        phone_verified = dictionary["phone_verified"] as? String
        otp = dictionary["otp"] as? String
        preferred_work_type = dictionary["preferred_work_type"] as? String
        preferred_salary = dictionary["preferred_salary"] as? String
        worked_in_uae = dictionary["worked_in_uae"] as? String
        currently_working = dictionary["currently_working"] as? String
        show_me_on_app = dictionary["show_me_on_app"] as? String
        notification_status = dictionary["notification_status"] as? String
        created_at = dictionary["created_at"] as? String
        updated_at = dictionary["updated_at"] as? String
        
        return self
    }
}
