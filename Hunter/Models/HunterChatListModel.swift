//
//  HunterChatListModel.swift
//  Hunter
//
//  Created by Ajith Kumar on 05/01/20.
//  Copyright © 2020 Zubin Manak. All rights reserved.
//

import Foundation

public class HunterChatListModel {
    public var job_id : Int?
    public var company_name : String?
    public var logo : String?
    public var title : String?
    public var latest_message : String?
    //recruiter
    public var profile_img : String?
    public var candidate_id : Int?
    public var candidate_name : String?
    public var un_read_messages : Int?
    func initWithDict(dictionary: NSDictionary) -> HunterChatListModel{
        job_id = dictionary["swipe_id"] as? Int
        company_name = dictionary["company_name"] as? String
        logo = dictionary["square_logo"] as? String
        title = dictionary["job_title"] as? String
        latest_message = dictionary["latest_message"] as? String
        //recruiter
        profile_img = dictionary["profile_image"] as? String
        candidate_name = dictionary["candidate_name"] as? String
        candidate_id = dictionary["swipe_id"] as? Int
        un_read_messages = dictionary["un_read_messages"] as? Int
        
//        swipe_id'
//        'candidate_name'
//        'profile_image'
//        'job_title'
//        'latest_message'
//        'un_read_messages
        return self
    }
}
