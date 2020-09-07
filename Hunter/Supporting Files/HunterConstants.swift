//
//  HunterConstants.swift
//  Hunter
//
//  Created by Zubin Manak on 9/20/19.
//  Copyright © 2019 Zubin Manak. All rights reserved.
//

import UIKit

enum API{
     //Base url
    
    static let candidateBaseURL = "https://huntrapp.chkdemo.com/api/candidate/"
    static let recruiterBaseURL = "https://huntrapp.chkdemo.com/api/recruiter/"
 
    //Candidate
    static let loginURl = "login"
    static let profileDetailsURL = "me"
     static let registerCandidateURL = "registration/save-candidate"
    static let registerPreferedWorkTypeURL = "registration/get-registration-step2-lookup-data"
    static let registerSavePreferedWorkTypeURL = "registration/save-preferred-work-type-step2"
    static let registerGetCompanyDataStep3URL = "registration/get-company-data-step-3"
    static let registerPreferedLocationsURL = "registration/get-preferred-locations"
    static let registerSavePreferedLocationsURL = "registration/save-candidate-preferred-locations"
    static let registerPreferedJobsURL = "registration/get-preferred-job-functions"
    static let registerSavePreferedJobsURL = "registration/save-candidate-preferred-jobs"
    static let registerPreferedSkillsURL = "registration/get-preferred-job-skills"
    static let registerSavePreferedSkillsURL = "registration/save-preferred-job-skills"
    static let saveWorkedInUAEURL = "registration/save-worked-in-uae"
    static let registerPreferedCompaniesURL = "registration/prefered-companies"
    static let registerSavePreferedCompaniesURL = "registration/save-worked-companies-in-uae"
    static let saveCurrentWorkStatusURL = "registration/save-current-work-status"
    static let saveCandidateJobExpURL = "registration/save-candidate-job-experience"
    
    
    
    static let saveLangURL = "profile/add-language"
    static let deleteLangURL = "profile/delete-language"
    static let addAchievementURL = "profile/add-achievement"
    static let deleteAchievementURL = "profile/delete-achievement"
    static let addSocialMediaURL = "profile/add-social-media"
    static let deleteSocialMediaURL = "profile/delete-social-media"
    static let addWorkExpURL = "profile/add-work-experience"
    static let deleteWorkExpURL = "profile/delete-work-experience"
    static let addEduQualificationURL = "profile/add-education-qualification"
    static let deleteEduQualificationURL = "profile/delete-education-qualification"

    static let getJobsURL = "jobs"
    static let getChatURl = "chat"
    static let getMatchesURL = "chat/matches"
    static let getChatCandidateMessagesURL = "chat/job-messages"// for getting personal messages while candidate login
    static let sendCandidateMessageURL = "chat/send-job-message"// for sending message from candidate login
    static let profileURL = "profile"
    
    static let settingsURL = "settings"
    static let changeNotifyStatusURl = "settings/notification"
    static let changeShowStatusURL = "settings/show-me-on-hunter"
    static let basicInformationURL = "basic-information"
    static let resetPasswordURL = "reset-password"
    static let disableCandidateAccURL = "disable-account"
    static let enableCandidateAccURL = "enable-account"
    static let disableRecruiterAccURL = "settings/disable-account"
    static let enableRecruiterAccURL = "settings/enable-account"
    static let rateUsURL = "support/rating"
    static let elevatorPitchURL = "jobs/elevator-pitch"
    static let supportCategoriesURL = "support/report-category"
    static let reportProblemURL = "support/report-problem"
    static let jobsSwipesURL = "jobs/swipe"
    static let profileUpdateURL = "profile/update"
    static let getJobExpURL = "registration/get-job-experiences"

    static let getWorkExpURL = "registration/get-lookup-data-experiences"
    
    //Recruiter
    static let candidate_profileURL = "candidate-profile"
    static let detailsURL = "details"
    static let registerRecruiterURL = "registration/save-recruiter"
    static let registerCompanyIndustryURL = "registration/company-industry"
    static let registerCompanyDataURL = "registration/company-data"
    static let registerCompanySizeURL = "registration/company-size"
    static let registerCompanyTypeURL = "registration/company-type"
    static let registerSaveCompanyBioStep3URL = "registration/save-company-bio-step-3"
    static let registerSaveCompanyFoundedURL = "registration/save-company-founded"
    static let registerSaveCompanyDetailsURL = "registration/save-company-details"
    static let registerSaveCompanyLogoURL = "registration/save-company-logo"
    static let registerUpdateCompanyLogoURL = "profile/update-company-logo"
    static let registerUpdateCompanyBannerImageURL = "profile/update-company-banner-image"
    static let registerSaveAdditionalMediaURL = "registration/save-additional-media"
    static let registerDeleteAdditionalMediaURL = "registration/delete-additional-media"
    static let registerFetchSocialMediaURL = "registration/fetch-social-media"
    static let registerSaveSocialMediaURL = "registration/save-social-media"
    static let registerDelSocialMediaURL = "registration/delete-social-media"
    static let registerSaveCompanyFinalURL = "registration/save-company-final"
    static let registerCompleteRegistrationURL = "registration/complete-registration"
    static let registerVerifyCompanyURL = "registration/verify-company"
    static let getRecruiterJobsURL = "job"
    static let getCandidateSuggsURL = "candidate/sugessions"
    static let getCandidateSwipeOldURL = "candidate/swipes"
    static let getCandidateSwipeURL = "candidate-swipe"
    static let getSendIntroMsgsURL = "candidate-swipe/elevator-pitch"
    static let getSettingsSubAccURL = "settings/sub-accounts"
    static let getSettingsDisableAccURL = "settings/disable-account"
    static let getSettingsEnableAccURL = "settings/enable-account"
    static let getSaveSubAccURL =
    "settings/save-sub-accounts"
    static let getDisAbleSubAccURL = "settings/disable-sub-accounts"
    static let getDelSubAccURL = "settings/delete-sub-accounts"
    static let enableNotificationURL = "settings/enable-notification"
    static let getJobsForFilterURL = "candidate/get-jobs-for-filter"
    static let getChatRecruiterMessagesURL = "chat/candidate-chat-messages"// for getting personal messages while recruiter login
    static let sendRecruiterMessageURL = "chat/send-message-to-candidate"// for sending message from candidate login
    static let getTypesURL = "job/get-types"
    static let getPrefLocURL = "job/get-preferred-locations"
    static let getLookUpData = "job/get-job-lookup-data"
    static let getPostJobURL = "job/post-new-job"
    static let getPostJobAsDraftURL = "job/post-new-job-as-draft"
    static let getJobListURL = "job/get-job-list"
    static let forgotPasswordURL = "forgot-password"
    static let createNewPassURL = "create-new-password"
    static let reportErrorURL = "settings/report-error"
    
    static let updateCompanyBusinessTypeURL = "profile/update-company-business-type"
    static let updateCompanySizeURL = "profile/update-company-size"
    
    static let getAdditionalMediaURL = "profile/get-additional-media"
    static let addAdditionalImagesURL = "profile/add-additional-images"
    
    static let candidateSuggestionsURL = "candidate-suggestions"
    static let updateCompanyBioURL = "profile/update-company-bio"
 }
enum FontName: String {
    case MontserratRegular            = "Montserrat-Regular"
    case MontserratBold               = "Gill Sans SemiBold"
    case MontserratMedium              = "Montserrat-Medium"
    case MontserratLight              = "Montserrat-Light"
    case MontserratSemiBold        = "Montserrat-SemiBold"
}
enum Color{
    static let darkVioletColor = UIColor(red: 55.0/255.0, green: 31.0/255.0, blue: 118.0/255.0, alpha: 1)//#371F76
}
